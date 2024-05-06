%{
#include "nag.tab.h"
%}

%%

#.*                            /* Ignorar comentários */

"#"                            { return HASH; }
"crencas:"                     { return CRENCAS; }
"objetivos:"                   { return OBJETIVOS; }
"planos:"                      { return PLANOS; }
"{"                            { return ABRE_CHAVE; }
"}"                            { return FECHA_CHAVE; }
";"                            { return PONTO_VIRGULA; }
"("                            { return ABRE_PARENTESE; }
")"                            { return FECHA_PARENTESE; }
"E"                            { return E; }
"OU"                           { return OU; }
"NAO"                          { return NAO; }
[ \t\n]                        ; /* Ignorar espaços em branco */
[a-zA-Z][a-zA-Z0-9_]*          { yylval.str = strdup(yytext); return NAME; }
.                              { return yytext[0]; } /* Retornar outros caracteres como tokens */

%%

int yywrap() {
    return 1;
}
