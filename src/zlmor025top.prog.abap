*&---------------------------------------------------------------------*
*& Include          ZLMOR024TOP
*&---------------------------------------------------------------------*
REPORT zlmor024 MESSAGE-ID 00.
*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : lips.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS :
  c_raiz           TYPE lvc_nkey VALUE space,
  c_fornecimento   TYPE string   VALUE 'Fornecimento / Material',
  c_fornmat        TYPE string   VALUE 'Fornecimento / Material',
  c_comtyp_h       TYPE c        VALUE 'H',
  c_cabecalho_tree TYPE string   VALUE 'Cabeçalho Tree',
  c_comtyp_s       TYPE c        VALUE 'S',
  c_autor          TYPE string   VALUE 'Autor: ',
  c_lucas_martins  TYPE string   VALUE 'Lucas Martins de Oliveira',
  c_data           TYPE string   VALUE 'Data: '
.
*
**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_lips,
         vbeln TYPE lips-vbeln, "Entrega
         posnr TYPE lips-posnr, "Item de remessa
         matnr TYPE lips-matnr, "Nº do material
         lfimg TYPE lips-lfimg, "Quantidade fornecida de fato, em UMV
       END   OF gty_lips,
       BEGIN OF gty_indice,
         tabix TYPE lvc_nkey,   "número da linha na tabela
         linha TYPE lvc_nkey,   "número da linha na árvore
       END   OF gty_indice.

"" CONTAINERS
DATA:
  go_alv_tree         TYPE REF TO cl_gui_alv_tree,         "Objeto árvore ALV
  go_custom_container TYPE REF TO cl_gui_custom_container. "Objeto container


**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
  gt_lips            TYPE STANDARD TABLE OF gty_lips,
  gt_relatorio       TYPE STANDARD TABLE OF gty_lips, "ver relatório
  gt_relatorio_itens TYPE STANDARD TABLE OF gty_lips,
  gt_saida           TYPE STANDARD TABLE OF gty_lips,
  gt_fieldcat        TYPE lvc_t_fcat,
  gt_relacao         TYPE TABLE OF gty_indice,
  gt_list_commentary TYPE TABLE OF slis_listheader
  .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gs_lips            TYPE gty_lips,
  gs_relatorio       TYPE gty_lips,
  gs_saida           TYPE gty_lips,
  gs_fieldcat        TYPE lvc_t_fcat WITH HEADER LINE,
  gs_relacao         TYPE gty_indice,
  gs_layout          TYPE lvc_s_layo,
  gs_list_commentary TYPE slis_listheader.
.

DATA: gtt_exclude TYPE ui_functions.
