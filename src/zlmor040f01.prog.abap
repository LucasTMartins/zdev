*&---------------------------------------------------------------------*
*& Include          ZLMOR040F01
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
  FREE gt_lmot007.
  SELECT mandt cod_pro nome cod_grp dt_cadastro preco_venda moeda estoque_disp
    FROM zlmot007
    INTO CORRESPONDING FIELDS OF TABLE gt_lmot007
    WHERE cod_pro     IN s_codpro  "Código do produto
    AND   dt_cadastro IN s_dtcad.  "Data do cadastro

  "verificando se a tabela está vazia
  IF gt_lmot007[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003 space space space.   "Nenhum registro encontrado
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_prepare_data
*&---------------------------------------------------------------------*
FORM f_prepare_data.
  LOOP AT gt_lmot007 INTO gs_lmot007.

    "passando dados para a tabela de ss
    gs_saida-cod_pro      = gs_lmot007-cod_pro.
    gs_saida-nome         = gs_lmot007-nome.
    gs_saida-cod_grp      = gs_lmot007-cod_grp.
    gs_saida-dt_cadastro  = gs_lmot007-dt_cadastro.
    gs_saida-preco_venda  = gs_lmot007-preco_venda.
    gs_saida-estoque_disp = gs_lmot007-estoque_disp.

    "repassando dados para tabela de saida
    APPEND gs_saida TO gt_saida.
    CLEAR gs_saida.
  ENDLOOP.

  gt_saidabkp[] = gt_saida[].

  SORT: gt_saida    BY cod_pro,
        gt_saidabkp BY cod_pro.
ENDFORM.
*&--------------------------------------------------------------------
*& FORM f_build_fields_print
*&--------------------------------------------------------------------
FORM f_build_fields.
  "montando fieldcat e chamando tela principal
  PERFORM f_add_field USING gc_cod_pro      'ZLMOT007' TEXT-005 'C610'. "Código do produto
  PERFORM f_add_field USING gc_nome         'ZLMOT007' TEXT-006 space . "Nome do produto
  PERFORM f_add_field USING gc_cod_grp      'ZLMOT007' TEXT-007 space . "Código do grupo
  PERFORM f_add_field USING gc_dt_cadastro  'ZLMOT007' TEXT-008 space . "Data
  PERFORM f_add_field USING gc_preco_venda  'ZLMOT007' TEXT-009 'C510'. "Preço de venda
  PERFORM f_add_field USING gc_estoque_disp 'ZLMOT007' TEXT-010 space . "Quantidade
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_add_field
*&--------------------------------------------------------------------
FORM f_add_field USING p_fieldname TYPE char12
                       p_tabname   TYPE string
                       p_scrtext_l TYPE string
                       p_emphasize TYPE string.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-tabname   = p_tabname.
  gs_fieldcat-scrtext_l = p_scrtext_l.
  gs_fieldcat-emphasize = p_emphasize.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_create_container
*&---------------------------------------------------------------------*
FORM f_create_container.
  IF go_container IS INITIAL.
    "criando container
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
    SET HANDLER event_receiver->handle_user_command FOR go_grid.
    SET HANDLER event_receiver->handle_toolbar      FOR go_grid.

    gs_layout-stylefname = gc_celltab.
    gs_layout-ctab_fname = gc_cellcolor.
    gs_variant-report    = sy-repid.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.

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

*&---------------------------------------------------------------------*
*&      Form  f_create_container
*&---------------------------------------------------------------------*
FORM f_colorize_cells.
  "campos de estoque ficam em amarelo ao terem menos de 10 peças no estoque
  LOOP AT gt_saida INTO gs_saida.
    gv_index = sy-tabix.
    IF gs_saida-estoque_disp < 10.
      gs_cellcolor-fname = gc_estoque_disp.
      gs_cellcolor-color-col = 3.
      gs_cellcolor-color-int = 1.
      gs_cellcolor-color-inv = 0.
      APPEND gs_cellcolor TO gs_saida-cellcolor.
      CLEAR: gs_cellcolor.
      MODIFY gt_saida FROM gs_saida INDEX gv_index TRANSPORTING cellcolor.
    ENDIF.
  ENDLOOP.
ENDFORM.
