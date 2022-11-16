NOMBRE [0-9]+
MOT (([a-z])|([A-Z]))+
INDESIRABLE .

%%

{NOMBRE}  {printf(" [Nombre: %s , Taille: %d]\n",yytext,strlen(yytext));}
{MOT}  {printf(" [Mot: %s ]\n",yytext);}
{INDESIRABLE}  {printf(" [Caractere Indesirable: %s , Taille: %d]\n",yytext,strlen(yytext));}

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
