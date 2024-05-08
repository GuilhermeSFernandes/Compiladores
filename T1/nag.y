%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyin;
void yyerror(const char *s);
FILE *asl_file;

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

programa: Lagentes { fclose(asl_file); exit(EXIT_SUCCESS); }
         ;

Lagentes: agente '%' { fprintf(asl_file, "!end.\n"); }
         | Lagentes agente '%' { fprintf(asl_file, "!end.\n"); }
         ;

agente: HASH NAME CRENCAS Lcrencas OBJETIVOS Lobjetivos PLANOS Lplanos { 
    fprintf(asl_file, "!agent. %s\n", processar_nome($2));
    fprintf(asl_file, "!beliefs. %s\n", $4);
    fprintf(asl_file, "!goals. %s\n", $6);
    fprintf(asl_file, "!plans. %s\n", $8);
}
       ;

Lcrencas: ABRE_CHAVE lista_crencas FECHA_CHAVE { }
        ;

lista_crencas: NAME PONTO_VIRGULA lista_crencas { fprintf(asl_file, "+!belief. %s.\n", processar_nome($1)); }
             | /* vazio */ { fprintf(asl_file, "+!belief. .\n"); }
             ;

Lobjetivos: ABRE_CHAVE lista_objetivos FECHA_CHAVE { }
         ;

lista_objetivos: nomeObjetivo PONTO_VIRGULA lista_objetivos { fprintf(asl_file, "+!goal. %s.\n", $1); }
             | /* vazio */ { fprintf(asl_file, "+!goal. .\n"); }
             ;

nomeObjetivo: NAME { fprintf(asl_file, "+!goal. %s.\n", processar_nome($1)); }
          ;

Lplanos: ABRE_CHAVE lista_planos FECHA_CHAVE { }
         ;

lista_planos: nomePlano PONTO_VIRGULA lista_planos { fprintf(asl_file,"+!plan. %s.\n", $1); }
             | /* vazio */ { fprintf(asl_file, "+!plan. .\n"); }
             ;

nomePlano: NAME tuplaPlano { }
          ;

tuplaPlano: ABRE_PARENTESE eventoGatilho PONTO_VIRGULA contexto PONTO_VIRGULA corpo FECHA_PARENTESE
          { fprintf(asl_file, "+!rule. %s then\n", processar_evento($2));
            fprintf(asl_file, "  %s\n", processar_expressao($4));
            fprintf(asl_file, "  %s\n", $6);
            fprintf(asl_file, "end\n");
          }
          ;

eventoGatilho: NAME { fprintf(asl_file, "%s", processar_evento($1)); }
             ;

contexto: expressaoLogica { fprintf(asl_file, "  %s\n", processar_expressao($1)); }
        | NAME { fprintf(asl_file, "  %s\n", processar_nome($1)); }
        | /* vazio */ { fprintf(asl_file, "  \n"); }
        ;

expressaoLogica: NAME E NAME { fprintf(asl_file, "  %s and %s\n", processar_nome($1), processar_nome($3)); }
               | NAME OU NAME { fprintf(asl_file, "  %s or %s\n", processar_nome($1), processar_nome($3)); }
               | NAO NAME { fprintf(asl_file, "  not %s\n", processar_nome($2)); }
               ;

corpo: ABRE_CHAVE formulasCorpo FECHA_CHAVE { }
     ;

formulasCorpo: NAME PONTO_VIRGULA formulasCorpo { fprintf(asl_file, "  %s\n", $1); }
                | /* vazio */ { fprintf(asl_file, "  \n"); }
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
    asl_file = fopen("output.asl", "w");
    if (!asl_file) {
        perror("Erro ao abrir o arquivo");
        return EXIT_FAILURE;
    }
    yyin = arquivo;
    yyparse();
    fclose(arquivo);
    fclose(asl_file);
    return EXIT_SUCCESS;
}