*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 20.12.2024                                                   *
*& Description : Testando a impressão de etiqueta                      *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor047.

DATA: lt_text    TYPE TABLE OF tline,
      ls_header  TYPE thead,
      lv_spool   TYPE pri_params,
      lv_valid   TYPE char256,
      lv_message TYPE string.

" Recupera o número do spool
CALL FUNCTION 'GET_PRINT_PARAMETERS'
  EXPORTING
    destination            = 'LOCL'
    immediately            = abap_true
    no_dialog              = abap_true
  IMPORTING
    out_parameters         = lv_spool
    valid                  = lv_valid
  EXCEPTIONS
    archive_info_not_found = 1
    invalid_print_params   = 2
    invalid_archive_params = 3
    OTHERS                 = 4.

IF sy-subrc <> 0.
  MESSAGE 'Etiqueta gerada, mas não foi possível recuperar o Spool ID.' TYPE 'W'.
ENDIF.

ls_header-tdobject  = 'TEXT'.
ls_header-tdname    = 'ZLMO_TESTE2'.
ls_header-tdid      = 'ST'.
ls_header-tdspras   = 'P'.

NEW-PAGE PRINT ON PARAMETERS lv_spool NO DIALOG.

" Lê o texto padrão da SO10
CALL FUNCTION 'READ_TEXT'
  EXPORTING
    id       = 'ST'
    language = sy-langu
    name     = 'ZLMO_TESTE'
    object   = 'TEXT'
  TABLES
    lines    = lt_text
  EXCEPTIONS
    OTHERS   = 1.

IF sy-subrc <> 0.
  MESSAGE 'Erro ao ler o texto padrão.' TYPE 'E'.
ENDIF.

CALL FUNCTION 'FORMAT_TEXTLINES'
  EXPORTING
    formatwidth = 132
    linewidth   = 80
  TABLES
    lines       = lt_text.

LOOP AT lt_text INTO DATA(ls_text).
  WRITE: / ls_text-tdline.
  CLEAR ls_text.
ENDLOOP.

NEW-PAGE PRINT OFF.
