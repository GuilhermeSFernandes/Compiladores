# Compilador
CC = gcc

# Flags de compilação
CFLAGS = -Wall

# Nome dos arquivos
LEX_FILE = NagLex.l
YACC_FILE = nag.y
OUT_FILE = nag
TEST_FILE = teste.nag

# Regras
all: $(OUT_FILE) teste

$(OUT_FILE): lex.yy.c nag.tab.c
	$(CC) $(CFLAGS) -o $(OUT_FILE) lex.yy.c nag.tab.c -lfl

lex.yy.c: $(LEX_FILE)
	flex $(LEX_FILE)

nag.tab.c: $(YACC_FILE)
	bison -d $(YACC_FILE)

teste: $(OUT_FILE)
	./$(OUT_FILE) $(TEST_FILE) > output.asl

clean:
	rm -f lex.yy.c nag.tab.c nag.tab.h $(OUT_FILE) output.asl
