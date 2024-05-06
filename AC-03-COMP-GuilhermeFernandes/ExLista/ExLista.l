%{
/* Execicio da Lista 1 */

%}

DIGIT [0-9]
LETTER [a-zA-Z]
ID {LETTER}({LETTER}|{DIGIT})*
INT {DIGIT}+
FLOAT {DIGIT}+"."{DIGIT}+
SCIENTIFIC {DIGIT}+(\.{DIGIT}+)?[eE][\+\-]?{DIGIT}+

%%

{ID}         { printf("IDENTIFIER: %s\n", yytext); }
{INT}        { printf("INTEGER: %s\n", yytext); }
{FLOAT}      { printf("FLOAT: %s\n", yytext); }
{SCIENTIFIC} { printf("SCIENTIFIC NOTATION: %s\n", yytext); }
.            { printf("SYMBOL: %s\n", yytext); }

%%

int main(int nArgs, char *szArgs[]) {
    yylex();
    return 0;
}
