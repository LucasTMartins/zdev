*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 21.08.2023                                           *
*& Description  : Criando segundo ALV - estrutura                      *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor013.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPE-POOLS: slis. "módulo de lista genérico

TYPES: BEGIN OF gty_ekko, "cabeçalho doc compras
         ebeln TYPE ekko-ebeln, "N° do documento de compras
         bukrs TYPE ekko-bukrs, "Empresas
         lifnr TYPE ekko-lifnr, "N° de conta do fornecedor
         bedat TYPE ekko-bedat, "Data do documento de compra
       END OF gty_ekko.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_saida    TYPE STANDARD TABLE OF gty_ekko WITH HEADER LINE,
      gt_fieldcat TYPE slis_t_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_repid TYPE sy-repid. "nome do programa

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ebeln FOR gt_saida-ebeln. "n° do documento de compras
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  gv_repid = sy-repid. "nome do programa

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_buscar_dados.
  PERFORM f_fieldcat_init.
  PERFORM f_list_display.

*----------------------------------------------------------------------*
END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  F_buscar_dados
*&---------------------------------------------------------------------*
*       Obter informações para a lista
*----------------------------------------------------------------------*
FORM f_buscar_dados.

  PERFORM f_sapgui_progress_indicator USING TEXT-002.

  SELECT ebeln bukrs lifnr bedat "n° do doc compra//empresa//n° da conta do fonecedor//data do doc compra
    INTO TABLE gt_saida
    FROM ekko "cabeçalho do doc compras
    WHERE ebeln IN s_ebeln.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_SAPGUI_PROGRESS_INDICATOR
*&---------------------------------------------------------------------*
*       INTERAGIR COM O FRONT-END - ENVIAR MENSAGENS
*----------------------------------------------------------------------*
*       -->PV_TEXT - MENSAGEM
*----------------------------------------------------------------------*
FORM f_sapgui_progress_indicator USING VALUE(pv_text).

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = pv_text. "texto inserido no perform
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
*       ESTRUTURA DA LISTA
*----------------------------------------------------------------------*
FORM f_fieldcat_init.

  CLEAR gt_fieldcat[].
  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = 'EBELN'.
  gs_fieldcat-ref_tabname = 'EKKO'.
  gs_fieldcat-seltext_l = 'N° DO DOCUMENTO'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'BUKRS'.
  gs_fieldcat-ref_tabname = 'EKKO'.
  gs_fieldcat-seltext_l = 'EMPRESA'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'LIFNR'.
  gs_fieldcat-ref_tabname = 'EKKO'.
  gs_fieldcat-seltext_l = 'FORNECEDOR'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'BEDAT'.
  gs_fieldcat-ref_tabname = 'EKKO'.
  gs_fieldcat-seltext_l = 'DATA'.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       DISPLAY DA LISTA
*----------------------------------------------------------------------*
FORM f_list_display.
  PERFORM f_sapgui_progress_indicator USING TEXT-003.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gv_repid "nome do programa
      it_fieldcat        = gt_fieldcat
      i_save             = 'A'
    TABLES
      t_outtab           = gt_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
