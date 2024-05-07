Iniciando análise sintática...
[]
{ "crenca": "tenhoProtetorSolar" }
{ "crenca": "estaEnsolarado" }
{ "mensagem": "Analisando lista de crenças..." }
"passarProtetorSolar""naoPegarSol"[]
{ "objetivo": "naoPegarSol" }
{ "objetivo": "passarProtetorSolar" }
{ "mensagem": "Analisando lista de objetivos..." }
"passarProtetorSolar"{ "expressao": "estaEnsolarado E tenhoProtetorSolar" }
"estaEnsolarado"[]
{ "formula": "passarProtetorSolar" }
{ "formula": "pegarProtetorSolar" }
{ "corpo": pegarProtetorSolar }
{ "eventoGatilho": "passarProtetorSolar", "contexto": "estaEnsolarado", "corpo": "tenhoProtetorSolar" }
{ "nome": "plano1", "tupla": plano1 }
"naoPegarSol"{ "expressao": "NAO estaEnsolarado" }
"naoPegarSol"[]
{ "formula": "assistirFilme" }
{ "formula": "ficarEmCasa" }
{ "corpo": ficarEmCasa }
{ "eventoGatilho": "naoPegarSol", "contexto": "naoPegarSol", "corpo": "estaEnsolarado" }
{ "nome": "plano2", "tupla": plano2 }
"naoPegarSol"{ "expressao": "estaEnsolarado E tenhoProtetorSolar" }
"estaEnsolarado"[]
{ "formula": "lerLivro" }
{ "formula": "ficarEmCasa" }
{ "corpo": ficarEmCasa }
{ "eventoGatilho": "naoPegarSol", "contexto": "estaEnsolarado", "corpo": "tenhoProtetorSolar" }
{ "nome": "plano3", "tupla": plano3 }
[]
{ "plano": plano3 }
{ "plano": plano2 }
{ "plano": plano1 }
{ "mensagem": "Analisando lista de planos..." }
{ "agente": "carol", "crencas": carol, "objetivos": tenhoProtetorSolar, "planos": naoPegarSol }
%