*&---------------------------------------------------------------------*
*& Include          ZPRIMEIRO_OOCLALMO
*&---------------------------------------------------------------------*

CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
      catch_hotspot
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id
                  es_row_no,
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object
                  e_interactive,
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING es_row_no,
      on_f4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING e_fieldname
                  es_row_no e_fieldvalue
                  er_event_data
        .
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD catch_hotspot.
  ENDMETHOD.

  METHOD handle_toolbar.
    gv_delbut-function  = gc_deletar.     "DELETAR
    gv_delbut-icon      = gc_delbut_icon. "@18@
    gv_delbut-butn_type = gc_toolbarbut_type. "4
    gv_delbut-text      = gc_deletarlin.  "Deletar linha
    APPEND gv_delbut TO e_object->mt_toolbar.

    gv_insbut-function  = gc_inserir.     "INSERIR
    gv_insbut-icon      = gc_insbut_icon. "@17@
    gv_insbut-butn_type = gc_toolbarbut_type. "4
    gv_insbut-text      = gc_inserirlin.  "Inserir linha
    APPEND gv_insbut TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN gc_inserir.
        PERFORM f_inserir_linha.
      WHEN gc_deletar.
        DATA: lt_index_rows TYPE lvc_t_row, "Index of Row Selected
              ls_index      LIKE LINE OF lt_index_rows,
              lv_count      TYPE i.
        "Pega linha selecionada
        CALL METHOD go_grid1->get_selected_rows
          IMPORTING
            et_index_rows = lt_index_rows.

        "Retorna o numero de registros que uma tabela interna tem.
        DESCRIBE TABLE lt_index_rows LINES lv_count.
        IF lt_index_rows IS INITIAL.
          MESSAGE s398 WITH TEXT-005 DISPLAY LIKE 'E'. "Selecione uma linha para excluir
          EXIT.
        ENDIF.

        "Contador para o caso de 2 ou mais linhas selecionadas.
        IF lv_count > 1.
          MESSAGE s398 WITH TEXT-004 DISPLAY LIKE 'E'. "Selecione apenas uma linha
          EXIT.
        ENDIF.

        PERFORM f_deletar_linha.
    ENDCASE.
  ENDMETHOD.

  METHOD on_double_click.
    MESSAGE i398 WITH TEXT-007. "Teste duplo clique
  ENDMETHOD.

  METHOD on_f4.
    TYPES: BEGIN OF lty_aux,
             ebeln TYPE ekko-ebeln,
           END OF lty_aux.

    DATA: lt_aux        TYPE TABLE OF lty_aux,
          lt_return_tab TYPE TABLE OF ddshretval,
          ls_return_tab TYPE ddshretval,
          ls_stable     TYPE lvc_s_stbl.

    FIELD-SYMBOLS: <ls_alv> TYPE gty_saida.

    READ TABLE gt_saida ASSIGNING <ls_alv> INDEX es_row_no-row_id.
    "Busca valores para EBELN
    FREE lt_aux.
    SELECT ebeln
      FROM ekko
      INTO TABLE lt_aux.
    SORT lt_aux BY ebeln.
    "Mostra tela de pesquisa
    REFRESH lt_return_tab[].
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'EBELN'
        value_org       = 'S'
      TABLES
        value_tab       = lt_aux
        return_tab      = lt_return_tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    "Joga o valor selecionado para work area
    CLEAR ls_return_tab.
    READ TABLE lt_return_tab INTO ls_return_tab INDEX 1.
    "Passa o novo valor para a tabela interna GT_OUTPUT
    <ls_alv>-ebeln = ls_return_tab-fieldval.
    " Atualiza grid do alv
    ls_stable = gc_stable_val.
    CALL METHOD go_grid1->refresh_table_display
      EXPORTING
        is_stable      = ls_stable
        i_soft_refresh = abap_true
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
  ENDMETHOD.
ENDCLASS.

DATA event_receiver TYPE REF TO lcl_event_receiver.
