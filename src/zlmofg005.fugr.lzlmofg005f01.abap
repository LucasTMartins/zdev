*----------------------------------------------------------------------*
***INCLUDE LZLMOFG005F01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
***FORM f_nova_entrada.
*----------------------------------------------------------------------*
FORM f_nova_entrada.
  CONSTANTS: lc_objeto    TYPE inri-object    VALUE 'ZLMO_NR_01',
             lc_num_range TYPE inri-nrrangenr VALUE '01',
             lc_display_e TYPE c              VALUE 'E'.
  DATA: lv_num_id      TYPE i,
        lv_return_code TYPE inri-returncode.

  CALL FUNCTION 'NUMBER_GET_NEXT' "Recebendo próximo index do id cliente
    EXPORTING
      nr_range_nr             = lc_num_range
      object                  = lc_objeto
    IMPORTING
      number                  = lv_num_id
      returncode              = lv_return_code
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  IF lv_return_code = 1. "caso o número de ID gerado esteja proximo do máximo
    MESSAGE i398(00) WITH TEXT-004 space space space DISPLAY LIKE lc_display_e. "Número de ID se aproximando do máximo
  ENDIF.

  zlmo_t_produto-id = lv_num_id.
ENDFORM.
