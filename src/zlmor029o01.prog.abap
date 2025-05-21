*&---------------------------------------------------------------------*
*& Include          ZLMOR029O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  PERFORM f_get_data.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module INITIALIZATION OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE initialization OUTPUT.
  IF go_docking IS NOT BOUND.
    "Criação de do Objeto docking que vai a tela chamada como referencia.
    CREATE OBJECT go_docking
      EXPORTING
        repid                       = sy-repid "Nome do Programa
        dynnr                       = sy-dynnr "Número da Tela
        extension                   = 9999 "Controle de Extensão
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    "Criação de do Objeto splitter para divisão de tela
    CREATE OBJECT go_splitter
      EXPORTING
        parent            = go_docking "Container Parente
        rows              = 1 "Número de linhas para a visualização
        columns           = 2 "Número de colunas para a visualização
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.

    go_splitter->set_row_height( EXPORTING id = '1' "Linha
                                   height = '10' ). "Altura
    go_splitter->set_column_width( EXPORTING id = '1' "Coluna
                                      width = '50' ). "Largura

    "Aqui será feito a criação do Objeto Handler que identificará os duplos-cliques do user.
    IF go_handler IS NOT BOUND.
      CREATE OBJECT go_handler.
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
* Container MARA ( 1,1 )
*&---------------------------------------------------------------------*
  "Cria o container do cabeçalho (Ordem de Produto)
  "Aqui é feito a criação do container com referencia a uma das partições.
  go_splitter->get_container( EXPORTING row = '1' "Linha
                                     column = '1' "Coluna
                              RECEIVING
                                     container = go_container_mara ).

  "Cria a definição do catálogo de campos do cabeçalho
  PERFORM f_define_container_header.
*&---------------------------------------------------------------------*
* Container MAKT( 1,2 )
*&---------------------------------------------------------------------*
* "Cria o container de da MAKT
   go_splitter->get_container( EXPORTING row = '1' "Linha
                                      column = '2' "Coluna
                               RECEIVING
                                      container = go_container_makt ).

* "Cria a definição do catálogo de campos do item
  PERFORM f_define_container_item.
ENDMODULE.
