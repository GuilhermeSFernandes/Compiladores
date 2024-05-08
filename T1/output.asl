+!belief. .
+!belief. tenhoprotetorsolar.
+!belief. estaensolarado.
+!goal. passarprotetorsolar.
+!goal. naopegarsol.
+!goal. .
+!goal. naoPegarSol.
+!goal. passarProtetorSolar.
Evento: passarProtetorSolar  estaensolarado and tenhoprotetorsolar
  (estaEnsolarado)
  
  passarProtetorSolar
  pegarProtetorSolar
+!rule. Evento: passarProtetorSolar then
  (estaEnsolarado)
  tenhoProtetorSolar
end
Evento: naoPegarSol  not estaensolarado
  (naoPegarSol)
  
  assistirFilme
  ficarEmCasa
+!rule. Evento: naoPegarSol then
  (naoPegarSol)
  estaEnsolarado
end
Evento: naoPegarSol  estaensolarado and tenhoprotetorsolar
  (estaEnsolarado)
  
  lerLivro
  ficarEmCasa
+!rule. Evento: naoPegarSol then
  (estaEnsolarado)
  tenhoProtetorSolar
end
+!plan. .
+!plan. plano3.
+!plan. plano2.
+!plan. plano1.
!agent. carol
!beliefs. carol
!goals. tenhoProtetorSolar
!plans. naoPegarSol
