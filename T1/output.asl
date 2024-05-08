Iniciando análise sintática...
    []
    tenhoprotetorsolar
    estaensolarado
estaEnsolarado
    passarprotetorsolar
    naopegarsol
    []
    naoPegarSol
    passarProtetorSolar
passarProtetorSolar
    Evento: passarProtetorSolar
    estaensolarado and tenhoprotetorsolar
    (estaEnsolarado)
    []
    passarProtetorSolar
    pegarProtetorSolar
pegarProtetorSolar
      if Evento: passarProtetorSolar then
        (estaEnsolarado)
        tenhoProtetorSolar
      end
    plano1
    Evento: naoPegarSol
    not estaensolarado
    (naoPegarSol)
    []
    assistirFilme
    ficarEmCasa
ficarEmCasa
      if Evento: naoPegarSol then
        (naoPegarSol)
        estaEnsolarado
      end
    plano2
    Evento: naoPegarSol
    estaensolarado and tenhoprotetorsolar
    (estaEnsolarado)
    []
    lerLivro
    ficarEmCasa
ficarEmCasa
      if Evento: naoPegarSol then
        (estaEnsolarado)
        tenhoProtetorSolar
      end
    plano3
    []
    plano3
    plano2
    plano1
plano1
agent carol
  believes carol
  intends tenhoProtetorSolar
  plans naoPegarSol
