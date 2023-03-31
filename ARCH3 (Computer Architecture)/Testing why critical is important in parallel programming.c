#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
  const int N = 100;
  int a[N];
  for (int i = 0; i < N; i++)
    a[i] = i;
  int local_sum, sum;
  #pragma omp parallel private(local_sum)
  {
    local_sum = 0;

    //the array is distributde statically between threads
    #pragma omp for schedule(dynamic)
    for (int i = 0; i < N; i++) {
      local_sum += a[i];
    }

    printf("local_sum=%d theread number=%d\n", local_sum, omp_get_thread_num());
    //#pragma omp critical
    #pragma omp barrier
    sum += local_sum;
  }
  printf("sum=%d should be %d\n", sum, N * (N - 1) / 2);
}
