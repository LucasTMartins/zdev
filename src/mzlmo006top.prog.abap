*&---------------------------------------------------------------------*
*& Include MZLMO006TOP                              - PoolMóds.        SAPMZLMO006
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo006 MESSAGE-ID zlmo_msg_001.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES: ekko.

*&---------------------------------------------------------------------*
*& Selection-screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0101 AS SUBSCREEN.
  SELECT-OPTIONS: s_ebeln FOR ekko-ebeln. "Documento de compras
  SELECT-OPTIONS: s_aedat FOR ekko-aedat. "Dta. criação
SELECTION-SCREEN END OF SCREEN 0101.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         ebeln TYPE ekko-ebeln, "Doc compras
         bukrs TYPE ekko-bukrs, "Empresa
         bstyp TYPE ekko-bstyp, "Categoria do documento de compras
         aedat TYPE ekko-aedat, "Data
         ernam TYPE ekko-ernam, "Nome responsável
         lifnr TYPE ekko-lifnr, "Nº conta do fornecedor
       END OF gty_saida.

*&---------------------------------------------------------------------*
*& Constants declaration
*&---------------------------------------------------------------------*
CONSTANTS: gc_isave       TYPE c VALUE 'A',
           gc_delbut_func TYPE string VALUE 'ITENS',
           gc_delbut_icon TYPE string VALUE '@6T@',
           gc_delbut_type TYPE p      VALUE 4,
           gc_perc40      TYPE p      VALUE 40,
           gc_perc60      TYPE p      VALUE 60.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_saida    TYPE TABLE OF gty_saida,
      gt_fieldcat TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& Objects declaration (Global)
*&---------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_but   TYPE stb_button.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_layout   TYPE lvc_s_layo,
      gs_variant  TYPE disvariant,
      gs_fieldcat TYPE lvc_s_fcat.
