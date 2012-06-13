hello:
	gcc sleep.c -o sleep

clean:
	rm sleep
	rm -r sleep-*
	rm *.result