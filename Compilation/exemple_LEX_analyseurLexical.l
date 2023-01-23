%{
#include <stdio.h>
#include "exemple.tab.h"
%}
%%
"vrai"|"true"|"t"|"T"|"VRAI"|"TRUE"|"1"    {yylval = 1; return valog;}
"faux"|"false"|"f"|"F"|"FAUX"|"FALSE"|"0"  {yylval = 0; return valog;}
\(       {return po;}
\)       {return pf;}
"and"    {return and;}
"or"     {return or;}
"not"    {return not;}
[\t ]    ;
"\n"     {return FIN;}
.        {printf("Erreur lexical");}
%%
int yywrap(){}

// pour compiler les codes: win_bison -d exemple_YACC_analyseurSyntaxique.y
// pour compiler les codes: win_bison -d exemple_LEX_analyseurLexical.l
// pour compiler les codes: gcc -o executable exemple_YACC_analyseurSyntaxique.tab.c lex.yy.c
// pour executer: executable