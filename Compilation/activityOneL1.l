EXPRESION_REGULIERE ((ab)*c)|(a)$

%%

{EXPRESION_REGULIERE}  ;

%%
int yywrap(){
    return 1;
}
int main(){
    // message au début (pour utilisateur)
    printf("L=(ab)*c|a \n");
    printf("Entrer votre mot : ");
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex();
    return 0;
}
