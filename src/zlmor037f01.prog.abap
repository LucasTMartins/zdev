*&---------------------------------------------------------------------*
*& Include          ZLMOR0037F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-002. "Selecionando dados. Aguarde...

  " Passando dados de documento de compra para tabela interna(GT_SAIDA)
  FREE gt_saida.
  SELECT ebeln ebelp matnr werks lgort menge meins netwr "Doc//Item//Material//Centro//Depósito//Quantidade//UMB//Valor
    FROM ekpo
    INTO TABLE gt_saida
    WHERE ebeln IN s_ebeln.  "Num doc

  " Verificando se há dados na tabela interna(gt_saida)
  IF gt_saida[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003.   "Nenhum registro encontrado
    STOP.
  ENDIF.

  SORT: gt_saida BY ebeln. "Documento de compra
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
FORM f_fieldcat_init.
  CLEAR: gt_fieldcat[], gs_fieldcat.

  PERFORM f_add_campo USING 'EBELN' 'EKPO' 'N° do documento'.
  PERFORM f_add_campo USING 'EBELP' 'EKPO' 'Item'.
  PERFORM f_add_campo USING 'MATNR' 'EKPO' 'Material'.
  PERFORM f_add_campo USING 'WERKS' 'EKPO' 'Centro'.
  PERFORM f_add_campo USING 'LGORT' 'EKPO' 'Depósito'.
  PERFORM f_add_campo USING 'MENGE' 'EKPO' 'Quantidade'.
  PERFORM f_add_campo USING 'MEINS' 'EKPO' 'UMB'.
  PERFORM f_add_campo USING 'NETWR' 'EKPO' 'Valor'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMIR_DADOS
*&---------------------------------------------------------------------*
FORM f_imprimir_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 60
      text       = TEXT-004. "Imprimindo dados. Aguarde...

  " Imprimindo ALV GRID
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gv_repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
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


*&---------------------------------------------------------------------*
*&      Form  F_ADD_CAMPO
*&---------------------------------------------------------------------*
FORM f_add_campo USING pv_fieldname
                       pv_tabname
                       pv_seltext_l.

  " Criando fieldcat
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = pv_fieldname.
  gs_fieldcat-tabname = pv_tabname.
  gs_fieldcat-seltext_l = pv_seltext_l.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
