#include <sys/types.h>
#include <semaphore.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <unistd.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <stdio.h>

#define N 3
#define iterations 2
#define nplace N
#define splein 0
#define svide 1

struct sembuf Psvide = {
  svide,
  -1,
  0
};
struct sembuf Vsvide = {
  svide,
  1,
  0
};
struct sembuf Psplein = {
  splein,
  -1,
  0
};
struct sembuf Vsplein = {
  splein,
  1,
  0
};

int memp;
int sem;

void Voyageur(void) {
    int place;
    int *Bus;
    int pid;
    pid = getpid();
    printf("\n début de procedure voyageur : %d\n", pid);
    /*attachement de segment*/
    Bus = shmat(memp, 0, 0);
    if (Bus == NULL) {
      printf("\n Erreur: mémoire partagé non attaché\n");
      exit(7);
    }
    /*P(svide)*/
    semop(sem, &Psvide, 1);
    place = Bus[nplace];
    Bus[place] = pid;
    printf("\n le voyageur %d monte dans le Bus à la place %d\n", Bus[place], place);
    place = (place + 1) % N;
    Bus[nplace] = place;
    if (place == 0) {
    /*v(splein)*/
      semop(sem, & Vsplein, 1);
    } else {
    /*v(svide)*/
      semop(sem, & Vsvide, 1);
    /*detachement de segment*/
      shmdt(Bus);
      printf("\n fin de la procedure Voyageur %d ===\n", getpid());
      exit(5);
	}
 }

    void Conducteur(void) {
      int i;
      int *Bus;
      int k;
      printf("\n Début de procedure conducteur : %d\n", getpid());
      /*attachement du segment*/ 
      Bus = shmat(memp, 0, SHM_RDONLY);
      if (Bus == NULL) {
        printf("\n Erreur: mémoire partagé non attaché\n");
        exit(8);
      }
      for (i = 0; i < iterations; ++i){ /*p(splein)*/semop(sem, & Psplein, 1);
      printf("\n fin de voyage : les voyageurs descendent du Bus \n");
      for (k = 0; k < N; ++k)
        {printf("\n voyage :%d ; le voyageur %d qui occupait la place %d, descend du Bus \n",i,Bus[k],k);}
      /*v(svide)*/ 
      semop(sem,&Vsvide,1);
	}
      /*detachement de segment*/
      shmdt(Bus);
      printf("\n fin de la procedure Conducteur %d ===\n", getpid());
      exit(4);
    }

    /*Program principal*/

    int main(void) {
      int i;/*parametre de boucle*/
      int p;/*parametre de fork*/
      int *Bus;

      union semun {
        int val;
        struct semid_ds *buf;
        unsigned short *array;
      }
      svideinit, spleininit;

      /* Création d'un segment de mémoire partagée contenant N+1 entiers : Bus + nplace */
      memp = shmget(IPC_PRIVATE, (N + 1) * sizeof(int), IPC_CREAT | 0666);
      if (memp == -1) {
        printf("\nErreur de création de la mémoire partagée\n");
        exit(1);
      }

      /* Attachement du segment de mémoire partagée pour initialiser L'index nplace */
      Bus = shmat(memp, 0, 0);

      /* Initialisation de L'index des places */
      Bus[nplace] = 0; /*Valeur initiale de l'index nplace=0 (Bus[nplace])*/

      /* Détachement du segment de mémoire partagée*/
      shmdt(Bus);

      /* Création d'un tableau de 2 sémaphores splein et svide*/
      sem = semget(IPC_PRIVATE, 2, IPC_CREAT | 0666);
        if (sem == -1) {
          printf("\nErreur de création des sémaphore\n");
          exit(2);
        }

      /* Initialisation du sémaphore splein à 0*/
      spleininit.val = 0; /* Valeur initiale de splein */
      semctl(sem, splein, SETVAL, spleininit);

      /*Initialisation du Sémaphore svide 1 */
        svideinit.val = 1; /*Valeur initiale de svide */
      semctl(sem, svide, SETVAL, svideinit);
      /*Création du processus qui execute une seul foix */
        p = fork();
      if (p == -1) {
        printf("\nErreur de creation de processus\n");
        exit(3);
      }
      if(p == 0){
        Conducteur(); /*metter son procedure d'appele*/
        exit(4);
      }
      /* Création du processus qui execute plusieurs fois */ 
      for (i= 0; i < 6; ++i) /* dans ce cas il execute 6 fois*/
        {p = fork();
      if (p == -1) {
        printf("\nErreur de creation de processus\n");
        exit(3);
      }
      if (p == 0) {
        Voyageur();  /*metter son procedure d'appele*/
        exit(4);
      }}
      /*Attendre la terminaison des fils */
      while ((p = wait(NULL) != -1)) printf("\nFils %d termine\n", p);
      /*Libérer la mémoire partagée */
      shmctl(memp, IPC_RMID, 0);
      /*Supprimer les sémaphores*/
      semctl(sem, 2, IPC_RMID, 0);
      return 0;
    }