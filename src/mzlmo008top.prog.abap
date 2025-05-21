*&---------------------------------------------------------------------*
*& Include          MZLMO008TOP
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo008 MESSAGE-ID 00.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : zlmot008.

*&---------------------------------------------------------------------*
*& Constants declaration
*&---------------------------------------------------------------------*
CONSTANTS : gc_container_name_alv(13) TYPE c             VALUE 'CONTAINER_ALV',
            gc_container_name_out(13) TYPE c             VALUE 'CONTAINER_OUT',
            gc_container_name_himg(8) TYPE c             VALUE 'HOME_IMG',
            gc_back                   TYPE string        VALUE 'BACK',
            gc_exit                   TYPE string        VALUE 'EXIT',
            gc_cancel                 TYPE string        VALUE 'CANCEL',
            gc_enter                  TYPE string        VALUE 'ENTER',
            gc_save                   TYPE string        VALUE 'SAVE',
            gc_mtreeitm               TYPE x030l-tabname VALUE 'MTREEITM',
            gc_type_img(5)            TYPE c             VALUE 'image',
            gc_sbtype_img(9)          TYPE c             VALUE 'X-UNKNOWN',
            BEGIN OF gc_icons,                                 ""ICONES PARA OS ITENS
              checkin(46)     TYPE c VALUE '@OQ@',
              marcar_voo(46)  TYPE c VALUE '@36@',
              impr_cartao(46) TYPE c VALUE '@BX@',
            END OF gc_icons,
            BEGIN OF gc_column,                                ""NOMES DAS COLUNAS
              column1 TYPE tv_itmname VALUE 'Controles',
            END OF gc_column,
            BEGIN OF gc_nodekey,                               ""CHAVES PARA NÓS
              root        TYPE tv_nodekey VALUE 'ROOT',
              checkin     TYPE tv_nodekey VALUE 'CHECKIN',
              marcar_voo  TYPE tv_nodekey VALUE 'MARCAR_VOO',
              impr_cartao TYPE tv_nodekey VALUE 'IMPR_CARTAO',
            END OF gc_nodekey,
            BEGIN OF gc_itemtext,                              ""TEXTOS DOS ITENS
              root        TYPE scrpcha72 VALUE 'Controle',
              checkin     TYPE scrpcha72 VALUE 'Check-in',
              marcar_voo  TYPE scrpcha72 VALUE 'Marcar Vôo',
              impr_cartao TYPE scrpcha72 VALUE 'Impressão de Embarque',
            END OF gc_itemtext,
            BEGIN OF gc_img_param,                             ""PARAMETROS DE IMAGEM PARA CONVERSÃO
              p_object TYPE tdobjectgr VALUE 'GRAPHICS',
              p_name   TYPE tdobname   VALUE 'ZAVIAO_EMBARQUE2',
              p_id     TYPE tdidgr     VALUE 'BMAP',
              p_btype  TYPE tdbtype    VALUE 'BCOL',
            END OF gc_img_param,
            BEGIN OF gc_popup_fields,                           ""PARAMETROS PARA O POPUP DE MARCAÇÃO DE VÔO
              tabname(15)    TYPE c VALUE 'SFLIGHT',
              fieldname1(15) TYPE c VALUE 'CARRID',
              fieldname2(15) TYPE c VALUE 'CONNID',
              fieldname3(15) TYPE c VALUE 'FLDATE',
              field_attr(15) TYPE c VALUE '01',
            END OF gc_popup_fields,
            BEGIN OF gc_popup_fields2,                           ""PARAMETROS PARA O POPUP DE IMPRESSÃO DE VÔO
              tabname(15)    TYPE c VALUE 'ZSLMO005',
              fieldname1(15) TYPE c VALUE 'CARRID',
              fieldname2(15) TYPE c VALUE 'CONNID',
              fieldname3(15) TYPE c VALUE 'FLDATE',
              fieldname4(15) TYPE c VALUE 'BOOKID',
              fieldname5(15) TYPE c VALUE 'FLAG',
              fieldname6(15) TYPE c VALUE 'FILENAME',
              field_attr(15) TYPE c VALUE '01',
            END OF gc_popup_fields2.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: gty_item_table TYPE STANDARD TABLE OF mtreeitm WITH DEFAULT KEY.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_picbin  TYPE solix_tab,        "para imagem na tela inicial
      gt_checkin TYPE TABLE OF sbook,   "para fazer checkin
      gt_sflight TYPE TABLE OF sflight. "para marcar o vôo

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_lmot008 TYPE zlmot008,
      gs_checkin TYPE sbook,
      gs_sflight TYPE sflight,
      gs_sbook   TYPE sbook,
      gs_0120    TYPE sbook.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA: gv_bindata           TYPE xstring,
      gv_url               TYPE char255,
      gv_answer_checkin(1) TYPE c,
      gv_subscreen(4)      TYPE n VALUE '0110',
      BEGIN OF gv_checkin_param,
        seatnum(4) TYPE n,
        seatrow    TYPE c,
        location   TYPE n,
      END OF gv_checkin_param,
      BEGIN OF gv_popup_param,
        carrid(3) TYPE c,
        connid(4) TYPE n,
        fldate    TYPE d,
      END OF gv_popup_param,
      BEGIN OF gv_impr_function,
        msg_sucess TYPE string,
        msg_error  TYPE string,
      END OF gv_impr_function.

*&---------------------------------------------------------------------*
*& Objects declaration (Global)
*&---------------------------------------------------------------------*
CLASS lcl_events DEFINITION DEFERRED. "para encontrar a classe antes de ser definida

DATA : go_custom_container TYPE REF TO cl_gui_custom_container,
       go_container_out    TYPE REF TO cl_gui_custom_container,
       go_home_img         TYPE REF TO cl_gui_custom_container,
       go_tree             TYPE REF TO cl_gui_column_tree,
       go_pic              TYPE REF TO cl_gui_picture,
       go_events           TYPE REF TO lcl_events.
