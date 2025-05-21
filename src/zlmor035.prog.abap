*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 05.10.2023                                           *
*& Description  : Criando smartform com tabela                         *
*&---------------------------------------------------------------------*
REPORT zlmor035 NO STANDARD PAGE HEADING MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : mara.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS :
  gc_formname TYPE tdsfname VALUE 'ZLMO_SF_TESTE002'
  .

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
  gt_mara TYPE STANDARD TABLE OF zslmo002
  .

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gv_name TYPE rs38l_fnam
  .

**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ersda FOR mara-ersda. "Data de criação do material
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM f_get_data.
  PERFORM f_call_smartforms.

  "" FORM F_GET_DATA
FORM f_get_data.
  SELECT matnr ersda mtart matkl
    FROM mara
    INTO TABLE gt_mara
    WHERE ersda IN s_ersda.

  IF sy-subrc <> 0.
    MESSAGE i398 WITH TEXT-002. "Materiais não existem para essa data de criação
    STOP.
  ENDIF.
ENDFORM.

"" FORM F_CALL_SMARTFORMS
FORM f_call_smartforms.
  CLEAR gv_name.

  "Busca nome da função relacionada ao smartform
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = gc_formname "nome do formulario
    IMPORTING
      fm_name            = gv_name "nome da função do smartform
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  "chama formulario
  CALL FUNCTION gv_name
    TABLES
      gt_mara          = gt_mara[]
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.

ENDFORM.
