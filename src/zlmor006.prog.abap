*&---------------------------------------------------------------------*
*& <Nome do cliente> # <Nome do Projeto> *
*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 10.08.2023                                                   *
*& Description : Atividade CRIANDO MEU PRIMEIRO REPORT*
*&---------------------------------------------------------------------*
*& Modifications *
*&---------------------------------------------------------------------*
*& Author Name : *
*& Date : *
*& Request : *
*& Description : *
*&---------------------------------------------------------------------*
REPORT zlmor006 NO STANDARD PAGE HEADING MESSAGE-ID 00.

TABLES: mara.

TYPES: BEGIN OF ty_tab,
         matnr TYPE mara-matnr,
         mbrsh TYPE mara-mbrsh,
         meins TYPE mara-meins,
         mtart TYPE mara-mtart,
       END OF ty_tab.

DATA: gs_mat TYPE ty_tab,
      gt_mat TYPE STANDARD TABLE OF ty_tab.

CONSTANTS: gc_high(3) TYPE c VALUE '500'.

SELECT-OPTIONS: s_mat FOR mara-matnr OBLIGATORY.

INITIALIZATION.
  s_mat-low = '1'.
  s_mat-high = gc_high.
  APPEND s_mat.

AT SELECTION-SCREEN.
  IF s_mat-low = abap_false.
    MESSAGE i398(00) WITH text-001.
*    MESSAGE i398(00) WITH 'Material não encontrado'.
  ELSEIF s_mat-high = ' '.
    MESSAGE i398(00) WITH 'Material não encontrado'.
  ENDIF.

TOP-OF-PAGE.
  WRITE: / 'Dados gerais de material da tabela MARA' COLOR 7.
  ULINE.
  WRITE: / 'Material' COLOR 1,
    24 'Setor industrial' COLOR 2,
    42 'Unid. Medida' COLOR 3,
    57 'Tipo material' COLOR 4.
  ULINE.

end-of-page.

START-OF-SELECTION.
  SELECT matnr mbrsh meins mtart FROM mara
  INTO TABLE gt_mat WHERE matnr IN s_mat.

  SORT gt_mat BY matnr.

  LOOP AT gt_mat INTO gs_mat.
    WRITE: / gs_mat-matnr,
    25 gs_mat-mbrsh,
    43 gs_mat-meins,
    58 gs_mat-mtart.
  ENDLOOP.

end-of-selection.

  ULINE.
  WRITE: / 'Relatório WRITE' COLOR 7.
  ULINE.
  SKIP.
