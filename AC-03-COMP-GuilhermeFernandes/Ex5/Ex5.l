%{
  
/* Exemplo 5 */

int linhas = 0, qtdTags = 0;
  
%}

TAG         \<(.)*\>
WHITESPACE  [\ \t]
LINHA       [\n]
lett1       [a-z]+
lett2       [A-Z]+
word        [A-Z][a-z]+

%%

{lett1}       {printf("min: %s\n", yytext);}
{lett2}       {printf("mai: %s\n", yytext);}
{word}        {printf("word: %s\n", yytext);}
{TAG}         {qtdTags++; printf("TAG: %s\n", yytext);}
{LINHA}       {linhas++;}
{WHITESPACE}  ;
.             ;

%%

int main(int nArgs, char *szArgs[])
{
    yylex();
    printf("Linhas: %d\n", linhas);
    printf("Tags: %d\n", qtdTags);
    return 0;
}