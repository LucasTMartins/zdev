*&---------------------------------------------------------------------*
*& Include          ZLMOR045TOP
*&---------------------------------------------------------------------*
REPORT zlmor045 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : ltak, ltap.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_lgnum(11)    TYPE c VALUE 'P_LGNUM',
            gc_zero         TYPE i VALUE 0,
            gc_percent      TYPE c VALUE '%',
            gc_container(9) TYPE c VALUE 'CONTAINER',
            BEGIN OF gc_ucomm, "para dados do sy-ucomm
              cancel TYPE string VALUE 'CANCEL', "cancelar
              exit   TYPE string VALUE 'EXIT',   "sair
              back   TYPE string VALUE 'BACK',   "voltar
              save   TYPE string VALUE 'SAVE',
            END OF gc_ucomm,
            BEGIN OF gc_display,
              i TYPE c VALUE 'I',
              e TYPE c VALUE 'E',
              s TYPE c VALUE 'S',
            END OF gc_display,
            BEGIN OF gc_savebut,
              func TYPE string VALUE 'SAVEPR',
              icon TYPE string VALUE '@2L@',
              type TYPE p      VALUE 4,
            END OF gc_savebut.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_saida,
         lgnum TYPE ltap-lgnum,
         tanum TYPE ltap-tanum,
         matnr TYPE ltap-matnr,
         vsola TYPE ltap-vsola,
         charg TYPE ltap-charg,
         vltyp TYPE ltap-vltyp,
         vlpla TYPE ltap-vlpla,
         bdatu TYPE ltak-bdatu,
         tapri TYPE ltak-tapri,
       END OF gty_saida.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_saida      TYPE TABLE OF gty_saida,
      gt_saida_copy TYPE TABLE OF gty_saida,
      gt_ltap       TYPE TABLE OF ltap,
      gt_ltak       TYPE TABLE OF ltak,
      gt_fieldcat   TYPE lvc_t_fcat.    "tabela do fieldcat para o alv grid

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_but_salv TYPE stb_button,
      gs_saida    TYPE gty_saida,
      gs_ltap     TYPE ltap,
      gs_ltak     TYPE ltak,
      gs_layout   TYPE lvc_s_layo, "layout para fieldcat
      gs_fieldcat TYPE lvc_s_fcat. "estrutura do fieldcat para o alv grid

**&---------------------------------------------------------------------*
**& Object declaration (Global)
**&---------------------------------------------------------------------*
CLASS lcl_application DEFINITION DEFERRED. "para encontrar a classe antes de ser definida

DATA: go_container_grid TYPE REF TO cl_gui_custom_container,
      go_alv_grid       TYPE REF TO cl_gui_alv_grid,
      go_application    TYPE REF TO lcl_application.

**&---------------------------------------------------------------------*
**& Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS      p_lgnum TYPE ltap-lgnum.
  SELECT-OPTIONS: s_matnr FOR ltap-matnr NO INTERVALS NO-EXTENSION,
                  s_vltyp FOR ltap-vltyp NO INTERVALS NO-EXTENSION,
                  s_bdatu FOR ltak-bdatu OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.
