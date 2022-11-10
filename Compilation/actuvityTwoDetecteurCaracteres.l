NOMBRE [0-9]+
MOT (([a-z])|([A-Z]))+
INDESIRABLE .

%%

{NOMBRE}  {printf(" [Nombre: %s ]\n",yytext);}
{MOT}  {printf(" [Mot: %s ]\n",yytext);}
{INDESIRABLE}  {printf(" [Caractere Indesirable: %s ]\n",yytext);}

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
