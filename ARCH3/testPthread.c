#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <pthread.h>
#define Num_threads 20
#define N 1000

float a[N][N];
float l[N];
pthread_mutex_t mutex; // la variable mutex doit être visible par tous les threads

void print_matrix(float matrix[N][N], int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++)
        printf("%f ", matrix[i][j]);
        printf("\n");
    }
}

void random_fill(float matrix[N][N], int size) {
    srand(time(0));
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
        matrix[i][j] = ((rand() % 20) + 1);
        }
    }
}

void * gaussian(void * arg) {
    // aussi la table l sera aussi global (partager entre les threads
    int * i = (int * ) arg;
    int maxIT = (N / Num_threads) * ( * i + 1);
    int firstIT = ( * i) * (N / Num_threads);
    for (int iii = firstIT; iii < maxIT; iii++) {
        for (int j = iii; j < N; j++) {
        if (iii != j) {
            pthread_mutex_lock( & mutex); // Verrouillage de mutex
            l[j] = (a[j][iii] / a[iii][iii]);
            pthread_mutex_unlock( & mutex); // déverrouillage de mutex
        }
        for (int k = 0; k < N; k++) {
            if (j == iii) {
            pthread_mutex_lock( & mutex); // Verrouillage de mutex
            a[j][k] = a[iii][k];
            pthread_mutex_unlock( & mutex); // déverrouillage de mutex
            } else {
            if (k < j) {
                pthread_mutex_lock( & mutex); // Verrouillage de mutex
                a[j][k] = 0;
                pthread_mutex_unlock( & mutex); // déverrouillage de mutex
            } else {
                pthread_mutex_lock( & mutex); // Verrouillage de mutex
                a[j][k] = a[j][k] - l[j] * a[iii][k];
                pthread_mutex_unlock( & mutex); // déverrouillage de mutex
            }
            }
        }
        }
    }
    pthread_exit(NULL);
}

int main(void) {
    srand(time(0));
    random_fill(a, N);
    //printf("***A***\n");
    //print_matrix(a, N);
    clock_t start_t = clock(); //Début_temps
    pthread_t threads[Num_threads];
    // j'ai fait la matrice a global
    // la taille 'size' est aussi global comme l'énoncé N=size
    int i; //pour passer numero du thread et donc je peut constater l'intervalle dont il doit travaillé
    for (i = 0; i < Num_threads; i++) { //boucle de creation des threads
        pthread_create( & threads[i], NULL, gaussian, (void * ) & i);
    }
    for (i = 0; i < Num_threads; i++) {
        pthread_join(threads[i], NULL);
    }
    clock_t end_t = clock(); //Fin_temps
    double runing_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    //printf("\n***U***\n");
    //print_matrix(a, N);
    printf("\nOrdre de la matrice = %d \n ", N);
    printf("\nLe temps Parallèle pour le calcul de la décomposition Gaussienne de la matrice = %f s.\n ", runing_t);
    return 0;
}