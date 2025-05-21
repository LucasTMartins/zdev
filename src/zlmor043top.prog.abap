*&---------------------------------------------------------------------*
*& Include          ZLMOR043TOP
*&---------------------------------------------------------------------*
REPORT zlmor043 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : ekko.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_nodekey_root TYPE tv_nodekey VALUE 'ROOT',
            gc_langu_en        TYPE spras VALUE 'E',
            gc_mtreesnode   TYPE x030l-tabname VALUE 'MTREESNODE',
            BEGIN OF gc_fieldcat_build,
              ebeln    TYPE string VALUE 'EBELN',
              ebelp    TYPE string VALUE 'EBELP',
              uniqueid TYPE string VALUE 'UNIQUEID',
              aedat    TYPE string VALUE 'AEDAT',
              matnr    TYPE string VALUE 'MATNR',
              ekpo     TYPE string VALUE 'EKPO',
            END OF gc_fieldcat_build,
            BEGIN OF gc_ucomm_0100,
              back   TYPE string VALUE 'BACK',
              exit   TYPE string VALUE 'EXIT',
              cancel TYPE string VALUE 'CANCEL',
            END OF gc_ucomm_0100.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: gty_node_table TYPE STANDARD TABLE OF mtreesnode WITH DEFAULT KEY,
       BEGIN OF gty_tree,
         ebeln TYPE ekko-ebeln,
       END OF gty_tree,
       BEGIN OF gty_grid,
         ebeln    TYPE ekpo-ebeln,
         ebelp    TYPE ekpo-ebelp,
         uniqueid TYPE ekpo-uniqueid,
         aedat    TYPE ekpo-aedat,
         matnr    TYPE ekpo-matnr,
       END OF gty_grid,
       BEGIN OF gty_material,
         matnr TYPE mara-matnr,
         maktx TYPE makt-maktx,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF gty_material.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_tree          TYPE TABLE OF gty_tree,
      gt_node_table    TYPE gty_node_table,
      gt_grid          TYPE TABLE OF gty_grid,
      gt_fieldcat_grid TYPE lvc_t_fcat.

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_tree     TYPE gty_tree,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo,
      gs_mara     TYPE mara,
      gs_makt     TYPE makt,
      gs_material TYPE gty_material.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
CLASS lcl_application DEFINITION DEFERRED.

DATA: go_alv_grid       TYPE REF TO cl_gui_alv_grid,
      go_alv_tree       TYPE REF TO cl_gui_simple_tree,
      go_container_tree TYPE REF TO cl_gui_docking_container,
      go_container_grid TYPE REF TO cl_gui_docking_container,
      go_application    TYPE REF TO lcl_application,
      go_behaviour_tree TYPE REF TO cl_dragdrop,
      go_behaviour_grid TYPE REF TO cl_dragdrop.

**&---------------------------------------------------------------------*
**& Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_ebeln FOR ekko-ebeln.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  CALL SCREEN 0100.
