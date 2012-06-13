#include <stdio.h>
#include <time.h>
#include <signal.h>

int __nsleep(const struct timespec *req, struct timespec *rem)
{
  struct timespec temp_rem;
  if(nanosleep(req,rem)==-1)
    __nsleep(rem,&temp_rem);
  else
    return 1;
}

int msleep(unsigned long milisec)
{
  struct timespec req={0},rem={0};
  time_t sec=(int)(milisec/1000);
  milisec=milisec-(sec*1000);
  req.tv_sec=sec;
  req.tv_nsec=milisec*1000000L;
  __nsleep(&req,&rem);
  return 1;
}

int main ( int argc, char *argv[] )
{
  if ( argc != 2 ) /* argc should be 2 for correct execution */
    {
      /* We print argv[0] assuming it is the program name */
      printf( "Usage: %s sleeptime(ms) \n", argv[0] );
    }
  else 
    {
      //print the sleep time
      int sleeptime = atoi(argv[1]);
      // call msleep with sleep time
      msleep(sleeptime);
      return 0;
   }
}
