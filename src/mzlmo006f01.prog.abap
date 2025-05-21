*&---------------------------------------------------------------------*
*& Include          MZLMO006F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      FORM F_CREATE_CONTAINER
*&---------------------------------------------------------------------*
FORM f_create_container.
  IF go_container IS INITIAL.
    "criando objeto container
    CREATE OBJECT go_container
      EXPORTING
        container_name              = 'CONT'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "criando grid para container
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container.

    "Recebe os eventos acontecidos no grid
    CREATE OBJECT event_receiver.
    SET HANDLER   event_receiver->handle_user_command FOR go_alv_grid.
    SET HANDLER   event_receiver->handle_toolbar      FOR go_alv_grid.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = gc_perc40
      text       = TEXT-001. "Selecionando dados. Aguarde...

  " Passando dados de documento de compra para tabela interna(GT_SAIDA)
  FREE gt_saida.
  SELECT ebeln bukrs bstyp aedat ernam lifnr "Doc//Empresa//Categoria//Data//Responsavel//Num fornecedor
    FROM ekko
    INTO TABLE gt_saida
    WHERE ebeln IN s_ebeln  "Num doc
    AND   aedat IN s_aedat. "Material

  " Verificando se há dados na tabela interna(gt_saida)
  IF gt_saida[] IS INITIAL.
    MESSAGE i000 WITH TEXT-002.   "Nenhum registro encontrado
    LEAVE TO SCREEN 0100.         "Sem isso a tabela aparecerá vazia
  ENDIF.

  SORT: gt_saida BY ebeln. "Documento de compra
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
FORM f_fieldcat_init.
  CLEAR: gt_fieldcat[], gs_fieldcat.

  " Criando fieldcat
  PERFORM f_add_campo USING 'EBELN' 'EKKO' TEXT-004. "Documento de compras
  PERFORM f_add_campo USING 'BUKRS' 'EKKO' TEXT-005. "Empresa
  PERFORM f_add_campo USING 'BSTYP' 'EKKO' TEXT-006. "Ctg. doc
  PERFORM f_add_campo USING 'AEDAT' 'EKKO' TEXT-007. "Data criação
  PERFORM f_add_campo USING 'ERNAM' 'EKKO' TEXT-008. "Criado por
  PERFORM f_add_campo USING 'LIFNR' 'EKKO' TEXT-009. "Fornecedor
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMIR_DADOS
*&---------------------------------------------------------------------*
FORM f_imprimir_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = gc_perc60
      text       = TEXT-003. "Imprimindo dados. Aguarde...

  "imprimindo alv
  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      is_variant                    = gs_variant
      i_save                        = gc_isave
      is_layout                     = gs_layout
    CHANGING
      it_fieldcatalog               = gt_fieldcat
      it_outtab                     = gt_saida
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_ADD_CAMPO
*&---------------------------------------------------------------------*
FORM f_add_campo USING pv_fieldname TYPE string
                       pv_tabname   TYPE string
                       pv_scrtext_l TYPE string.

  " Criando estrutura do fieldcat
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = pv_fieldname.
  gs_fieldcat-tabname   = pv_tabname.
  gs_fieldcat-scrtext_l = pv_scrtext_l.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
