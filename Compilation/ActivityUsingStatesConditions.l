%start normal const_alpha

%%

<normal>[a-zA-Z]+       {fprintf(yyout,"identificateur : % s \n",yytext);}
<normal>\"              {BEGIN const_alpha;}
<const_alpha>[0-9a-zA-Z]+  {fprintf(yyout,"chaine : %s \n",yytext);}
<const_alpha>\"         {BEGIN normal;}
<normal,const_alpha>.   {;}
<normal,const_alpha>\n  {;}

%%

int yywrap(){
    return 1;
}

main(){

    errno_t Err1=fopen_s(&yyin,"C:\\Users\\Hp\\OneDrive\\Bureau\\ACT4-TP1\\Input.txt","r");
    errno_t Err2=fopen_s(&yyout,"C:\\Users\\Hp\\OneDrive\\Bureau\\ACT4-TP1\\Output.txt","w");

    if (Err1 == 0){
        BEGIN normal;
        yylex();
        }
    else
        printf("The file was not opened\n");

    fclose(yyin);
    fclose(yyout);
}
