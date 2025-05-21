*&---------------------------------------------------------------------*
*& Include          ZLMOR041TOP
*&---------------------------------------------------------------------*
REPORT zlmor041 MESSAGE-ID 00.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : spfli.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         carrid   TYPE spfli-carrid,
         airpfrom TYPE spfli-airpfrom,
         airpto   TYPE spfli-airpto,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
         deptime  TYPE spfli-deptime,
         arrtime  TYPE spfli-arrtime,
       END OF gty_saida.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_saida    TYPE STANDARD TABLE OF gty_saida,
      gt_fieldcat TYPE slis_t_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_saida    TYPE gty_saida,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_carrid FOR spfli-carrid.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_buscar_dados.   "buscando dados
  PERFORM f_fieldcat_init.  "construindo fieldcat
  PERFORM f_imprimir_dados. "imprimindo dados
