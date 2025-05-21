*&---------------------------------------------------------------------*
*& Include          ZLMOR029CLASS
*&---------------------------------------------------------------------*
"" Implementando classe
CLASS lcl_event_handler IMPLEMENTATION.
  "Método duplo click no cabeçalho
  METHOD handle_double_click_header.
    DATA: ls_mara TYPE mara.

    "Identifica a linha que sofreu a ação.
    READ TABLE gt_mara INTO ls_mara INDEX es_row_no-row_id.

    "Faz uma seleção na tabela de Itens conforme dados que sofreram ação no alv header.
    FREE gt_makt.
    SELECT *
      FROM makt
      INTO TABLE gt_makt
      WHERE matnr = ls_mara-matnr.

    "Atualiza o alv Item.
    go_alv_makt->refresh_table_display( EXCEPTIONS finished = 1 OTHERS = 2 ).
  ENDMETHOD.

  "Método duplo click no item
  METHOD handle_double_click_item.
    DATA: ls_makt TYPE makt.

    "Identifica a linha do Item que sofreu a ação do user.
    READ TABLE gt_makt INTO ls_makt INDEX es_row_no-row_id.

    IF sy-subrc IS INITIAL.
      "Caso o User tenha clicado duas vezes no campo referente ao material 'MATNR'
      IF e_column = 'MATNR'.

        "Seleção com os dados do cliente
        FREE gt_mara.

        SELECT *
          FROM mara
          INTO TABLE gt_mara
          WHERE matnr = ls_makt-matnr.
      ENDIF.
    ENDIF.

    "Atualização da tabela de detalhes ( 2,1 )
    go_alv_mara->refresh_table_display( EXCEPTIONS finished = 1 OTHERS = 2 ).
  ENDMETHOD.
ENDCLASS.
