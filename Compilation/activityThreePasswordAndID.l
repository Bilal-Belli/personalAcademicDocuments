MOT_PASSE ([a-z]|[A-Z]|[0-9]){8}
IDENTIFICATEUR ([a-z]|[A-Z]|[0-9])+

%%

{MOT_PASSE}  {printf(" [Mot de passe: %s ]\n",yytext);}
{IDENTIFICATEUR}  {printf(" [Identificateur: %s ]\n",yytext);}

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
