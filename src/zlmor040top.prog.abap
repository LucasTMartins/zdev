*&---------------------------------------------------------------------*
*& Include          ZLMOR040TOP
*&---------------------------------------------------------------------*
REPORT zlmor040 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : zlmot007.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_cod_pro      TYPE char12 VALUE 'COD_PRO',
            gc_nome         TYPE char12 VALUE 'NOME',
            gc_cod_grp      TYPE char12 VALUE 'COD_GRP',
            gc_dt_cadastro  TYPE char12 VALUE 'DT_CADASTRO',
            gc_preco_venda  TYPE char12 VALUE 'PRECO_VENDA',
            gc_estoque_disp TYPE char12 VALUE 'ESTOQUE_DISP',
            gc_celltab      TYPE char12 VALUE 'CELLTAB',
            gc_cellcolor    TYPE char12 VALUE 'CELLCOLOR',
            gc_modbut_func  TYPE string VALUE 'MODIF',
            gc_modbut_type  TYPE p      VALUE 4,
            gc_modbut_icon  TYPE string VALUE '@3I@',
            gc_savbut_func  TYPE string VALUE 'SALV',
            gc_savbut_type  TYPE p      VALUE 4,
            gc_savbut_icon  TYPE string VALUE '@2L@',
            gc_isave        TYPE c      VALUE 'A'.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         cod_pro      TYPE zlmot007-cod_pro,
         nome         TYPE zlmot007-nome,
         cod_grp      TYPE zlmot007-cod_grp,
         dt_cadastro  TYPE zlmot007-dt_cadastro,
         preco_venda  TYPE zlmot007-preco_venda,
         estoque_disp TYPE zlmot007-estoque_disp,
         celltab      TYPE lvc_t_styl,
         cellcolor    TYPE lvc_t_scol,
       END OF gty_saida.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_lmot007   TYPE TABLE OF zlmot007,
      gt_saida    TYPE TABLE OF gty_saida WITH HEADER LINE,
      gt_saidabkp TYPE TABLE OF gty_saida WITH HEADER LINE,
      gt_fieldcat TYPE lvc_t_fcat,
      gt_stylerow TYPE TABLE OF lvc_s_styl.

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_lmot007   TYPE zlmot007,
      gs_saida     TYPE gty_saida,
      gs_saidabkp  TYPE gty_saida,
      gs_fieldcat  TYPE lvc_s_fcat,
      gs_variant   TYPE disvariant,
      gs_layout    TYPE lvc_s_layo,
      gs_stylerow  TYPE lvc_s_styl,
      gs_cellcolor TYPE lvc_s_scol,
      gs_transport TYPE zlmot007.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA: gv_modbut TYPE stb_button,
      gv_savbut TYPE stb_button,
      gv_index  TYPE sy-tabix.

**&---------------------------------------------------------------------*
**& Objects declaration (Global)
**&---------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_grid      TYPE REF TO cl_gui_alv_grid.

**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Cadastro de produtos
  SELECT-OPTIONS: s_codpro FOR zlmot007-cod_pro,
                  s_dtcad  FOR zlmot007-dt_cadastro.
SELECTION-SCREEN END OF BLOCK b1.
