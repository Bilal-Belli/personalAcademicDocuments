%{
#include <stdio.h>;
%}

%token chiffre or and not po pf vrai FIN

%%
Z : Expr FIN | Z Expr FIN
;
Expr : Expr or Terme | Terme
;
Terme : Terme and Facteur | Facteur
;
Facteur : not Operand | Operand
;
Operand : po Expr pf | Valog
;
Valog : vrai
;

%%
yyerror(char *message){printf("%s",message);}
int main(){
    yyparse();
}