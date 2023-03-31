/*ce program est sans synchronisation car j'ai seulement partager une piece memoire entre deux processus, un qui dit serveur et ecrit dans la memoire et l'autre est
le client qui va lire ce que le serveur a ete ecrit*/
/*dans ce cas il ya pas un acces multiple car il sont metter sequencielement*/
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>
#define SHMSZ     27
main()
{ 
    int shmid;
    key_t key;key = 5678;
    char *shm, *s;char c;
    
    shmid = shmget(key, SHMSZ, IPC_CREAT | 0666);
    shm = shmat(shmid, NULL, 0);
    s = shm;
    for (c = 'a'; c <= 'z'; c++) *s++ = c;  
        
    int shmid2;
    char *s2;
    shmid2 = shmget(key, SHMSZ, 0666);
    shm = shmat(shmid2, NULL, 0);
    for (s2 = shm; *s2 != NULL; s2++)
        putchar(*s2);
    putchar('\n');
    *shm = '*';
    printf("la phrase : %s",shm); 
}