
%%

"2CSSIL"  {fprintf(yyout, "1CS");}
"2CSSIQ"  {fprintf(yyout, "1CS");}
.       { fprintf(yyout, "%s", yytext); }

%%
int yywrap(){
    return 1;
}
int main(){

    // message au début (pour utilisateur)
    printf("Processing...");

    /* yyin and yyout as pointer of File type */
    extern FILE *yyin, *yyout;
    /* yyin points to the file input.txt and opens it in read mode*/
    yyin = fopen("Input.txt", "r");
    /* yyout points to the file output.txt and opens it in write mode*/
    yyout = fopen("Output.txt", "w");
    
    //lancement de l'analyseur (il attendre le text à entrer)
    yylex();
    return 0;
}
