*&---------------------------------------------------------------------*
*& <Nome do cliente> # <Nome do Projeto> *
*&---------------------------------------------------------------------*
*& Domain :  *
*& Program type : Report *
*& Author Name : Lucas Martins de Oliveira *
*& Date : 14.08.2023 *
*& Description : Exercicio 2 - Reports e Comandos *
*&---------------------------------------------------------------------*
*& Modifications *
*&---------------------------------------------------------------------*
*& Author Name : *
*& Date : *
*& Request : *
*& Description : *
*&---------------------------------------------------------------------*
REPORT zlmor008 LINE-SIZE 70.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : ekko, ekpo.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_ekko,
        ebeln LIKE ekko-ebeln,
        bukrs LIKE ekko-bukrs,
        bstyp LIKE ekko-bstyp,
      END OF ty_ekko,
      BEGIN OF ty_ekpo,
        ebeln LIKE ekpo-ebeln,
        ebelp LIKE ekpo-ebelp,
        matnr LIKE ekpo-matnr,
        werks LIKE ekpo-werks,
        lgort LIKE ekpo-lgort,
      END OF ty_ekpo.

DATA: gt_ekko TYPE STANDARD TABLE OF ty_ekko,
      gt_ekpo TYPE STANDARD TABLE OF ty_ekpo,
      gs_ekko TYPE ty_ekko,
      gs_teste LIKE gs_ekko,
      gs_ekpo TYPE ty_ekpo.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  SELECT-OPTIONS: s_ebeln FOR ekpo-ebeln.
SELECTION-SCREEN END OF BLOCK b1.
*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  s_ebeln-low     = '4500000000'.
  s_ebeln-high    = '4500000030'.
  s_ebeln-option  = 'EQ'.
  s_ebeln-sign    = 'I'.
  APPEND s_ebeln.

TOP-OF-PAGE.
  WRITE: / sy-vline, 2 'Documento',
    12 sy-vline, 13 'Item',
    18 sy-vline, 19 'Material',
    37 sy-vline, 38 'Centro',
    44 sy-vline, 45 'Grup',
    49 sy-vline, 50 'Empresa',
    60 sy-vline, 61 'Categoria', 70 sy-vline.
    ULINE.
end-of-page.

START-OF-SELECTION.
  SELECT ebeln bukrs bstyp
    FROM ekko
    INTO TABLE gt_ekko
    WHERE ebeln IN s_ebeln.

  IF gt_ekko[] IS INITIAL.
    MESSAGE i398(00) WITH 'Nenhum registro encontrado'.
    STOP.
  ENDIF.

  SORT gt_ekko BY ebeln.

  SELECT ebeln ebelp matnr werks lgort
    FROM ekpo
    INTO TABLE gt_ekpo
    FOR ALL ENTRIES IN gt_ekko
    WHERE ebeln EQ gt_ekko-ebeln.

  SORT gt_ekpo by ebeln.

  LOOP AT gt_ekpo INTO gs_ekpo.
    READ TABLE gt_ekko INTO gs_ekko WITH KEY ebeln = gs_ekpo-ebeln BINARY SEARCH.
    write: / sy-vline, 2 gs_ekpo-ebeln COLOR COL_KEY,
            12 sy-vline, 13 gs_ekpo-ebelp COLOR COL_KEY,
            18 sy-vline, 19 gs_ekpo-matnr COLOR COL_normal,
            37 sy-vline, 38 gs_ekpo-werks COLOR COL_normal,
            44 sy-vline, 45 gs_ekpo-lgort COLOR COL_normal,
            49 sy-vline, 50 gs_ekko-bukrs COLOR COL_normal,
            60 sy-vline, 61 gs_ekko-bstyp COLOR COL_normal, 70 sy-vline.
    ENDLOOP.
