*&---------------------------------------------------------------------*
*& Include          ZLMOR039C01
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      catch_hotspot
        FOR EVENT hotspot_click OF cl_gui_alv_grid,
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD catch_hotspot.
  ENDMETHOD.

  METHOD handle_toolbar.
    gv_but-function  = gc_popbut_func. "POPUP
    gv_but-butn_type = gc_popbut_type. "4
    gv_but-text      = text-021. "Chamar popup
    APPEND gv_but TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    IF gv_but-function = gc_popbut_func. "POPUP
      DATA: lt_index_rows   TYPE lvc_t_row,     "index das linhas selecionadas
            ls_selected_row TYPE lvc_s_row,     "index de apenas uma linha
            lv_count        TYPE i,             "quantidade de linhas selecionadas
            lt_fields       TYPE TABLE OF sval, "valores dos campos selecionados
            ls_fields       TYPE sval,          "valores de uma única linha selecionada
            lv_lgnumval(3)  TYPE c,
            lv_tanumval(10) TYPE n,
            lv_taposval(4)  TYPE n.

      "Pega linha selecionada
      CALL METHOD go_grid->get_selected_rows
        IMPORTING
          et_index_rows = lt_index_rows.

      "Retorna o numero de registros que uma tabela interna tem.
      DESCRIBE TABLE lt_index_rows LINES lv_count.
      IF lt_index_rows IS INITIAL.
        MESSAGE i398 WITH TEXT-019 space space space DISPLAY LIKE 'E'. "Favor selecionar uma linha
        EXIT.
      ENDIF.

      "Contador para o caso de 2 ou mais linhas selecionadas.
      IF lv_count > 1.
        MESSAGE i398 WITH TEXT-020 space space space DISPLAY LIKE 'E'. "Favor selecionar apenas uma linha
        EXIT.
      ENDIF.

      "lendo dados da linha selecionada para popup
      READ TABLE lt_index_rows INTO ls_selected_row INDEX 1.
      CLEAR gs_saida.
      READ TABLE gt_saida INTO gs_saida INDEX ls_selected_row-index.
      lv_lgnumval = gs_saida-lgnum.
      lv_tanumval = gs_saida-tanum.
      lv_taposval = gs_saida-tapos.

      "passando dados da tabela para o popup
      CLEAR ls_fields.
      ls_fields-tabname = 'LTAK'.
      ls_fields-fieldname = 'LGNUM'.
      ls_fields-field_attr = '02'. " Atributo para visualização do campo (somente leitura)
      ls_fields-value = lv_lgnumval. " Valor por defecto
*      ls_fields-field_obl = abap_true. " Obrigatorio indicar um valor
      ls_fields-fieldtext = text-006. " Texto descritivo esquerdo
      APPEND ls_fields TO lt_fields.

      CLEAR ls_fields.
      ls_fields-tabname = 'LTAK'.
      ls_fields-fieldname = 'TANUM'.
      ls_fields-field_attr = '02'.
      ls_fields-value = lv_tanumval.
      ls_fields-fieldtext = text-007.
      APPEND ls_fields TO lt_fields.

      CLEAR ls_fields.
      ls_fields-tabname = 'LTAP'.
      ls_fields-fieldname = 'TAPOS'.
      ls_fields-field_attr = '02'.
      ls_fields-value = lv_taposval.
      ls_fields-fieldtext = text-010.
      APPEND ls_fields TO lt_fields.

      "chamando popup
      CALL FUNCTION 'POPUP_GET_VALUES'
        EXPORTING
          popup_title     = text-004 "Dados selecionados
        TABLES
          fields          = lt_fields "tabela com os campos
        EXCEPTIONS
          error_in_fields = 1
          OTHERS          = 2.

      "Verifica erros
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA event_receiver TYPE REF TO lcl_event_receiver.
