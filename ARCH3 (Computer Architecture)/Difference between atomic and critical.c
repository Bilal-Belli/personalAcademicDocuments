#include <stdio.h>
#include <omp.h>

int main(void) {
  int count = 0;
  #pragma omp parallel {
    #pragma omp barrier {
      #pragma omp critical {
        #pragma omp atomic
        count++; // count is updated by only a single thread at a time
      }
    }
  }
  printf_s("Number of threads: %d\n", count);
}