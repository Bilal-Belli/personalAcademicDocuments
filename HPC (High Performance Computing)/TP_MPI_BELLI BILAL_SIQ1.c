#include <stdio.h>
# include <stdlib.h>
#include "mpi.h"

#define MAITRE 0
#define Taille_table 100
#define chunksize 10 // taille des morceau (nombre de valeurs)
#define TAG1 1 // pour les messages de demande
#define TAG2 2 // pour transmettre des donnes
#define TAG3 3 // pour les messages de fin et arreter la demande

int main () {
    int rank, size, buf1, buf2;
    int i;
    int cpt=0;
    int cache;
    MPI_Status status;

    int n = (Taille_table / chunksize);
    int *Morceau = NULL;
	Morceau = (int*) malloc (chunksize*sizeof(int));

    MPI_Init (NULL, NULL);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);
    MPI_Comm_size (MPI_COMM_WORLD, &size);

    int *TableReceptions = NULL;
	TableReceptions = (int*) malloc (Taille_table*sizeof(int)); //cette est utilisé et remplie seulement par le processus maitre

    do {
        if (rank == MAITRE) {
	     	// initialisation de la table dans processus maitre
	     	int *Table = NULL;
            Table = (int*) malloc (Taille_table*sizeof(int));
            for (i=0; i<Taille_table; i++)
                Table[i] = i+1;
		    // reception de la demande des donnes
            MPI_Recv (&buf1, 1, MPI_INT, MPI_ANY_SOURCE, TAG1, MPI_COMM_WORLD, &status);
			// envoie des donnes
			for (i=0; i<chunksize; i++)
                Morceau[i] = Table[i+cpt*chunksize];
			MPI_Send (Morceau, chunksize, MPI_INT, status.MPI_SOURCE, TAG2, MPI_COMM_WORLD);
			// recoit des donnes apres traitement
			MPI_Recv (Morceau, chunksize, MPI_INT, MPI_ANY_SOURCE, TAG2, MPI_COMM_WORLD, &status);
			for (i=0; i<chunksize; i++){
				cache=Morceau[i];
                TableReceptions[i+cpt*chunksize] = cache;
			}
			cpt ++;
			// fin (traitement complet)
			if(cpt==n) {
				// affichage de la table resultat
				for (i=0; i<Taille_table; i++)
					printf("%d\t",TableReceptions[i]);
					printf("\n");
				// envoyer signal d'arreter a demander (message de fin)
				for (int i = 0; i < size; i++){
					if (i != MAITRE)
                    {
                        MPI_Recv (&buf1, 1, MPI_INT, MPI_ANY_SOURCE, TAG1, MPI_COMM_WORLD, &status);
                        MPI_Send (&buf2, 1, MPI_INT, status.MPI_SOURCE, TAG3, MPI_COMM_WORLD);
                    }
                }
				// arreter le processus maitre
				break;}
		} else {
			// envoie de demande de données
            MPI_Send (&buf1, 1, MPI_INT, MAITRE, TAG1, MPI_COMM_WORLD);
	        // reception des donnes
			MPI_Recv (Morceau, chunksize, MPI_INT, MAITRE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
			if (status.MPI_TAG == TAG3){
				break;
			}
	        // traitement sur les donnes
            for (i=0; i<chunksize; i++){
                    cache=Morceau[i];
                    cache=cache*cache;
                    Morceau[i]=cache;
                    // printf("%d \n",Morceau[i]);
                }
	        // retransmettre des donnes au processus maitre
            MPI_Send (Morceau, chunksize, MPI_INT, MAITRE, TAG2, MPI_COMM_WORLD);
			// fin (traitement complet)
		}
    } while (1==1);
    MPI_Finalize ();
    return 0;
}