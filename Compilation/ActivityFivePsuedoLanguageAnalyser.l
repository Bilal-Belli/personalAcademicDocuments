
%%
"main"|"if"|"else"|"while"|"do"|"switch"|"of"|"break"  {fprintf(yyout,"(mot-cle, %s)",yytext);}

"<>"|"<="|">="|"+"|"-"  {fprintf(yyout, "(operateur, %s)",yytext);}
"<"  {fprintf(yyout, "(operateur, <)");}
"="  {fprintf(yyout, "(operateur, =)");}
">"  {fprintf(yyout, "(operateur, >)");}

([a-z])(0|([a-zA-Z0-9])+)  {fprintf(yyout, "(Identificateur, %s)",yytext);}

([0-9]0)|([0-9][0-9]+)  {fprintf(yyout, "(Constantes, %s)",yytext);}

.       {fprintf(yyout, "%s", yytext);}

%%
int yywrap(){
    return 1;
}
int main(){

    // message au début (pour utilisateur)
    printf("Processing...\n");

    /* yyin and yyout as pointer of File type */
    extern FILE *yyin, *yyout;
    /* yyin points to the file input.txt and opens it in read mode*/
    yyin = fopen("Input.txt", "r");
    /* yyout points to the file output.txt and opens it in write mode*/
    yyout = fopen("Output.txt", "w");
    
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex();

    printf("End Of Process Successfully");
    return 0;
}
