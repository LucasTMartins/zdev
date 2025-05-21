*&---------------------------------------------------------------------*
*& Include          ZLMOR038F01
*&---------------------------------------------------------------------*
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
  SELECT lgnum tanum bwlvs bdatu
    FROM ltak
    INTO TABLE gt_ltak
    WHERE lgnum IN s_lgnum   "Nºdepósito
    AND   bdatu IN s_bdatu.  "Data da ordem de transferência

  "verificando se a tabela está vazia
  IF gt_ltak[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003 space space space.   "Nenhum registro encontrado
    leave to screen 0.
  ENDIF.

  "Passando dados de Item de ordem de transporte
  FREE gt_ltap.
  SELECT lgnum tanum tapos posnr matnr werks
    FROM ltap
    INTO TABLE gt_ltap
    FOR ALL ENTRIES IN gt_ltak
    WHERE lgnum EQ gt_ltak-lgnum   "Nº depósito
    AND   tanum EQ gt_ltak-tanum.  "Nº ordem de transporte

  "verificando se a tabela está vazia
  IF gt_ltap[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003 space space space.   "Nenhum registro encontrado
    leave to screen 0.
  ENDIF.

  "Passando dados de material
  FREE gt_mara.
  SELECT matnr, mtart, matkl
    FROM mara
    INTO TABLE @gt_mara
    FOR ALL ENTRIES IN @gt_ltap
    WHERE matnr EQ @gt_ltap-matnr.   "Nº do material

  "verificando se a tabela está vazia
  IF gt_mara[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003 space space space.   "Nenhum registro encontrado
    leave to screen 0.
  ENDIF.

  "Passando dados de Textos breves de material
  FREE gt_makt.
  SELECT matnr, maktx
    FROM makt
    INTO TABLE @gt_makt
    FOR ALL ENTRIES IN @gt_mara
    WHERE matnr EQ @gt_mara-matnr   "Nº do material
    AND   spras EQ @sy-langu.       "Idioma

  "Passando dados de Centros/filiais
  FREE gt_t001w.
  SELECT werks, name1, bwkey
    FROM t001w
    INTO TABLE @gt_t001w
    FOR ALL ENTRIES IN @gt_ltap
    WHERE werks EQ @gt_ltap-werks.   "Centro

  SORT: gt_ltak  BY tanum lgnum, "ordenando tabelas
        gt_ltap  BY tanum lgnum,
        gt_mara  BY matnr,
        gt_makt  BY matnr,
        gt_t001w BY werks.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_prepare_data
*&---------------------------------------------------------------------*
FORM f_prepare_data.
  LOOP AT gt_ltap INTO gs_ltap.
    "lendo Cabeçalho de ordem de transporte SAD para tabela de saida
    READ TABLE gt_ltak
      INTO gs_ltak
      WITH KEY tanum = gs_ltap-tanum BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-icon_alv = icon_biw_info_source.
      gs_saida-lgnum    = gs_ltak-lgnum.
      gs_saida-tanum    = gs_ltak-tanum.
      gs_saida-bwlvs    = gs_ltak-bwlvs.
      gs_saida-bdatu    = gs_ltak-bdatu.
      gs_saida-tapos    = gs_ltap-tapos.
      gs_saida-posnr    = gs_ltap-posnr.
      gs_saida-matnr    = gs_ltap-matnr.
    ENDIF.

    "lendo dados de material para tabela de saida
    READ TABLE gt_mara
      INTO gs_mara
      WITH KEY matnr = gs_ltap-matnr BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-mtart = gs_mara-mtart.
      gs_saida-matkl = gs_mara-matkl.
    ENDIF.

    "lendo Textos breves de material para tabela de saida
    READ TABLE gt_makt
      INTO gs_makt
      WITH KEY matnr = gs_ltap-matnr BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-maktx = gs_makt-maktx.
    ENDIF.

    "lendo Centros/filiais para tabela de saida
    READ TABLE gt_t001w
      INTO gs_t001w
      WITH KEY werks = gs_ltap-werks BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-werks = gs_t001w-werks.
      gs_saida-name1 = gs_t001w-name1.
      gs_saida-bwkey = gs_t001w-bwkey.
    ENDIF.

    "repassando dados para tabela de saida
    APPEND gs_saida TO gt_saida.
    CLEAR gs_saida.
  ENDLOOP.

  SORT: gt_saida BY lgnum tanum tapos.
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_build_fields_print
*&--------------------------------------------------------------------
FORM f_build_fields.
  "montando fieldcat e chamando tela principal
  PERFORM f_add_field USING gc_icon_alv 'LTAK'  TEXT-005 space.  "Icon
  PERFORM f_add_field USING gc_lgnum    'LTAK'  TEXT-006 space.  "Nº depósito
  PERFORM f_add_field USING gc_tanum    'LTAK'  TEXT-007 space.  "Nº OT
  PERFORM f_add_field USING gc_bwlvs    'LTAK'  TEXT-008 space.  "Tipo movimento
  PERFORM f_add_field USING gc_bdatu    'LTAK'  TEXT-009 space.  "Data criação
  PERFORM f_add_field USING gc_tapos    'LTAP'  TEXT-010 space.  "Item OT
  PERFORM f_add_field USING gc_posnr    'LTAP'  TEXT-011 space.  "Item
  PERFORM f_add_field USING gc_matnr    'LTAP'  TEXT-012 'C510'. "Material
  PERFORM f_add_field USING gc_mtart    'MARA'  TEXT-013 space.  "Tipo material
  PERFORM f_add_field USING gc_matkl    'MARA'  TEXT-014 space.  "GrpMercads.
  PERFORM f_add_field USING gc_maktx    'MAKT'  TEXT-015 space.  "Denominação
  PERFORM f_add_field USING gc_werks    'T001W' TEXT-016 space.  "Centro
  PERFORM f_add_field USING gc_name1    'T001W' TEXT-017 space.  "Nome 1
  PERFORM f_add_field USING gc_bwkey    'T001W' TEXT-018 space.  "Área avaliação
ENDFORM.

*&--------------------------------------------------------------------
*& FORM ADD FIELD
*&--------------------------------------------------------------------
FORM f_add_field USING pv_fieldname TYPE char10
                       pv_tabname   TYPE string
                       pv_scrtext_l TYPE string
                       pv_emphasize TYPE string.

  " Criando fieldcat
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = pv_fieldname. "nome do campo
  gs_fieldcat-tabname   = pv_tabname.   "nome da tabela
  gs_fieldcat-scrtext_l = pv_scrtext_l.   "nome da coluna
  gs_fieldcat-emphasize = pv_emphasize. "cor da coluna
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_create_container
*&---------------------------------------------------------------------*
FORM f_create_container.
  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name              = 'CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "Cria objeto de controle alv
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_container.

    "Recebe os eventos acontecidos no grid
    CREATE OBJECT event_receiver.
    SET HANDLER event_receiver->catch_hotspot       FOR go_grid.
    SET HANDLER event_receiver->handle_user_command FOR go_grid.
    SET HANDLER event_receiver->handle_toolbar      FOR go_grid.

    gs_variant-report    = sy-repid.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-sel_mode   = gc_selmode.

    "Imprime o ALV
    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = gc_isave
        is_layout       = gs_layout
      CHANGING
        it_fieldcatalog = gt_fieldcat
        it_outtab       = gt_saida[].

    CALL METHOD go_grid->set_toolbar_interactive.
  ENDIF.
ENDFORM.
