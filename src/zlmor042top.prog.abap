*&---------------------------------------------------------------------*
*& Include          ZLMOR042TOP
*&---------------------------------------------------------------------*
REPORT zlmor042.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : kna1.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
*CONSTANTS : c_xxxxxx(nn) TYPE x VALUE ‘value’.
**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
         name2 TYPE kna1-name2,
         pstlz TYPE kna1-pstlz,
         ort01 TYPE kna1-ort01,
         land1 TYPE kna1-land1,
       END OF gty_kna1.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_kna1      TYPE TABLE OF gty_kna1,
      gt_order_out TYPE zlmo_order_t.

**&---------------------------------------------------------------------*
**& Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_kunnr FOR kna1-kunnr.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM f_buscar_dados.
  PERFORM f_prepare_data.
  PERFORM f_output.
