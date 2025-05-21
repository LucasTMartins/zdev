*&---------------------------------------------------------------------*
*& Include ZLMOR0037TOP                             - Report ZLMOR037
*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 17.10.2023                                           *
*& Description  : Prova básica - Busca de itens                        *
*&---------------------------------------------------------------------*
REPORT zlmor037 MESSAGE-ID 00.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : ekpo.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         ebeln TYPE ekpo-ebeln, "Doc compras
         ebelp TYPE ekpo-ebelp, "Item
         matnr TYPE ekpo-matnr, "Material
         werks TYPE ekpo-werks, "Centro
         lgort TYPE ekpo-lgort, "Depósito
         menge TYPE ekpo-menge, "Quantidade
         meins TYPE ekpo-meins, "UMB
         netwr TYPE ekpo-netwr, "Valor
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
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_repid TYPE sy-repid.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Relatório de itens
  SELECT-OPTIONS: s_ebeln FOR ekpo-ebeln.
SELECTION-SCREEN END OF BLOCK b1.
