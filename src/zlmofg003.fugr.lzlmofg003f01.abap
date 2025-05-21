*----------------------------------------------------------------------*
***INCLUDE LZLMOFG003F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_NOVAENTRADA
*&---------------------------------------------------------------------*
*& Adiciona id_item a cada nova entrada
*&---------------------------------------------------------------------*
FORM f_novaentrada.
  DATA: ls_tab TYPE zv_lmot006 VALUE IS INITIAL.

* Preenche campos desabilitados da tabela de parâmetros
  SELECT SINGLE * FROM zlmot006 INTO ls_tab
    WHERE descricao EQ zv_lmot006-descricao
      AND peso      EQ zv_lmot006-peso.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZITEMID_00'
    IMPORTING
      number                  = zv_lmot006-id_item
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
