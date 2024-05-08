%{
#include "nag.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

ESPACO              [ \t\n]+
NAME                [a-zA-Z][a-zA-Z0-9_]*
HASH                "#" 
CRENCAS             "crencas:"
OBJETIVOS           "objetivos:" 
PLANOS              "planos:" 
ABRE_CHAVE          "{"
FECHA_CHAVE         "}"
PONTO_VIRGULA       ";"
ABRE_PARENTESE      "("
FECHA_PARENTESE     ")"
E                   "E"
OU                  "OU" 
NAO                 "NAO"

%%


{ESPACO}                        
{HASH}                          { return HASH; }
{CRENCAS}                       { return CRENCAS; }
{OBJETIVOS}                     { return OBJETIVOS; }
{PLANOS}                        { return PLANOS; }
{ABRE_CHAVE}                    { return ABRE_CHAVE; }
{FECHA_CHAVE}                   { return FECHA_CHAVE; }
{PONTO_VIRGULA}                 { return PONTO_VIRGULA; }
{ABRE_PARENTESE}                { return ABRE_PARENTESE; }
{FECHA_PARENTESE}               { return FECHA_PARENTESE; }
{E}                             { return E; }
{OU}                            { return OU; }
{NAO}                           { return NAO; }
{NAME} {
    yylval.str = strdup(yytext);
    if (yylval.str == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    return NAME;
}
.                               

%%

int yywrap() {
    return 1;
}
