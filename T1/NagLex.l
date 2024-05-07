%{
#include "nag.tab.h"
%}
WHITESPACE [ \t\n]
NAME    [a-zA-Z][a-zA-Z0-9_]*
CRENCAS "crencas:"
OBJETIVOS "objetivos:"
PLANOS "planos:"
HASH    "#"
ABRE_CHAVE "{"
FECHA_CHAVE "}"
PONTO_VIRGULA ";"
ABRE_PARENTESE "("
FECHA_PARENTESE ")"
E "E"
OU "OU"
NAO "NAO"
%%

{HASH}                        { return HASH; }
{CRENCAS}                     { return CRENCAS; }
{OBJETIVOS}                   { return OBJETIVOS; }
{PLANOS}                      { return PLANOS; }
{ABRE_CHAVE}                  { return ABRE_CHAVE; }
{FECHA_CHAVE}                 { return FECHA_CHAVE; }
{PONTO_VIRGULA}               { return PONTO_VIRGULA; }
{ABRE_PARENTESE}              { return ABRE_PARENTESE; }
{FECHA_PARENTESE}             { return FECHA_PARENTESE; }
{E}                           { return E; }
{OU}                          { return OU; }
{NAO}                         { return NAO; }
{NAME}                        { yylval.str = strdup(yytext); return NAME; }
.                             { return yytext[0]; } /* Retornar outros caracteres como tokens */
{WHITESPACE}                  ; /* Ignorar espaços em branco */

%%

int yywrap() {
    return 1;
}