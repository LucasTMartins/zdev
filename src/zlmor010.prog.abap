*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 16.08.2023                                                   *
*& Description : Testando funções                                      *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor010.

TABLES: sscrfields.

DATA: gv_mes  TYPE isellist-month VALUE 202302,    "variavel do mes importado
      itab    TYPE STANDARD TABLE OF casdayattr,   "tabela interna do dia da semana
      gs_itab TYPE casdayattr.                    "estrutura da tabela interna

SELECTION-SCREEN BEGIN OF BLOCK b0.              "tela de selecao com botao de call_browser
  SELECTION-SCREEN PUSHBUTTON 1(25) p_butyou USER-COMMAND but1.
SELECTION-SCREEN END OF BLOCK b0.



INITIALIZATION.
  CALL FUNCTION 'ICON_CREATE'                "criando botao com icone
    EXPORTING
      name   = icon_column_right
      text   = 'Google'
      info   = 'Abre Google'
    IMPORTING
      result = p_butyou
    EXCEPTIONS
      OTHERS = 0.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'BUT1'.               "testando botao com icone
    MESSAGE i398(00) WITH TEXT-001.
  ENDIF.
*  CALL FUNCTION 'CALL_BROWSER'               "somente testando
*   EXPORTING
*     URL                          = ' '
*     WINDOW_NAME                  = ' '
*     NEW_WINDOW                   = ' '
*     BROWSER_TYPE                 =
*     CONTEXTSTRING                =
*   EXCEPTIONS
*     FRONTEND_NOT_SUPPORTED       = 1
*     FRONTEND_ERROR               = 2
*     PROG_NOT_FOUND               = 3
*     NO_BATCH                     = 4
*     UNSPECIFIED_ERROR            = 5
*     OTHERS                       = 6
*            .


START-OF-SELECTION.
  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'              "função que chama popup de selecao de mes recebendo inicialização
    EXPORTING
      actual_month   = gv_mes
    IMPORTING
      selected_month = gv_mes.                       "recebendo valor final do mes

  CALL FUNCTION 'DAY_ATTRIBUTES_GET'                 "recebendo dados do dia da semana
    EXPORTING
      date_from      = sy-datum
      language       = sy-langu
    TABLES
      day_attributes = itab[].

  READ TABLE itab INTO gs_itab INDEX 1.              "passando os dados do index 1 da tabela interna para a estrutura gs_itab

  CONCATENATE gv_mes+4 gv_mes(4) INTO gv_mes.        "concatenando data para formato legivel
  WRITE:/ gv_mes(2), '/', gv_mes+2,                  "escrevendo data e estrutura gs_itab
        / gs_itab.

END-OF-SELECTION.
