%{
  /* Exemplo 3 */

  int linhas = 0, caracteres = 0, tabs = 0;

%}

NOVALINHA [\n]+
TAB       [\t]+

%%

{NOVALINHA} { ++linhas; ++caracteres; }
{TAB}       { ++tabs; }
.           { ++caracteres; }

%%

int main (int nArgs, char *szArgs[]) {
  yylex();
  printf("Linhas: %d\n", linhas);
  printf("Caracteres: %d\n", caracteres);
  printf("Tabs: %d\n", tabs);
  return 0;
}