/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

#include <stdio.h>
#include <cutil_inline.h>
#include <shrUtils.h>
#include <shrQATest.h>

const char *sSDKsample = "concurrentKernels";

// This is a kernel that does no real work but runs at least for a specified number of clocks
__global__ void clock_block(clock_t* d_o, clock_t clock_count)
{ 
	clock_t start_clock = clock();
	
	clock_t clock_offset = 0;

	while( clock_offset < clock_count ) {
		clock_offset = clock() - start_clock;
	}

	d_o[0] = clock_offset;
}

// Single warp reduction kernel
__global__ void sum(clock_t* d_clocks, int N)
{
	__shared__ clock_t s_clocks[32];

	clock_t my_sum = 0;

	for( int i = threadIdx.x; i < N; i+= blockDim.x ) {
		my_sum += d_clocks[i];
	}

	s_clocks[threadIdx.x] = my_sum;
	syncthreads();	

	for( int i=16; i>0; i/=2) {
		if( threadIdx.x < i ) {
			s_clocks[threadIdx.x] += s_clocks[threadIdx.x + i];
		}
		syncthreads();	
	}	

	d_clocks[0] = s_clocks[0];
}

int main(int argc, char **argv)
{
    int nkernels = 16;               // number of concurrent kernels
    int nstreams = nkernels + 1;    // use one more stream than concurrent kernel
    int nbytes = nkernels * sizeof(clock_t);   // number of data bytes
    float kernel_time = 10; // time the kernel should run in ms
//    float elapsed_time;   // timing variables
    int cuda_device = 0;

    shrQAStart(argc, argv); 

    // get number of kernels if overridden on the command line
    if (cutCheckCmdLineFlag(argc, (const char **)argv, "nkernels")) {
        cutGetCmdLineArgumenti(argc, (const char **)argv, "nkernels", &nkernels);
        nstreams = nkernels + 1;
    }

    // use command-line specified CUDA device, otherwise use device with highest Gflops/s
    cuda_device = cutilChooseCudaDevice(argc, argv);

    cudaDeviceProp deviceProp;
    cutilSafeCall( cudaGetDevice(&cuda_device));	

    cutilSafeCall( cudaGetDeviceProperties(&deviceProp, cuda_device) );

    // allocate host memory
    clock_t *a = 0;                     // pointer to the array data in host memory
    cutilSafeCall( cudaMallocHost((void**)&a, nbytes) ); 

    // allocate device memory
    clock_t *d_a = 0;             // pointers to data and init value in the device memory
    cutilSafeCall( cudaMalloc((void**)&d_a, nbytes) );

    // allocate and initialize an array of stream handles
    cudaStream_t *streams = (cudaStream_t*) malloc(nstreams * sizeof(cudaStream_t));
    for(int i = 0; i < nstreams; i++)
        cutilSafeCall( cudaStreamCreate(&(streams[i])) );

    cudaEvent_t *kernelEvent;
    kernelEvent = (cudaEvent_t*) malloc(nkernels * sizeof(cudaEvent_t));
    for(int i = 0; i < nkernels; i++)
        cutilSafeCall( cudaEventCreateWithFlags(&(kernelEvent[i]), cudaEventDisableTiming) );

    //////////////////////////////////////////////////////////////////////
    // time execution with nkernels streams
    clock_t total_clocks = 0;
    clock_t time_clocks = kernel_time * deviceProp.clockRate;
    //shrLog("Time Clocks time is: %d", time_clocks);	
    // cudaEventRecord(start_event, 0);
    // queue nkernels in separate streams and record when they are done
    for( int i=0; i<nkernels; ++i)
    {
        clock_block<<<1,1,0,streams[i]>>>(&d_a[i], time_clocks );
        total_clocks += time_clocks;
        cutilSafeCall( cudaEventRecord(kernelEvent[i], streams[i]) );
	
        // make the last stream wait for the kernel event to be recorded
        cutilSafeCall( cudaStreamWaitEvent(streams[nstreams-1], kernelEvent[i],0) );
    }

    // queue a sum kernel and a copy back to host in the last stream. 
    // the commands in this stream get dispatched as soon as all the kernel events have been recorded
    sum<<<1,32,0,streams[nstreams-1]>>>(d_a, nkernels);
    cutilSafeCall( cudaMemcpyAsync(a, d_a, sizeof(clock_t), cudaMemcpyDeviceToHost, streams[nstreams-1]) );
 
    // at this point the CPU has dispatched all work for the GPU and can continue processing other tasks in parallel

    // in this sample we just wait until the GPU is done

    // release resources
    for(int i = 0; i < nkernels; i++) {
        cudaStreamDestroy(streams[i]); 
        cudaEventDestroy(kernelEvent[i]);
    }
    free(streams);
    free(kernelEvent);

    cudaFreeHost(a);
    cudaFree(d_a);

    cutilDeviceReset();
  return 0;    
}