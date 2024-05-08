%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyin;
void yyerror(const char *s);

char* processar_nome(const char *nome) {
    if (nome == NULL) {
        fprintf(stderr, "Erro: nome nulo\n");
        exit(EXIT_FAILURE);
    }
    char *processado = strdup(nome);
    if (processado == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; processado[i]; i++) {
        processado[i] = tolower(processado[i]);
    }
    return processado;
}

char* processar_evento(const char *evento) {
    if (evento == NULL) {
        fprintf(stderr, "Erro: evento nulo\n");
        exit(EXIT_FAILURE);
    }
    char *processado = strdup(evento);
    if (processado == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    char prefixo[] = "Evento: ";
    char *resultado = (char*) malloc(strlen(prefixo) + strlen(processado) + 1);
    if (resultado == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    strcpy(resultado, prefixo);
    strcat(resultado, processado);
    free(processado);
    return resultado;
}

char* processar_expressao(const char *expressao) {
    if (expressao == NULL) {
        fprintf(stderr, "Erro: expressao nula\n");
        exit(EXIT_FAILURE);
    }
    char *processado = strdup(expressao);
    if (processado == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    char *resultado = (char*) malloc(strlen(processado) + 3);
    if (resultado == NULL) {
        fprintf(stderr, "Erro: falha ao alocar memória\n");
        exit(EXIT_FAILURE);
    }
    resultado[0] = '(';
    strcpy(resultado + 1, processado);
    resultado[strlen(resultado)] = ')';
    free(processado);
    return resultado;
}
%}

%union {
    char *str;
}

%token <str> NAME HASH CRENCAS OBJETIVOS PLANOS ABRE_CHAVE FECHA_CHAVE PONTO_VIRGULA ABRE_PARENTESE FECHA_PARENTESE E OU NAO

%type <str> Lagentes agente Lcrencas Lobjetivos Lplanos nomeObjetivo lista_crencas lista_objetivos lista_planos nomePlano tuplaPlano eventoGatilho contexto expressaoLogica corpo formulasCorpo

%%

programa: Lagentes { printf("MAS %s\n", $1); exit(EXIT_SUCCESS); }
         ;

Lagentes: agente '%' { printf("%s\n", $1); }
         | Lagentes agente '%' { printf("%s\n", $1); }
         ;

agente: HASH NAME CRENCAS Lcrencas OBJETIVOS Lobjetivos PLANOS Lplanos { 
    printf("agent %s\n", processar_nome($2));
    printf("  believes %s\n", $4);
    printf("  intends %s\n", $6);
    printf("  plans %s\n", $8);
}
       ;

Lcrencas: ABRE_CHAVE lista_crencas FECHA_CHAVE { printf("%s\n", $2); }
        ;

lista_crencas: NAME PONTO_VIRGULA lista_crencas { printf("    %s\n", processar_nome($1)); }
             | /* vazio */ { printf("    []\n"); }
             ;

Lobjetivos: ABRE_CHAVE lista_objetivos FECHA_CHAVE { printf("%s\n", $2); }
         ;

lista_objetivos: nomeObjetivo PONTO_VIRGULA lista_objetivos { printf("    %s\n", $1); }
             | /* vazio */ { printf("    []\n"); }
             ;

nomeObjetivo: NAME { printf("    %s\n", processar_nome($1)); }
          ;

Lplanos: ABRE_CHAVE lista_planos FECHA_CHAVE { printf("%s\n", $2); }
         ;

lista_planos: nomePlano PONTO_VIRGULA lista_planos { printf("    %s\n", $1); }
             | /* vazio */ { printf("    []\n"); }
             ;

nomePlano: NAME tuplaPlano { printf("    %s\n", $1); }
          ;

tuplaPlano: ABRE_PARENTESE eventoGatilho PONTO_VIRGULA contexto PONTO_VIRGULA corpo FECHA_PARENTESE
          { printf("      if %s then\n", processar_evento($2));
            printf("        %s\n", processar_expressao($4));
            printf("        %s\n", $6);
            printf("      end\n");
          }
          ;

eventoGatilho: NAME { printf("    %s\n", processar_evento($1)); }
             ;

contexto: expressaoLogica { printf("    %s\n", processar_expressao($1)); }
        | NAME { printf("    %s\n", processar_nome($1)); }
        | /* vazio */ { printf("    []\n"); }
        ;

expressaoLogica: NAME E NAME { printf("    %s and %s\n", processar_nome($1), processar_nome($3)); }
               | NAME OU NAME { printf("    %s or %s\n", processar_nome($1), processar_nome($3)); }
               | NAO NAME { printf("    not %s\n", processar_nome($2)); }
               ;

corpo: ABRE_CHAVE formulasCorpo FECHA_CHAVE { printf("%s\n", $2); }
     ;

formulasCorpo: NAME PONTO_VIRGULA formulasCorpo { printf("    %s\n", $1); }
                | /* vazio */ { printf("    []\n"); }
             ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
    exit(EXIT_FAILURE);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Uso: %s arquivo.nag\n", argv[0]);
        return EXIT_FAILURE;
    }
    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        perror("Erro ao abrir o arquivo");
        return EXIT_FAILURE;
    }
    printf("Iniciando análise sintática...\n");
    yyin = arquivo;
    yyparse();
    fclose(arquivo);
    return EXIT_SUCCESS;
}
