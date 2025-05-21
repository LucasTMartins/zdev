*&---------------------------------------------------------------------*
*& Include          ZLMOR045F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      FORM f_initialization.
*&---------------------------------------------------------------------*
FORM f_initialization.
  DATA: ls_user TYPE lrf_wkqu.

  CALL FUNCTION 'L_USER_DATA_GET_INT'
    EXPORTING
      i_uname         = sy-uname
    IMPORTING
      e_user          = ls_user
    EXCEPTIONS
      no_entry_found  = 1
      no_unique_entry = 2
      OTHERS          = 3.

  IF sy-subrc EQ gc_zero.
    p_lgnum = ls_user-lgnum."preenchendo campo
  ENDIF.

  ""Passando dia atual para campo de data
  s_bdatu-low  = sy-datum.
  s_bdatu-high = sy-datum.
  APPEND s_bdatu TO s_bdatu[].

  IF go_application IS INITIAL.
    CREATE OBJECT go_application. "criando objeto da aplicação para botão de salvar
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-002. "Selecionando dados. Aguarde...

  "Passando dados de Cabeçalho de ordem de transporte SAD
  FREE gt_ltak.
  SELECT *
    FROM ltak
    INTO TABLE gt_ltak
    WHERE lgnum EQ p_lgnum   "Nºdepósito
    AND   bdatu IN s_bdatu   "Data da ordem de transferência
    AND   kquit EQ space.

  "verificando se a tabela está vazia
  IF gt_ltak[] IS INITIAL.
    MESSAGE i398 WITH TEXT-001 space space space DISPLAY LIKE gc_display-e.   "Nenhum registro encontrado
    LEAVE TO SCREEN gc_zero.
  ENDIF.

  "Passando dados de Item de ordem de transporte
  FREE gt_ltap.
  SELECT *
    FROM ltap
    INTO TABLE gt_ltap
    FOR ALL ENTRIES IN gt_ltak
    WHERE lgnum EQ gt_ltak-lgnum "Nº depósito
    AND   tanum EQ gt_ltak-tanum "N° OT
    AND   matnr IN s_matnr     "Nº ordem de transporte
    AND   vltyp IN s_vltyp     "N° tipo de depósito de origem
    AND   pquit EQ space.

  "verificando se a tabela está vazia
  IF gt_ltap[] IS INITIAL.
    MESSAGE i398 WITH TEXT-001 space space space DISPLAY LIKE gc_display-e.   "Nenhum registro encontrado
    LEAVE TO SCREEN gc_zero.
  ENDIF.

  ""ordenando tabelas
  SORT: gt_ltak BY tanum,
        gt_ltap BY tanum.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_prepara_dados.
*&---------------------------------------------------------------------*
FORM f_prepara_dados.
  FREE gt_saida.
  LOOP AT gt_ltap INTO gs_ltap. "passando dados das tabelas internas para tabela de saida
    READ TABLE gt_ltak INTO gs_ltak WITH KEY lgnum = gs_ltap-lgnum.
    MOVE-CORRESPONDING gs_ltap TO gs_saida.

    gs_saida-bdatu = gs_ltak-bdatu. "data
    gs_saida-tapri = gs_ltak-tapri. "prioridade
    APPEND gs_saida TO gt_saida.
  ENDLOOP.

  gt_saida_copy = gt_saida. "criando cópia para comparação ao editar
ENDFORM.
*&--------------------------------------------------------------------
*& FORM ADD FIELD
*&--------------------------------------------------------------------
FORM f_add_field USING p_fieldname TYPE any
                       p_tabname   TYPE any
                       p_scrtext_l TYPE any
                       p_edit      TYPE any.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-tabname   = p_tabname.
  gs_fieldcat-scrtext_l = p_scrtext_l.
  gs_fieldcat-edit      = p_edit.

  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_build_fields_print
*&--------------------------------------------------------------------
FORM f_build_fields.
  "montando fieldcat e chamando tela principal
  PERFORM f_add_field USING 'LGNUM' 'LTAP' TEXT-002 space.     "Nº depósito
  PERFORM f_add_field USING 'TANUM' 'LTAP' TEXT-003 space.     "Num OT
  PERFORM f_add_field USING 'MATNR' 'LTAP' TEXT-004 space.     "Material
  PERFORM f_add_field USING 'VSOLA' 'LTAP' TEXT-005 space.     "Qtd. Origem
  PERFORM f_add_field USING 'CHARG' 'LTAP' TEXT-006 space.     "Lote
  PERFORM f_add_field USING 'VLTYP' 'LTAP' TEXT-007 space.     "Tp. Origem
  PERFORM f_add_field USING 'VLPLA' 'LTAP' TEXT-008 space.     "Pos. Origem
  PERFORM f_add_field USING 'BDATU' 'LTAK' TEXT-009 space.     "Data OT
  PERFORM f_add_field USING 'TAPRI' 'LTAK' TEXT-010 abap_true. "Prioridade
ENDFORM.

FORM f_display_alv.
  IF go_container_grid IS INITIAL.
    CREATE OBJECT go_container_grid ""Container do alv grid
      EXPORTING
        container_name              = gc_container
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_dynpro_dynpro_link = 4
        lifetime_error              = 5
        OTHERS                      = 6.

    IF sy-subrc <> gc_zero.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_grid       ""Alv grid
      EXPORTING
        i_parent          = go_container_grid
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.

    IF sy-subrc <> gc_zero.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    ""Eventos dos botões de salvar
    SET HANDLER go_application->handle_toolbar_grid FOR go_alv_grid.
    SET HANDLER go_application->handle_user_command FOR go_alv_grid.

    "Layout do ALV Grid
    CLEAR gs_fieldcat.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-grid_title = TEXT-013.  "Ordens de transporte

    CALL METHOD go_alv_grid->set_table_for_first_display ""Monta tela do Alv grid
      EXPORTING
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_saida[]
        it_fieldcatalog               = gt_fieldcat[]
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    IF sy-subrc <> gc_zero.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.
