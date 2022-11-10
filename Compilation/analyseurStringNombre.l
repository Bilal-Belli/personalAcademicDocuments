
%%

[a-zA-Z]+   {printf("Chaine Caractere");}
[0-9]+      {printf("Nombre");}

%%
int yywrap(){
    return 1;
}
int main(){
    // message au début (pour utilisateur)
    printf("Entrer votre text : ");
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex(); 
    printf("\n");
    return 0;
}
