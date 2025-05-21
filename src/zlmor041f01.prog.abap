*&---------------------------------------------------------------------*
*& Include          ZLMOR041F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-001. "Selecionando dados. Aguarde...

  " Passando dados de vôo para tabela interna(GT_SAIDA)
  FREE gt_saida.
  SELECT carrid airpfrom airpto cityfrom cityto deptime arrtime
    FROM SPFLI
    INTO TABLE gt_saida
    WHERE carrid IN s_carrid.

  " Verificando se há dados na tabela interna(gt_saida)
  IF gt_saida[] IS INITIAL.
    MESSAGE i398 WITH TEXT-002.   "Nenhum registro encontrado
    STOP.
  ENDIF.

  SORT: gt_saida BY carrid. "Documento de compra
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
FORM f_fieldcat_init.
  CLEAR: gt_fieldcat[], gs_fieldcat.

  PERFORM f_add_campo USING 'CARRID'   'SPFLI' 'Companhia aérea'.
  PERFORM f_add_campo USING 'AIRPFROM' 'SPFLI' 'Item'.
  PERFORM f_add_campo USING 'AIRPTO'   'SPFLI' 'Material'.
  PERFORM f_add_campo USING 'CITYFROM' 'SPFLI' 'Centro'.
  PERFORM f_add_campo USING 'CITYTO'   'SPFLI' 'Depósito'.
  PERFORM f_add_campo USING 'DEPTIME'  'SPFLI' 'Quantidade'.
  PERFORM f_add_campo USING 'ARRTIME'  'SPFLI' 'UMB'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMIR_DADOS
*&---------------------------------------------------------------------*
FORM f_imprimir_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 60
      text       = TEXT-003. "Imprimindo dados. Aguarde...

  gs_layout-colwidth_optimize = abap_true.                  "Otimizar a largura da coluna
  gs_layout-zebra             = abap_true.                  "Cores zebra

  " Imprimindo ALV GRID
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
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
  gs_fieldcat-tabname   = pv_tabname.
  gs_fieldcat-seltext_l = pv_seltext_l.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
