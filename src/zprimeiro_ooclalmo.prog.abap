*&---------------------------------------------------------------------*
*& Include          ZPRIMEIRO_OOCLALMO
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS: catch_hotspot
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
        IMPORTING e_ucomm.
  PRIVATE SECTION.
ENDCLASS.
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD catch_hotspot.
  ENDMETHOD.
  METHOD handle_toolbar.
    gv_but-function = 'DELETE'.
    gv_but-icon = '@11@'.
    gv_but-butn_type = 4.
    gv_but-text = 'Eliminar'.
    APPEND gv_but TO e_object->mt_toolbar.
  ENDMETHOD.
  METHOD handle_user_command.
    IF gv_but-function = 'DELETE'.
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

        MESSAGE s000 WITH TEXT-005 DISPLAY LIKE 'E'. "Selecione uma linha para excluir

        EXIT.

      ENDIF.
      "Contador para o caso de 2 ou mais linhas selecionadas.
      IF lv_count > 1.

        MESSAGE s000 WITH TEXT-004 DISPLAY LIKE 'E'. "Selecione apenas uma linha

        EXIT.
      ENDIF.
      READ TABLE lt_index_rows INTO ls_index INDEX 1.
      DELETE gt_saida INDEX ls_index-index.
      MESSAGE s000 WITH TEXT-003 DISPLAY LIKE 'E'. "Deletado
      "Atualiza grid
      CALL METHOD go_grid1->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
DATA event_receiver TYPE REF TO lcl_event_receiver.
