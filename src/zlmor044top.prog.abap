*&---------------------------------------------------------------------*
*& Include          ZLMOR044TOP
*&---------------------------------------------------------------------*
REPORT zlmor044 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : zlmot011.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_back   TYPE string VALUE 'BACK',
            gc_exit   TYPE string VALUE 'EXIT',
            gc_cancel TYPE string VALUE 'CANCEL'.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         ordem_de_venda TYPE zlmot011-id,
         quantidade     TYPE zlmot011-quantidade,
         dt_venda       TYPE zlmot011-dt_venda,
         hr_venda       TYPE zlmot011-hr_venda,
         usuario        TYPE zlmot011-us_venda,
         valor_tot      TYPE zlmot011-valor_tot,
         status         TYPE zlmot010-ativo,
         material       TYPE zlmot010-id,
         grp_merc       TYPE zlmot010-grp_merc,
         um             TYPE zlmot010-um,
         imposto        TYPE zlmot010-imposto,
         valor          TYPE zlmot010-valor,
       END OF gty_saida.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_lmot011 TYPE STANDARD TABLE OF zlmot011,
      gt_lmot010 TYPE STANDARD TABLE OF zlmot010,
      gt_lmot009 TYPE STANDARD TABLE OF zlmot009,
      gt_saida   TYPE STANDARD TABLE OF gty_saida.

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_lmot009 TYPE zlmot009,
      gs_lmot010 TYPE zlmot010,
      gs_lmot011 TYPE zlmot011,
      gs_saida   TYPE gty_saida.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
*DATA: gv_xxxxxxx(nn) TYPE xx-yy.
**&---------------------------------------------------------------------*
**& Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_id FOR zlmot011-id.
  SELECT-OPTIONS: s_dtvend FOR zlmot011-dt_venda OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
*INITIALIZATION.
**----------------------------------------------------------------------*
* PERFORM f_initialization.
**----------------------------------------------------------------------*
*AT SELECTION-SCREEN OUTPUT.
**----------------------------------------------------------------------*
*PERFORM f_selection_screen_output.
**----------------------------------------------------------------------*
*AT SELECTION-SCREEN.
**----------------------------------------------------------------------*
* PERFORM f_selection_screen.
**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  CALL SCREEN 0100.

**----------------------------------------------------------------------*
*END-OF-SELECTION.
**----------------------------------------------------------------------*
* PERFORM f_display_result.
**&---------------------------------------------------------------------*
**& Form F_XXXXXXXXXX
**&---------------------------------------------------------------------*
** Description
**----------------------------------------------------------------------*
** -->PT_TABLE Table description
** -->PS_STRUCTURE Structure description
** -->PV_VARIABLE Variable description
**----------------------------------------------------------------------*
*FORM f_xxxxxxxx TABLES pt_table TYPE yyyy
* USING ps_structure TYPE xxxx
* pv_variable TYPE xxxxx-yyy.
*ENDFORM. " F_XXXXXXXXXX
