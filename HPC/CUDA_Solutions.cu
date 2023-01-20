!pip install git+https://github.com/andreinechaev/nvcc4jupyter.git
%load_ext nvcc_plugin
%%cu
// Exo1: addition de deux vecteurs en mobilisant plusieurs threads
#include <stdio.h>
#include <stdlib.h>
#define N 1000
#define THREAD_PER_BLOCK 512

__global__ void add (int *a , int *b , int *c) 
{  
   int indice = threadIdx.x + blockIdx.x * blockDim.x;
   if (indice < N)
      c[indice] = a[indice] + b[indice]; 
} 

int main (){
   int *a, * b, *c;
   int *gpu_a, *gpu_b, *gpu_c;
   int size = N * sizeof (int); 
      
   cudaMalloc ((void **) &gpu_a, size); 
   cudaMalloc ((void **) &gpu_b, size);
   cudaMalloc ((void **) &gpu_c, size); 
   
   a = (int *) malloc (size); 
   b = (int *) malloc (size); 
   c = (int *) malloc (size); 

   for (int i = 0; i < N; i++)
      {
       a[i] = i;
      }

   for (int i = 0; i < N; i++)
      {
       b[i] = 2*i;
      } 
   
   cudaMemcpy (gpu_a, a, size, cudaMemcpyHostToDevice); 
   cudaMemcpy (gpu_b, b, size, cudaMemcpyHostToDevice);
 
   add <<< (N + THREAD_PER_BLOCK) / THREAD_PER_BLOCK, THREAD_PER_BLOCK >>> (gpu_a, gpu_b, gpu_c);

   cudaMemcpy (c, gpu_c, size, cudaMemcpyDeviceToHost);

   cudaFree(gpu_a); cudaFree(gpu_b); cudaFree(gpu_c);

   for (int i = 0; i < N; i++)
      {
       printf("%d\n", c[i]);
      }

   free(a); free(b); free(c);

   return 0;
}
//------------------------------------------------------------------
%%cu
// Exo2: partie 1, threads appartenant au meme bloc, donc 
// M=N=nbr_threadsTotal=capacitéVecteur et un seul bloc = 1
#include <stdio.h>
#include <stdlib.h>
#define N 512

__global__ void dot (int *a , int *b , int *c) 
{
   __shared__ int temp[N]; 	                                                             
   temp[threadIdx.x] = a[threadIdx.x] * b[threadIdx.x]; 
   
   __syncthreads ();

   // Le thread 0 effectue la somme 
   if (threadIdx.x == 0) {
      int sum = 0;
      for (int i = 0; i < N; i++)
              sum += temp[i];
              *c = sum;        
      }
    } 

int main (){
   int *a, * b, *c;
   int *gpu_a, *gpu_b, *gpu_c;
   int size = N * sizeof (int); 
      
   cudaMalloc ((void **) &gpu_a, size); 
   cudaMalloc ((void **) &gpu_b, size);
   cudaMalloc ((void **) &gpu_c, sizeof (int)); 
   
   a = (int *) malloc (size);
   b = (int *) malloc (size);
   c = (int *) malloc (sizeof (int)); 

   for (int i = 0; i < N; i++)
      {
       a[i] = i;
      }


   for (int i = 0; i < N; i++)
      {
       b[i] = 2*i;
      }

   cudaMemcpy (gpu_a, a, size, cudaMemcpyHostToDevice); 
   cudaMemcpy (gpu_b, b, size, cudaMemcpyHostToDevice);
 
   dot <<<1, N>>> (gpu_a, gpu_b, gpu_c);

   cudaMemcpy (c, gpu_c, sizeof(int), cudaMemcpyDeviceToHost);

   cudaFree(gpu_a); cudaFree(gpu_b); cudaFree(gpu_c);

   printf("%d\n", *c);

   free(a); free(b); free(c);

   return 0;}

//------------------------------------------------------------------
%%cu
// Exo2: partie 2, threads appartenant a déffirents blocs
#include <stdio.h>
#include <stdlib.h>
#define N 2048
#define THREAD_PER_BLOCK 512

__global__ void dot (int *a , int *b , int *c) 
{
   //chaque bloc possède son vecteur temp partager entre les threads du meme bloc
   __shared__ int temp[THREAD_PER_BLOCK];
   int indice = threadIdx.x + blockIdx.x * blockDim.x;
   temp[threadIdx.x] = a[indice] * b[indice];
   __syncthreads ();

   // Le thread 0 de chaque bloc effectue une somme locale qu'il ajoute à la somme globale "atomiquement" 
   if (threadIdx.x == 0) {
      int sum = 0;
	    for (int i = 0; i < THREAD_PER_BLOCK; i++)
           sum += temp[i];
      atomicAdd (c, sum);
   }
} 

int main (){
   int *a, * b, *c;
   int *gpu_a, *gpu_b, *gpu_c;
   int size = N * sizeof (int); 
      
   cudaMalloc ((void **) &gpu_a, size); 
   cudaMalloc ((void **) &gpu_b, size);
   cudaMalloc ((void **) &gpu_c, sizeof (int)); 
   
   a = (int *) malloc (size); 
   b = (int *) malloc (size);
   c = (int *) malloc (sizeof (int)); 

   for (int i = 0; i < N; i++)
      {
       a[i] = i;
      }

   for (int i = 0; i < N; i++)
      {
       b[i] = 2*i;
      }

   cudaMemcpy (gpu_a, a, size, cudaMemcpyHostToDevice); 
   cudaMemcpy (gpu_b, b, size, cudaMemcpyHostToDevice);
   
   dot <<<N / THREAD_PER_BLOCK, THREAD_PER_BLOCK >>> (gpu_a, gpu_b, gpu_c);

   cudaMemcpy (c, gpu_c, sizeof(int), cudaMemcpyDeviceToHost);

   cudaFree(gpu_a); cudaFree(gpu_b); cudaFree(gpu_c);

   printf("%d\n", *c);

   free(a); free(b); free(c);

   return 0;}

