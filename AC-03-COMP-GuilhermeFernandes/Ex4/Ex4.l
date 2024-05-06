%{
  /* Exemplo 4 */

  int linhas = 0;
%}

TAG         \<(.)*\>
WHITESPACE  [\ \t]
LINHA       [\n]

%%

{TAG}           ;
{LINHA}         { linhas++; }
{WHITESPACE}    {printf("%s", yytext);}
.               {printf("%s", yytext);}

%%

int main (int nArgs, char* szArgs[])
{
  yylex();
  printf("\nNumero de linhas: %d\n", linhas);
  return 0;
}