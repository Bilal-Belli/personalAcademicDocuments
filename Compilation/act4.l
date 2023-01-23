%{
#include <stdio.h>;
#include "exemple.tab.h";
%}

%%
\(       {return po;}
\)       {return pf;}
"AND"    {return and;}
"OR"     {return or;}
"NOT"    {return not;}
"vrai"|"true"|"t"|"T"|"VRAI"|"TRUE"|"faux"|"false"|"f"|"F"|"FAUX"|"FALSE"|"0"|"1"    {return vrai;}
[\t ]    ;
"\n"     {return FIN;}
.        {printf("Erreur lexical");}
%%
int yywrap(){}
