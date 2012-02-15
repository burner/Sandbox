/*
 * main.c
 *
 *  Created on: Dec 31, 2008
 *      Author: Suvash Sedhain
 *  Multiple producer and Multiple consumer solution using Semaphores
 *      Note: semaphore.P() is actually sem_wait() and semaphore.V() is sem_post()
 *      as defined in semaphore.h
 *
 *      Ref:
 *      - Operating System Concepts : Abraham Silberschatz, Peter Baer Galvin, Greg Gagne
 *      - Operating Systems, William Stallings
 *      - Professor John D. Kubiatowicz lectures notes, University of California, Berkeley
 *        website: http://inst.eecs.berkeley.edu/~cs162
 *
 */

#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <stdio.h>
#define BUFFER_SIZE 5
const int MAX_PRODUCER = 20;
const int MAX_CONSUMER = 20;

// information to maintain the circular queue data structure
int head = 0;
int tail = 0;

//shared buffer
int buffer[BUFFER_SIZE];
// mutex lock for buffer
pthread_mutex_t mutex;  
//semaphores for specifying the empty and full
sem_t emptyBuffers;
sem_t fullBuffer;

//initialze the locks
void initialize_locks()
{
    pthread_mutex_init(&mutex,NULL);
    sem_init(&emptyBuffers,0,5);
    sem_init(&fullBuffer,0,0);
}

// Produce random value to shared buffer
void *producer(void *param)
{
  int item;
  while(1)
  {
      item = rand();
      sem_wait(&emptyBuffers);
      pthread_mutex_lock(&mutex);
      buffer[tail] = item ;
      tail = (tail+1) % BUFFER_SIZE;
      printf ("producer: inserted %d \n", item);
      fflush (stdout);
      pthread_mutex_unlock(&mutex);
      sem_post(&fullBuffer);

  }
  printf ("producer quiting\n");  fflush (stdout);
}

//consume values from the shared buffer
void *consumer(void *param)
{
   int item;
   while (1)
   {
       sem_wait(&fullBuffer);
       pthread_mutex_lock(&mutex);
       item = buffer[head];
       head = ( head + 1) % BUFFER_SIZE;
       printf ("consumer: removed %d \n", item);
       fflush (stdout);
       pthread_mutex_unlock(&mutex);
       sem_post(&emptyBuffers);
   }
}

int main( int argc, char *argv[])
{
   int i, sleep_time = 100, no_of_consumer_threads = 2, no_of_producer_threads = 20;
   pthread_t producer_id[MAX_PRODUCER], consumer_id[MAX_CONSUMER];
   initialize_locks();
   // create producer threads
   for(i = 0; i < no_of_producer_threads; i++)
   {
       if (pthread_create(&producer_id[i],NULL,producer,NULL) != 0)
       {
           fprintf (stderr, "Unable to create producer thread\n");
           return -1;
       }
   }
   // create consumer threads
   for(i = 0; i < no_of_consumer_threads; i++)
   {
       if (pthread_create(&consumer_id[i],NULL,consumer,NULL) != 0)
       {
           fprintf (stderr, "Unable to create consumer thread\n");
       }
   }
   sleep(sleep_time);
   return 0;
}
