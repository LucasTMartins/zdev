*----------------------------------------------------------------------*
***INCLUDE LZLMOFG002F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_CAMPDESAB
*&---------------------------------------------------------------------*
*& Preenche campos desabilitados da tabela zlmot004
*&---------------------------------------------------------------------*
FORM f_campdesab.
  DATA: ls_tab TYPE zv_t004 VALUE IS INITIAL.
* Preenche campos desabilitados da tabela de parâmetros
  SELECT SINGLE * FROM zlmot004
    INTO ls_tab
    WHERE lgnum EQ zv_t004-lgnum
      AND progr EQ zv_t004-progr
      AND campo EQ zv_t004-campo.

  IF sy-subrc <> 0.
    zv_t004-erdat = sy-datum.
    zv_t004-erzet = sy-uzeit.
    zv_t004-ernam = sy-uname.
  ELSE.
    zv_t004-laeda = sy-datum.
    zv_t004-aezet = sy-uzeit.
    zv_t004-aenam = sy-uname.
  ENDIF.
ENDFORM. "F_CAMPDESAB
*&-------------------------------------------------------------------*
