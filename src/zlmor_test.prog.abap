*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 17.08.2023                                                   *
*& Description : Testando coisas                                       *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZRIC_OLE2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
 "asdlajsd
REPORT zmodelo_ole.
data: lv_answer TYPE abap_bool.

CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
   TITLEBAR                    = 'ATENÇÃO'
*   DIAGNOSE_OBJECT             = ' '
    text_question               = 'Já existem Ots de cubagem para o material atual. Modificar os dados poderá atrapalhar a produção do mesmo. Deseja continuar?'
   TEXT_BUTTON_1               = 'Sim'
*   ICON_BUTTON_1               = ' '
   TEXT_BUTTON_2               = 'Não'
*   ICON_BUTTON_2               = ' '
   DEFAULT_BUTTON              = '2'
   DISPLAY_CANCEL_BUTTON       = space
*   USERDEFINED_F1_HELP         = ' '
*   START_COLUMN                = 25
*   START_ROW                   = 6
*   POPUP_TYPE                  =
*   IV_QUICKINFO_BUTTON_1       = ' '
*   IV_QUICKINFO_BUTTON_2       = ' '
 IMPORTING
   ANSWER                      = lv_answer
* TABLES
*   PARAMETER                   =
 EXCEPTIONS
   TEXT_NOT_FOUND              = 1
   OTHERS                      = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
