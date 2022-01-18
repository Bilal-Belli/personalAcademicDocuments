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
#define nplace N
#define splein 0
#define svide 1

/*structures speciales*/
typedef struct copie
{ int num_exo;
  int pid;  
};

/*variables globales*/
int bex;
int cpt =0 ;
int cpin =0;
copie bcp[];

/*definition des operations sur les semaphores*/
struct sembuf Pcpplein = {
  splein,
  -1,
  0
};
struct sembuf Vcpplein = {
  svide,
  1,
  0
};
struct sembuf Pexplein = {
  splein,
  -1,
  0
};
struct sembuf Vexplein = {
  svide,
  1,
  0
};
struct sembuf Pcpvide = {
  splein,
  -1,
  0
};
struct sembuf Vcpvide = {
  svide,
  1,
  0
};
struct sembuf Pexvide = {
  splein,
  -1,
  0
};
struct sembuf Vexvide = {
  svide,
  1,
  0
};
struct sembuf Pmutex = {
  splein,
  -1,
  0
};
struct sembuf Vmutex = {
  svide,
  1,
  0
};
struct sembuf Pfinexo = {
  splein,
  -1,
  0
};
struct sembuf Vfinexo = {
  svide,
  1,
  0
};



int memp_bcp,memp_bex,memp_var;
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

      union semun {
        int val;
        struct semid_ds *buf;
        unsigned short *array;
      }
      svideinit, spleininit;

      /* Création d'un segment de mémoire pour: bcp  */
      memp_bcp = shmget(IPC_PRIVATE, N * sizeof(int), IPC_CREAT | 0666);
      if (memp_bcp == -1) {
        printf("\nErreur de création de la mémoire partagée\n");
        exit(1);
      } 
      /* Attachement du segment */
      Bus = shmat(memp_bcp, 0, 0);
      /*---------------------------------------------------------------------*/
      /* Création d'un segment de mémoire pour: bex */
      memp_bex = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0666);
      if (memp_bex == -1) {
        printf("\nErreur de création de la mémoire partagée\n");
        exit(1);
      } 
      /* Attachement du segment */
      Bus = shmat(memp_bex, 0, 0);
      /*---------------------------------------------------------------------*/
      /* Création d'un segment de mémoire pour: cpt et cpin */
      memp_var = shmget(IPC_PRIVATE, (2) * sizeof(int), IPC_CREAT | 0666);
      if (memp_var == -1) {
        printf("\nErreur de création de la mémoire partagée\n");
        exit(1);
      } 
      /* Attachement du segment */
      Bus = shmat(memp_var, 0, 0);
      /*---------------------------------------------------------------------*/
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
      /*Création du processus qui execute enseignant */
      p = fork();
      if (p == -1) {
        printf("\nErreur de creation de processus\n");
        exit(3);
      }else{
      if(p == 0){
        Enseignant(); /*metter son procedure d'appele*/
        exit(4);
      }
    } 
      /* Création du processus qui execute etudiants */ 
      for (i= 0; i < 4; ++i) /* dans ce cas il execute 4 etudiants*/
        {p = fork();
      if (p == -1) {
        printf("\nErreur de creation de processus\n");
        exit(3);
      }else{
        if (p == 0) {
        Etudiant();  /*metter son procedure d'appele*/
        exit(4);
      }
      }
      }
      /*Attendre la terminaison des fils */
      while ((p = wait(NULL) != -1)) printf("\nFils %d termine\n", p);
      /*Libérer la mémoire partagée */
      shmctl(memp, IPC_RMID, 0);
      /*Supprimer les sémaphores*/
      semctl(sem, 2, IPC_RMID, 0);
      return 0;
    }
