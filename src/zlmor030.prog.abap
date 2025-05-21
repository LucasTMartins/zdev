*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 02.10.2023                                           *
*& Description  : Criando primeiro batch input                         *
*&---------------------------------------------------------------------*
REPORT zlmor030 NO STANDARD PAGE HEADING MESSAGE-ID 00.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  DATA:
    ls_bdcdata TYPE bdcdata,
    lt_bdcdata TYPE TABLE OF bdcdata,
    ls_opt     TYPE ctu_params
    .

  CLEAR: ls_bdcdata.
  FREE lt_bdcdata.

  ls_bdcdata-program = 'SAPLSD_ENTRY'.
  ls_bdcdata-dynpro = '1000'.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR: ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_CURSOR'.
  ls_bdcdata-fval = 'RSRD1-TBMA_VAL'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR: ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_OKCODE'.
  ls_bdcdata-fval = 'WB_DISPLAY'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR: ls_bdcdata.
  ls_bdcdata-fnam = 'RSRD1-TBMA'.
  ls_bdcdata-fval = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR: ls_bdcdata.
  ls_bdcdata-fnam = 'RSRD1-TBMA_VAL'.
  ls_bdcdata-fval = 'SFLIGHT'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-program = 'SAPLSD41'.
  ls_bdcdata-dynpro = '2200'.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_CURSOR'.
  ls_bdcdata-fval = 'DD02D-DBTABNAME'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_OKCODE'.
  ls_bdcdata-fval = 'TDSH'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_SUBSCR'.
  ls_bdcdata-fval = 'SAPLSD41                                2201TS_SCREEN'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-program = '/1BCDWB/DBSFLIGHT'.
  ls_bdcdata-dynpro = '1000'.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_CURSOR'.
  ls_bdcdata-fval = 'I1-LOW'.
  APPEND ls_bdcdata TO lt_bdcdata.

  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = 'BDC_OKCODE'.
  ls_bdcdata-fval = 'ONLI'.
  APPEND ls_bdcdata TO lt_bdcdata.

  ls_opt-dismode = 'E'. "Para não aparecer popup do botão display
  CALL TRANSACTION 'SE11' USING lt_bdcdata OPTIONS FROM ls_opt.





**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
*   TABLES : xxxxxx.
*
**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
*   CONSTANTS : c_xxxxxx(nn) TYPE x VALUE ‘value’.
*
**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
*  TYPES: BEGIN OF ty_yyyy,
*          END OF ty_yyyy.
*
**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
*  DATA: gt_xxx TYPE STANDARD TABLE OF xx,
*        gt_yyy TYPE STANDARD TABLE OF ty_yyyy.
*
**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
*  DATA: gs_xxxxxxx TYPE xx,
*        gs_xxxxxxx LIKE LINE OF gt_xxxxxx.
*
**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
*  DATA: gv_xxxxxxx(nn) TYPE xx-yy.
*
**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
*  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE s1.
*   SELECT-OPTIONS: s_xxxx FOR xxxx-yyyy.
*   PARAMETERS p_xxxx  TYPE xxxx-yyyy.
*   PARAMETERS cb_xxxx TYPE xxxx-yyy AS CHECKBOX.
*   PARAMETERS rb_xxxx TYPE xxxx-yyy RADIOBUTTON GROUP grp1.
*  SELECTION-SCREEN END OF BLOCK b1.
*
**----------------------------------------------------------------------*
*  INITIALIZATION.
**----------------------------------------------------------------------*
*    PERFORM f_initialization.
*
**----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
**----------------------------------------------------------------------*
*   PERFORM f_selection_screen_output.
*
**----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
**----------------------------------------------------------------------*
*    PERFORM f_selection_screen.
*
**----------------------------------------------------------------------*
*  START-OF-SELECTION.
**----------------------------------------------------------------------*
*    PERFORM f_data_selection.
*
**----------------------------------------------------------------------*
*  END-OF-SELECTION.
**----------------------------------------------------------------------*
*    PERFORM f_display_result.
*
**&---------------------------------------------------------------------*
**&      Form  F_XXXXXXXXXX
**&---------------------------------------------------------------------*
**       Description
**----------------------------------------------------------------------*
**       -->PT_TABLE      Table description
**       -->PS_STRUCTURE  Structure description
**       -->PV_VARIABLE   Variable description
**----------------------------------------------------------------------*
*  FORM f_xxxxxxxx TABLES pt_table     TYPE yyyy
*                   USING ps_structure TYPE  xxxx
*                         pv_variable  TYPE  xxxxx-yyy.
