*&---------------------------------------------------------------------*
*& Include MZLMOTOP                                 - PoolMóds.        SAPMZLMO7
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo7.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_back           TYPE string         VALUE 'BACK',
            gc_exit           TYPE string         VALUE 'EXIT',
            gc_cancel         TYPE string         VALUE 'CANCEL',
            gc_avan           TYPE string         VALUE 'AVAN',
            gc_rein           TYPE string         VALUE 'REIN',
            gc_impri          TYPE string         VALUE 'IMPRI',
            gc_vltr           TYPE string         VALUE 'VLTR',
            gc_ant            TYPE string         VALUE 'ANT',
            gc_prox           TYPE string         VALUE 'PROX',
            gc_etiq_id        TYPE thead-tdid     VALUE 'ST',
            gc_etiq_name      TYPE thead-tdname   VALUE 'ZLMO_ETIQUETA_ZEBRA',
            gc_etiq_object    TYPE thead-tdobject VALUE 'TEXT',
            gc_msgid          TYPE t100-arbgb     VALUE '00',
            gc_msgno          TYPE t100-msgnr     VALUE '398',
            gc_antbut(132)    TYPE c              VALUE 'GV_ANTBUT',
            gc_proxbut(132)   TYPE c              VALUE 'GV_PROXBUT',
            gc_vfdat(132)     TYPE c              VALUE 'GV_VFDAT',
            gc_vfdattext(132) TYPE c              VALUE 'GV_VFDATTEXT',
            gc_zero           TYPE c              VALUE '0',
            gc_one            TYPE c              VALUE '1'.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_label_ud,
         matnr TYPE lqua-matnr,
         maktx TYPE makt-maktx,
         lenum TYPE lqua-lenum,
         lgtyp TYPE lqua-lgtyp,
         charg TYPE lqua-charg,
         werks TYPE lqua-werks,
         lgort TYPE lqua-lgort,
         lgnum TYPE lqua-lgnum,
         bdatu TYPE lqua-bdatu,
         lgpla TYPE lqua-lgpla,
       END OF gty_label_ud.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_lqua     TYPE TABLE OF lqua,
      gt_label_ud TYPE TABLE OF gty_label_ud.

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_user     TYPE lrf_wkqu,
      gs_lqua     TYPE lqua,
      gs_makt     TYPE makt,
      gs_params   TYPE pri_params,
      gs_label_ud TYPE gty_label_ud.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA: gv_pos(20)    TYPE c,
      gv_lgtyp      TYPE lqua-lgtyp,
      gv_lgpla      TYPE lqua-lgpla,
      gv_lenum      TYPE lqua-lenum,
      gv_charg      TYPE lqua-charg,
      gv_vfdat      TYPE lqua-vfdat,
      gv_matnr      TYPE lqua-matnr,
      gv_letyp      TYPE lqua-letyp,
      gv_maktx      TYPE makt-maktx,
      gv_maktx2     TYPE makt-maktx,
      gv_verme      TYPE lqua-verme,
      gv_meins      TYPE lqua-meins,
      gv_valid      TYPE bool,
      gv_ldest      TYPE lvs_ldest, "campo de impressora
      gv_lines_lqua TYPE sy-tfill,   "número de linhas da tabela de lqua
      gv_pagina     TYPE p VALUE 1.  "página da UD
