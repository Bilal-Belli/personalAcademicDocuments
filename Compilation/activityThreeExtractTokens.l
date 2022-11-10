EXPRESSION_REGULIERE \%((a|b|c|\%)+)\%

%%

{EXPRESSION_REGULIERE}  {printf(" [TOKEN: %s ]\n",yytext);}

%%
int yywrap(){
    return 1;
}
int main(){
    // message au début (pour utilisateur)
    printf("L= porcentage(a|b|c|porcentage)+porcentage\n");
    printf("Entrer votre chaine : ");
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex();
    return 0;
}
