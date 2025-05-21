*&---------------------------------------------------------------------*
*& Report ZLMOR050
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlmor050.

*DATA: lv_input  TYPE string VALUE 'Texto a virar RAW',
*      lv_output TYPE xstring.
DATA: lt_input  TYPE soli_tab,
      ls_input  TYPE soli,
      lv_output TYPE string.

ls_input-line = '30003000300030003000300030003000'.

APPEND ls_input TO lt_input.

*TRY.
*    CALL METHOD cl_bcs_convert=>string_to_xstring
*      EXPORTING
*        iv_string  = lv_input
**       iv_convert_cp = 'X'
**       iv_codepage   =
**       iv_add_bom =
*      RECEIVING
*        ev_xstring = lv_output.
*  CATCH cx_bcs.
*ENDTRY.

TRY.
    CALL METHOD cl_bcs_convert=>raw_to_string
      EXPORTING
        it_soli   = lt_input
      RECEIVING
        ev_string = lv_output.
  CATCH cx_bcs.
ENDTRY.


WRITE lv_output.
