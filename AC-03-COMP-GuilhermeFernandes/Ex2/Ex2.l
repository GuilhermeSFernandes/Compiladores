%{

/* Exemplo 2 */

int numPalavras = 0;

%}

DIGITO [0-9]
PALAVRA [a-zA-Z]+
ESPACO " "
%%

{DIGITO}  {printf("Digito: \"%s\"\n", yytext);}
{PALAVRA} {printf("Palavra: \"%s\"\n", yytext); numPalavras++;}
{ESPACO}  {printf("Espaco\n");}
.         {printf("Nao reconhecido: \"%s\"\n", yytext);}

%%

int main (int nArgs, char* szArgs[])
{
    yylex();
    printf("Numero de palavras: %d\n", numPalavras);
    return 0;
}