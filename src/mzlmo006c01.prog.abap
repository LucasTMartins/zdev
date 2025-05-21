*&---------------------------------------------------------------------*
*& Include          MZLMO006C01
*&---------------------------------------------------------------------*

CLASS lcl_event_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar                              "Criando botão de relatório de itens
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      handle_user_command                         "Criando evento para puxar o relatório de itens
        FOR EVENT user_command OF cl_gui_alv_grid.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    gv_but-function  = gc_delbut_func. "ITENS
    gv_but-icon      = gc_delbut_icon. "@6T@
    gv_but-butn_type = gc_delbut_type. "4
    gv_but-text      = text-010. "Relatório Itens
    APPEND gv_but TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    IF gv_but-function = gc_delbut_func. "ITENS
      SUBMIT zlmor037           "Mandando dado de entrega para o programa zlmor026
        WITH s_ebeln IN s_ebeln
        AND RETURN.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA event_receiver TYPE REF TO lcl_event_receiver.
