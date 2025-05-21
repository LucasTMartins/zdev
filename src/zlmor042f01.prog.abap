*&---------------------------------------------------------------------*
*& Include          ZLMOR042F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM f_buscar_dados
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  SELECT kunnr name1 name2 pstlz ort01 land1
    FROM kna1
    INTO TABLE gt_kna1
    WHERE kunnr IN s_kunnr.

  CHECK gt_kna1[] IS INITIAL.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_prepare_data
*&---------------------------------------------------------------------*
FORM f_prepare_data.
  DATA: ls_kna1   TYPE gty_kna1,
        ls_kna1_t TYPE gty_kna1,
        ls_order  TYPE LINE OF zlmo_order_t.

  SORT gt_kna1 BY kunnr.

  LOOP AT gt_kna1 INTO ls_kna1_t.
    CLEAR ls_kna1.
    ls_kna1 = ls_kna1_t.

    AT NEW kunnr.
      CLEAR ls_order.
      ls_order-order_no   = ls_kna1-kunnr.
      ls_order-order_type = ls_kna1-pstlz.
    ENDAT.

    ls_order-customer-customer_name    = ls_kna1-name1.
    ls_order-customer-customer_city    = ls_kna1-ort01.
    ls_order-customer-customer_country = ls_kna1-land1.

    AT END OF kunnr.
      APPEND ls_order TO gt_order_out.
    ENDAT.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_output
*&---------------------------------------------------------------------*
FORM f_output.
  DATA lv_xml TYPE xstring.

  CALL TRANSFORMATION ztransformation
    SOURCE order = gt_order_out
    RESULT XML lv_xml.

  IF sy-subrc = 0.
    MESSAGE i398(00) WITH text-001 space space space DISPLAY LIKE 'I'.
  ENDIF.
ENDFORM.
