*&---------------------------------------------------------------------*
*& Include ZLMOR038TOP                              - Report ZLMOR038
*&---------------------------------------------------------------------*
REPORT zlmor038 MESSAGE-ID 00.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : ltak.

*&---------------------------------------------------------------------*
*& Constants declaration
*&---------------------------------------------------------------------*
CONSTANTS : gc_icon_alv    TYPE char10 VALUE 'icon_alv',
            gc_lgnum       TYPE char10 VALUE 'lgnum',
            gc_tanum       TYPE char10 VALUE 'tanum',
            gc_bwlvs       TYPE char10 VALUE 'bwlvs',
            gc_bdatu       TYPE char10 VALUE 'bdatu',
            gc_tapos       TYPE char10 VALUE 'tapos',
            gc_posnr       TYPE char10 VALUE 'posnr',
            gc_matnr       TYPE char10 VALUE 'matnr',
            gc_mtart       TYPE char10 VALUE 'mtart',
            gc_matkl       TYPE char10 VALUE 'matkl',
            gc_maktx       TYPE char10 VALUE 'maktx',
            gc_werks       TYPE char10 VALUE 'werks',
            gc_name1       TYPE char10 VALUE 'name1',
            gc_bwkey       TYPE char10 VALUE 'bwkey',
            gc_selmode     TYPE c      VALUE 'D',
            gc_isave       TYPE c      VALUE 'A',
            gc_popbut_func TYPE string VALUE 'POPUP',
            gc_popbut_type TYPE p      VALUE 4.


*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_ltak,
         lgnum TYPE ltak-lgnum,
         tanum TYPE ltak-tanum,
         bwlvs TYPE ltak-bwlvs,
         bdatu TYPE ltak-bdatu,
       END OF gty_ltak,
       BEGIN OF gty_ltap,
         lgnum TYPE ltap-lgnum,
         tanum TYPE ltap-tanum,
         tapos TYPE ltap-tapos,
         posnr TYPE ltap-posnr,
         matnr TYPE ltap-matnr,
         werks TYPE ltap-werks,
       END OF gty_ltap,
       BEGIN OF gty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF gty_mara,
       BEGIN OF gty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF gty_makt,
       BEGIN OF gty_t001w,
         werks TYPE t001w-werks,
         name1 TYPE t001w-name1,
         bwkey TYPE t001w-bwkey,
       END OF gty_t001w,
       BEGIN OF gty_saida,
         icon_alv TYPE char6,
         lgnum    TYPE ltak-lgnum,
         tanum    TYPE ltak-tanum,
         bwlvs    TYPE ltak-bwlvs,
         bdatu    TYPE ltak-bdatu,
         tapos    TYPE ltap-tapos,
         posnr    TYPE ltap-posnr,
         matnr    TYPE mara-matnr,
         mtart    TYPE mara-mtart,
         matkl    TYPE mara-matkl,
         maktx    TYPE makt-maktx,
         werks    TYPE t001w-werks,
         name1    TYPE t001w-name1,
         bwkey    TYPE t001w-bwkey,
       END OF gty_saida.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_ltak     TYPE STANDARD TABLE OF gty_ltak,
      gt_ltap     TYPE STANDARD TABLE OF gty_ltap,
      gt_mara     TYPE STANDARD TABLE OF gty_mara,
      gt_makt     TYPE STANDARD TABLE OF gty_makt,
      gt_t001w    TYPE STANDARD TABLE OF gty_t001w,
      gt_saida    TYPE STANDARD TABLE OF gty_saida,
      gt_fieldcat TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_ltap     TYPE gty_ltap,
      gs_ltak     TYPE gty_ltak,
      gs_mara     TYPE gty_mara,
      gs_makt     TYPE gty_makt,
      gs_t001w    TYPE gty_t001w,
      gs_saida    TYPE gty_saida,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo,
      gs_variant  TYPE disvariant.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_but TYPE stb_button.

*&---------------------------------------------------------------------*
*& Objects (Global)
*&---------------------------------------------------------------------*
DATA: go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Ordem de depósitos
  SELECT-OPTIONS: s_lgnum FOR ltak-lgnum OBLIGATORY,          "Nºdepósito
                  s_bdatu FOR ltak-bdatu OBLIGATORY.          "Data da ordem de transferência
SELECTION-SCREEN END OF BLOCK b1.
