*&---------------------------------------------------------------------*
*& Include MZLMO004O01
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_LIKP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE tc_likp_change_tc_attr OUTPUT.
  DESCRIBE TABLE gt_likp LINES tc_likp-lines.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_LIKP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE tc_likp_get_lines OUTPUT.
  g_tc_likp_lines = sy-loopc.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CONSTANTS: lc_back   TYPE string VALUE 'BACK',
             lc_exit   TYPE string VALUE 'EXIT',
             lc_cancel TYPE string VALUE 'CANCEL'.

  IF sy-ucomm EQ lc_back OR
     sy-ucomm EQ lc_exit OR
     sy-ucomm EQ lc_cancel.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module M_ATUALIZA_LINHAS INPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE m_atualiza_linhas INPUT.
  READ TABLE gt_likp INTO gs_likp INDEX tc_likp-current_line.

  IF sy-subrc = 0.
    MODIFY gt_likp
      FROM gs_likp
      INDEX tc_likp-current_line.
  ELSE.
    APPEND gs_likp TO gt_likp.
  ENDIF.
ENDMODULE.
