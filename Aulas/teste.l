%option noyywrap
%{
  /*Exemplo*/
%}

letter [A - Z]
code [a-z]+
digit [0-9]

%%

{digit}   { printf("Digito %s\n", yytext); }
{letter}  { printf("Simbolo %s\n", yytext); }
{code}    { printf("Code %s\n", yytext); }
.         { printf("Caractere nao reconhecido"); }

%%

int main (int nArgs, char *szArgs[]){
  yylex();
  printf("Finalizou o programa!\n");
  return 0;
}