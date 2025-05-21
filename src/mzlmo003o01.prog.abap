*----------------------------------------------------------------------*
***INCLUDE MZLMO003_SELECT_LIKPO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module SELECT_LIKP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE select_likp OUTPUT.
  SELECT vbeln ernam erzet erdat
    FROM likp
    INTO CORRESPONDING FIELDS OF TABLE gt_likp.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  DATA: ls_value TYPE vrm_value,
        lt_list  TYPE vrm_values.

  CONSTANTS: lc_sair     TYPE string VALUE 'F_SAIR',
             lc_combo    TYPE string VALUE 'F_COMBO',
             lc_listname TYPE vrm_id VALUE 'P_LISTBOX'.

  ls_value-key = '1'.
  ls_value-text = 'Text 1'.
  APPEND ls_value TO lt_list.

  CLEAR ls_value.
  ls_value-key = '2'.
  ls_value-text = 'Text 2'.
  APPEND ls_value TO lt_list.

  CLEAR ls_value.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lc_listname
      values          = lt_list
    EXCEPTIONS
      id_illegal_name = 0
      OTHERS          = 0.

  REFRESH lt_list.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PREENCHE_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE preenche_screen OUTPUT.
  IF sy-stepl = 1.
    tablecontrol-lines =
      tablecontrol-top_line + sy-loopc - 1.
  ENDIF.

  APPEND gs_likp TO gt_likp.
ENDMODULE.
