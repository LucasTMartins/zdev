*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 17.08.2023                                                   *
*& Description : Criando primeiro ALV                                  *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor012.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPE-POOLS: slis. "Tipos globais para módulos de lista genéricos

TYPES: BEGIN OF gty_saida.
         INCLUDE STRUCTURE t001. "países
TYPES: END OF gty_saida.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*

DATA: gt_saida TYPE STANDARD TABLE OF gty_saida WITH HEADER LINE.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*

DATA: gv_repid TYPE sy-repid. "nome do programa

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-001. "Testando titulo
  SELECT-OPTIONS: s_bukrs FOR gt_saida-bukrs. "empresas
SELECTION-SCREEN END OF BLOCK b0.

*----------------------------------------------------------------------*
*INITIALIZATION.
*----------------------------------------------------------------------*

INITIALIZATION.
  gv_repid = sy-repid. "nome do programa


START-OF-SELECTION.

  PERFORM f_buscar_dados.
  PERFORM f_list_display.

*&---------------------------------------------------------------------*
*& Form F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
* OBTER INFORMAÇÕES PARA LISTA
*----------------------------------------------------------------------*
FORM f_buscar_dados.

  PERFORM f_sapgui_progress_indicator USING TEXT-002. "'Selecionando dados. Aguarde...'

  SELECT * INTO TABLE gt_saida
                    FROM t001 "paises
                    WHERE bukrs IN s_bukrs. "empresas
ENDFORM. "f_buscar_dados

*&---------------------------------------------------------------------*
*& Form F_sapgui_progress_indicator
*&---------------------------------------------------------------------*
* INTERAGIR COM O FRONT-END - ENVIAR MENSAGENS
*----------------------------------------------------------------------*
* --> PV_TEXT - MENSAGENS
*----------------------------------------------------------------------*
FORM f_sapgui_progress_indicator USING VALUE(pv_text).

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = pv_text. "texto recebido no perform

ENDFORM. "f_sapgui_progress_indicator

*&---------------------------------------------------------------------*
*& Form F_LIST_DISPLAY
*&---------------------------------------------------------------------*
* LISTA INFORMAÇÕES NA TELA
*----------------------------------------------------------------------*
FORM f_list_display.

  PERFORM f_sapgui_progress_indicator USING TEXT-003. "'Estruturando a lista. Aguarde...'

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = gv_repid "nome do programa
      i_structure_name   = 'T001' "paises
      i_save             = 'A'
    TABLES
      t_outtab           = gt_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.
ENDFORM. "F_LIST_DISPLAY
