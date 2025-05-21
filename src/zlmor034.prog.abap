*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 04.10.2023                                           *
*& Description  : Criando smartform de contrato                        *
*&---------------------------------------------------------------------*
REPORT zlmor034 NO STANDARD PAGE HEADING MESSAGE-ID 00.

"" TESTAR NO AMBIENTE QAS

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS :
  gc_formname    TYPE tdsfname VALUE 'ZLMO_SF_TESTE001',
  gc_ordemcompra TYPE string   VALUE 'Ordem de compra não existe'
  .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA:
      gs_dados TYPE zslmo001
      .

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gv_kunnr TYPE ekko-kunnr,
  gv_name  TYPE rs38l_fnam
  .

**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Parâmetro de seleção
  PARAMETERS: p_ebeln TYPE ekko-ebeln.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  CLEAR gs_dados.

  PERFORM:
    f_busca_oc,
    f_busca_cliente,
    f_chama_smartform
    .

**----------------------------------------------------------------------*
  "" FORM F_BUSCA_OC
FORM f_busca_oc.
  "busca ordem de compra
  SELECT SINGLE ebeln kunnr
    INTO (gs_dados-ebeln, gv_kunnr)
    FROM ekko
    WHERE ebeln = p_ebeln.

  "verificando erros
  IF sy-subrc <> 0.
    MESSAGE i398 WITH gc_ordemcompra.
    STOP.
  ENDIF.
ENDFORM.

"" FORM F_BUSCA_CLIENTE
FORM f_busca_cliente.
  "busca o cliente
  SELECT SINGLE name1
    INTO gs_dados-name1
    FROM kna1
    WHERE kunnr = gv_kunnr.
ENDFORM.

"" FORM F_CHAMA_SMARTFORM
FORM f_chama_smartform.
  CLEAR gv_name.

  "busca nome da funcao do smartform
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = gc_formname "Nome do smartform
    IMPORTING
      fm_name            = gv_name "Nome da função do smartform
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  CALL FUNCTION gv_name
    EXPORTING
      wa_dados         = gs_dados
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.

ENDFORM.
