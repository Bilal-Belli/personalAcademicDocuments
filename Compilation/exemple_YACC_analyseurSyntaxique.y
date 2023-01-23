%{
#include <stdio.h>
char str1[1000];
char  *reverse_with_alloc(const char *str)
{
    char        *result = NULL;
    size_t      len = strlen(str) - 1;
    size_t      i = 0;
    if (str == NULL)
        return (NULL);
    if ((result = malloc(sizeof(*result) * len + 1)) == NULL)
        return (NULL);
    for (; i < len; i++)
    {
        result[i] = str[len - i];
    }
    result[i] = '\0';
    return (result);
}
%}
%token  or and not po pf valog FIN
%right not
%left and
%left or
%%
Z : E FIN      { strcat(str1,reverse_with_alloc("-- E# "));strcpy(str1,reverse_with_alloc(str1)); printf("%s\n",str1); }
;
E : not E       {strcat(str1,reverse_with_alloc("-- not E "));}
    | E and E   {strcat(str1,reverse_with_alloc("-- E and E "));}
    | E or E    {strcat(str1,reverse_with_alloc("-- E or E "));}
    | po E pf   {strcat(str1,reverse_with_alloc("-- (E) "));}
    | valog     {strcat(str1,reverse_with_alloc("-- valog "));}
;
%%
yyerror(char *message){printf("%s \n",message);}
int main(){
    yyparse();
}

//  pour les evaluations des expressions logiques
// Z : E FIN      { if($1){printf("true\n");}else{printf("false\n");};}
//     | Z E FIN  { if($2){printf("true\n");}else{printf("false\n");};}
// ;
// E : not E       {$$= !($2);     printf("E -> not E      \n");}
//     | E and E   {$$= $1 & $3;   printf("E -> E and E    \n");}
//     | E or E    {$$= $1 | $3;   printf("E -> E or E     \n");}
//     | po E pf   {$$= $2;        printf("E -> (E)        \n");}
//     | valog     {$$= $1;        printf("E -> Valog      \n");}
// ;

// pour l'arbre syntaxique c'est le programme en haut

// pour compiler les codes: win_bison -d exemple_YACC_analyseurSyntaxique.y
// pour compiler les codes: win_bison -d exemple_LEX_analyseurLexical.l
// pour compiler les codes: gcc -o executable exemple_YACC_analyseurSyntaxique.tab.c lex.yy.c
// pour executer: executable

// on utilise le right et le left pour l'associativité a gauche ou a droit
// right: pour associativité a droit ie évaluer l'element le plus interne
// ex: not not not 0 =>   ( not  not (not(0)) ) =>  ( not ( not (not(0))) ) 