#include <sys/types.h>
#include <sys/ipc.h>
int main() {
key_t cle;
cle = ftok ("/home/.",'A');
if(cle==-1) {
    printf("\n erreur : la clé ne pas été créée");
    exit(1);
    }
}
