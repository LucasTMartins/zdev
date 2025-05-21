*&---------------------------------------------------------------------*
*& Include MZLMO004O01
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TC 'TC_LIKP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MODIFY TABLE
MODULE tc_likp_modify INPUT.
  MODIFY gt_likp
    FROM gs_likp
    INDEX tc_likp-current_line.
ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'TC_LIKP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE tc_likp_mark INPUT.
  DATA: g_tc_likp_wa2 LIKE LINE OF gt_likp.
  IF tc_likp-line_sel_mode = 1
  AND gs_likp-mark = 'X'.
    LOOP AT gt_likp INTO g_tc_likp_wa2
      WHERE mark = 'X'.
      g_tc_likp_wa2-mark = ''.
      MODIFY gt_likp
        FROM g_tc_likp_wa2
        TRANSPORTING mark.
    ENDLOOP.
  ENDIF.
  MODIFY gt_likp
    FROM gs_likp
    INDEX tc_likp-current_line
    TRANSPORTING mark.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC_LIKP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE tc_likp_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'TC_LIKP'
                              'GT_LIKP'
                              'MARK'
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.
ENDMODULE.
