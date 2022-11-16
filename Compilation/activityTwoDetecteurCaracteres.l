NOMBRE [0-9]+
MOT (([a-z])|([A-Z]))+
INDESIRABLE [^0-9a-zA-Z]

%%

{NOMBRE}  {printf(" [Nombre , Taille: %d]\n",yyleng);}
{MOT}  {printf(" [Mot , Taille: %d]\n",yyleng);}
{INDESIRABLE}+  {printf(" [Caractere Indesirable , Taille: %d]\n",yyleng);}

%%
int yywrap(){
    return 1;
}
int main(){
    // message au début (pour utilisateur)
    printf("Entrer votre chaine : ");
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex();
    return 0;
}

// 12b50 !, !suite5698 de symbole ......
