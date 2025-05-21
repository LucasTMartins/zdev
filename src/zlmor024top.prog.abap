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
CONSTANTS: gc_raiz                TYPE lvc_nkey VALUE space,
           gc_fornmat             TYPE string   VALUE 'Fornecimento / Material',
           gc_item                TYPE string   VALUE 'Item',
           gc_quantidade          TYPE string   VALUE 'Quantidade',
           gc_window_title        TYPE string   VALUE 'Selecione a pasta para salvar a planilha',
           gc_initial_folder_path TYPE string   VALUE 'C:\',
           gc_nome_arquivo        TYPE string   VALUE 'PlanilhaSAP',
           gc_colini              TYPE i        VALUE 1,
           gc_colend              TYPE i        VALUE 3,
           gc_display_e           TYPE c        VALUE 'E',
           gc_display_s           TYPE c        VALUE 'S',
           gc_barra               TYPE c        VALUE '/',
           BEGIN OF gc_ucomm,
             back     TYPE string VALUE 'BACK',
             exit     TYPE string VALUE 'EXIT',
             cancel   TYPE string VALUE 'CANCEL',
             impr_ole TYPE string VALUE '&IMPR_OLE',
           END OF gc_ucomm,
           BEGIN OF gc_theme_col,
             white      TYPE i VALUE 1,
             black      TYPE i VALUE 2,
             grey       TYPE i VALUE 3,
             dark_blue  TYPE i VALUE 4,
             light_blue TYPE i VALUE 5,
             red        TYPE i VALUE 6,
             violet     TYPE i VALUE 7,
             yellow     TYPE i VALUE 8,
             pal_blue   TYPE i VALUE 9,
             green      TYPE i VALUE 10,
           END OF gc_theme_col,
           BEGIN OF gc_col,
             black       TYPE i VALUE 0,
             white       TYPE i VALUE 2,
             red         TYPE i VALUE 3,
             light_green TYPE i VALUE 4,
             dark_blue   TYPE i VALUE 5,
             yellow      TYPE i VALUE 6,
             pink        TYPE i VALUE 7,
             light_blue  TYPE i VALUE 8,
             brown       TYPE i VALUE 9,
           END OF gc_col.
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
       BEGIN OF gty_tree,
         fornmat(18)    TYPE c,          "Fornecimento
         item(6)        TYPE c, "Item
         quantidade(13) TYPE c, "Quantidade
       END OF gty_tree,
       BEGIN OF gty_line_ole, "linha da planilha
         value TYPE char255,
       END OF gty_line_ole,
       gty_data_ole(1500) TYPE c.

**&---------------------------------------------------------------------*
**& Objetos
**&---------------------------------------------------------------------*
DATA: go_alv_tree         TYPE REF TO cl_gui_alv_tree,         "Objeto árvore ALV
      go_custom_container TYPE REF TO cl_gui_custom_container. "Objeto container

""Objetos para impressão de planilha
DATA: go_application TYPE  ole2_object,
      go_workbook    TYPE  ole2_object,
      go_workbooks   TYPE  ole2_object,
      go_worksheet   TYPE  ole2_object.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_tree            TYPE TABLE OF gty_tree,
      gt_lips            TYPE STANDARD TABLE OF gty_lips,
      gt_relatorio       TYPE STANDARD TABLE OF gty_lips, "ver relatório
      gt_relatorio_itens TYPE STANDARD TABLE OF gty_lips,
      gt_fieldcat        TYPE lvc_t_fcat,
      gt_data_ole        TYPE TABLE OF gty_data_ole, "tabela de dados da planilha
      gt_lines_ole       TYPE TABLE OF gty_line_ole. "tabela de linhas da planilha

DATA: gtt_exclude TYPE ui_functions. "tabela de botões excluidos

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_tree      TYPE gty_tree,
      gs_lips      TYPE gty_lips,
      gs_relatorio TYPE gty_lips,
      gs_saida     TYPE gty_lips,
      gs_fieldcat  TYPE lvc_t_fcat WITH HEADER LINE,
      gs_layout    TYPE lvc_s_layo,
      gs_data_ole  TYPE gty_data_ole, "dados da planilha
      gs_lines_ole TYPE gty_line_ole. "linha da planilha

**&---------------------------------------------------------------------*
**& SELECTION-SCREEN
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS:
    s_vbeln FOR lips-vbeln.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM: f_select_data.
  PERFORM: f_prepare_data.
  PERFORM: f_print.
