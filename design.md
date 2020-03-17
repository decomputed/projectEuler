Então, project euler é o seguinte:
  * uma command line utility que chamado com um problem number, devolve a resposta e, dependendo dos parâmetros, apresenta mais informação acerca de como chegar lá, ou informação detalhada acerca do problema
    * isto é o executável
  * o executável tem de chamar uma library que tem de ter instâncias dos problemas.
  * uma instância tem de ter
    * um problem ID
    * uma execução, (qual é a função que eu chamo para executar o problema)
    * uma descrição do problema
  * Isto é a library
  * executar testes tem como significado
    * verificar que a CLI funciona
    * verificar as soluçoes para os problemas
