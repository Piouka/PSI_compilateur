%{
    #include <stdio.h>
    #include "symboltable.h"
    int yylex();
    void yyerror(char *str);
    int depth = 0;
%}
%token tMAIN tINT tEQ tPO tPF tAO tAF tPV tVR tPLUS tMOINS tMUL tDIV tCONST tPRINTF
%union{
    int nb;
    char* str;
}
%left tPLUS tMOINS
%left tMUL tDIV
%right tEQ
%token <nb> tNB tXX
%token <str> tID
%type <nb> Expr
%type <nb> Printf

%% 
%start File;

File:
    Main;
Main: 
    tMAIN tPO tPF tAO Body tAF;
Body: 
    Definition                  {printf("Definition");}
    | Definition Affectation    {printf("Definition et affectation");}
    | Definition Printf;
Printf:
    tPRINTF tPO tNB tPF         {$$=$3; printf("%d",$$);};
Affectation:
    tID tEQ Expr;
Expr:
    tNB                         {$$=$1;}
    | tID                       {printf("%s",$1);}
    | Expr tPLUS Expr           {$$=$1+$3; printf("%d",$$);}
    | Expr tMOINS Expr          {$$=$1-$3; printf("%d",$$);}
    | Expr tMUL Expr            {$$=$1*$3; printf("%d",$$);}
    | Expr tDIV Expr            {$$=$1/$3; printf("%d",$$);}
    | tPO Expr tPF              {$$=$2;};
Definition:
    tINT tID DefinitionN tPV    {add_table($2, 0, 0, depth); print_table();};
DefinitionN:
    /* vide */
    | tVR tID DefinitionN;
BeginDepth:
    tAO                         {depth ++;};
EndDepth:
    tAF                         {erase_depth(); depth --;};

%%
    /* Supprimer cette partie dans le fichier .l si presente ici*/
void yyerror(char *str) {
    fprintf(stderr,"%s\n",str);
};
int main() {
    yyparse(); 
    return 0;
}
