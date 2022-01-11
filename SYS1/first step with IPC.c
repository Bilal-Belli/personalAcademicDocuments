#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/msg.h>
#include <stddef.h>
int main() {
key_t cle;
cle = ftok ("/home/.",'A');
if(cle==-1) {
    printf("\n erreur : la clé ne pas été créée");
    exit(1);
    }
}