//------------------------------------------------------------------
%%cu
// Exo 3 : inverser un vecteur en utilisant differents blocs (matrice logique)
#include <stdio.h>
#include <stdlib.h>
#define N 2048
#define THREAD_PER_BLOCK 512

__global__ void reverseArray (int *d_b , int *d_a)
{
  int old_id = threadIdx.x + blockIdx.x * blockDim.x; 
  int new_id = N - 1 - old_id ; 
  d_b[old_id] = d_a[new_id];
}

int main (){
   int *h_a, *d_a, *d_b;
   int size = N * sizeof (int); 
   h_a = (int *) malloc (size);

   for (int i = 0; i < N; i++)
   {
       h_a[i] = i;
   }

   cudaMalloc ((void **) &d_a, size); 
   cudaMalloc ((void **) &d_b, size); 
   cudaMemcpy (d_a, h_a, size, cudaMemcpyHostToDevice);
 
   reverseArray <<< N/THREAD_PER_BLOCK, THREAD_PER_BLOCK >>>(d_b, d_a);

   cudaMemcpy (h_a, d_b, size, cudaMemcpyDeviceToHost);

   cudaFree(d_a); cudaFree(d_b); 

   for (int i = 0; i < N; i++)
   {
       printf("%d\n", h_a[i]);
   }


   free(h_a);

   return 0;}

//------------------------------------------------------------------
%%cu
// parallélisation de l'algorithme du calcul nobre pi
#include <stdio.h>
#include <stdlib.h>
#define NUM_BLOCKS 196 
#define NUM_THREADS 512 

__global__ void cal_pi(double *sum, double steps, long nb_steps) 
{
  double x;

  int idx = blockIdx.x * blockDim.x + threadIdx.x; 
 
  if (idx > 0 && idx <= nb_steps)
     x = (idx - 0.5) * steps;
     sum[idx] = 4.0/(1.0 + x*x);
}

int main() 
{

   long nb_steps = 100000;
   double pi = 0.0;
   double steps = 1.0/(double)nb_steps;

   double *sumHost, *sumDev; 
   
   dim3 dimGrid(NUM_BLOCKS,1); 
   dim3 dimBlock(NUM_THREADS,1);

   size_t size = NUM_BLOCKS * NUM_THREADS * sizeof (double); 

   sumHost = (double *) malloc (size);

   cudaMalloc ((void **) &sumDev, size); 
   cudaMemset (sumDev, 0, size);

   cal_pi <<<dimGrid, dimBlock>>> (sumDev, steps, nb_steps);

   cudaMemcpy (sumHost, sumDev, size, cudaMemcpyDeviceToHost);

   for(int tid = 1; tid <= nb_steps; tid++)
      pi += sumHost[tid];

   pi *= steps;

   printf("PI=%f\n", pi);

   free (sumHost);

   cudaFree (sumDev);

   return 0;}
//------------------------------------------------------------------
%%cu
// Exo 5: multiplication scalaire de deux victeurs
#include <stdio.h>
#include <stdlib.h>
#define BLOCKSIZE 16
#define SIZE 128

__global__ void vectvectshared (int *A, int *B, int *r)
{    
  __shared__ int temp[SIZE];
	
  int i = threadIdx.x; 
  int j = threadIdx.y;

  int ind  = j + (blockDim.x * i);

  if (ind < SIZE)
     temp[ind] = A[ind] * B[ind];
    
   __syncthreads();

   if(ind == 0){
     int sum = 0;
     for(int i = 0; i < SIZE; i++)
        sum += temp[i];
     *r = sum;
   }
}

void fill_dp_vector (int* vec,int size)
{
   int ind;
   for(ind = 0; ind < size; ind++)
        vec[ind] = 3*ind;
}

int main ()
{
   int *hostA, *hostB, *res;
   int *devA, *devB, *devres;

   int vlen;

   vlen=SIZE;
	
   dim3 threadspblock(BLOCKSIZE,BLOCKSIZE);

   hostA = (int *) malloc (vlen * sizeof(int));
   hostB = (int *) malloc (vlen * sizeof(int));
   res = (int *) malloc (sizeof(int));
   
   fill_dp_vector (hostA, vlen);   
   fill_dp_vector (hostB, vlen);

   cudaMalloc((void **) &devA, vlen * sizeof(int));
   cudaMalloc((void **) &devB, vlen * sizeof(int));
   cudaMalloc((void **) &devres, sizeof(int));

   cudaMemcpy(devA, hostA, vlen * sizeof(int), cudaMemcpyHostToDevice);
   cudaMemcpy(devB, hostB, vlen * sizeof(int), cudaMemcpyHostToDevice);
		
   vectvectshared<<<1, threadspblock>>>(devA, devB, devres);

   cudaMemcpy (res, devres, sizeof(int), cudaMemcpyDeviceToHost);
 
   cudaFree (devA);
   cudaFree (devB);
   cudaFree (devres);

   printf("%d\n", *res);

   free (hostA);
   free (hostB);
   free (res);

   return 0;}
