*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 21.09.2023                                           *
*& Description  : Criando ALV tree                                     *
*&---------------------------------------------------------------------*
"" INCLUDES
INCLUDE zlmor025top.
INCLUDE zlmor025o01.
INCLUDE zlmor025i01.
INCLUDE zlmor025_treecla.

"" SELECTION-SCREEN
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS:
    s_vbeln FOR lips-vbeln.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM: f_select_data.
  PERFORM: f_prepare_data.
  PERFORM: f_print.

  "" FORM F_SELECT_DATA
FORM f_select_data.

  "selecionando dados de documentos SD: dados de item
  SELECT vbeln posnr matnr lfimg
    FROM lips
    INTO TABLE gt_lips
    WHERE vbeln IN s_vbeln.

  IF sy-subrc <> 0.
    MESSAGE s398 WITH TEXT-001 DISPLAY LIKE 'E'. "Nenhum registro encontrado
    STOP.
  ENDIF.

  SORT: gt_lips BY vbeln.
ENDFORM.

"" FORM F_PREPARE_DATA
FORM f_prepare_data.
  "repassando dados para relatório
  LOOP AT gt_lips INTO gs_lips.
    gs_relatorio-vbeln = gs_lips-vbeln.
    gs_relatorio-posnr = gs_lips-posnr.
    gs_relatorio-matnr = gs_lips-matnr.
    gs_relatorio-lfimg = gs_lips-lfimg.
    SHIFT gs_relatorio-matnr LEFT DELETING LEADING '0'. "retira os zeros a esquerda do material
    APPEND gs_relatorio TO gt_relatorio.
    APPEND gs_relatorio TO gt_relatorio_itens.
    CLEAR: gs_relatorio.
  ENDLOOP.
ENDFORM.

"" FORM F_PRINT
FORM f_print.
  CALL SCREEN '0100'. "tela principal
ENDFORM.

"" FORM F_CREATE_ALVTREE_CONTAINER
FORM f_create_alvtree_container.
  "criando objeto container
  CREATE OBJECT go_custom_container
    EXPORTING
      container_name              = 'MAIN_CONTAINER'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

  PERFORM f_exclude_tb_functions CHANGING gtt_exclude.
ENDFORM.

"" FORM F_EXCLUDE_TB_FUNCTIONS
FORM f_exclude_tb_functions CHANGING pt_exclude TYPE ui_functions.
  DATA ls_exclude TYPE ui_func.

  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO pt_exclude.
ENDFORM.

"" FORM F_CREATE_OBJECT_IN_CONTAINER
FORM f_create_object_in_container.
  CREATE OBJECT go_alv_tree
    EXPORTING
      parent                      = go_custom_container
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = abap_true
      no_html_header              = space
      no_toolbar                  = abap_true
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
ENDFORM.

""  FORM F_CREATE_EMPTY_ALVTREE_CONTROL
FORM f_create_empty_alvtree_control.
  DATA lv_hierarchy_header TYPE treev_hhdr.
  PERFORM f_build_hierarchy_header CHANGING lv_hierarchy_header.

  PERFORM f_build_fieldcatalog.

  "Monta cabeçalho
  PERFORM f_cria_top_of_page.

  CALL METHOD go_alv_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = lv_hierarchy_header
      it_list_commentary  = gt_list_commentary
    CHANGING
      it_fieldcatalog     = gt_fieldcat
      it_outtab           = gt_relatorio_itens.

  PERFORM f_register_events.
ENDFORM.

""  FORM F_BUILD_HIERARCHY_HEADER
FORM f_build_hierarchy_header CHANGING p_hierarchy_header TYPE treev_hhdr.
  p_hierarchy_header-heading = c_fornecimento. "Fornecimento
  p_hierarchy_header-tooltip = c_fornmat. "Fornecimento / Material
ENDFORM.

"" FORM F_ADD_CAMPO
FORM f_add_campo USING p_col_pos
                       p_reptext
                       p_scrtext_s
                       p_fieldname
                       p_outputlen
                       p_ref_field
                       p_ref_table
                       p_datatype
                       p_do_sum.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = p_col_pos.
  gs_fieldcat-reptext   = p_reptext.
  gs_fieldcat-scrtext_s = p_scrtext_s.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-outputlen = p_outputlen.
  gs_fieldcat-ref_field = p_ref_field.
  gs_fieldcat-ref_table = p_ref_table.
  gs_fieldcat-datatype  = p_datatype.
  gs_fieldcat-do_sum    = p_do_sum.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

"" FORM F_FIELDCAT_INIT
FORM f_build_fieldcatalog.
  FREE:  gt_fieldcat.
  CLEAR: gs_fieldcat.

  PERFORM f_add_campo USING 1
                            TEXT-002 "Item
                            TEXT-002 "Item
                            'POSNR'
                            100
                            'POSNR'
                            'LIPS'
                            space
                            abap_false.
  PERFORM f_add_campo USING 2
                            TEXT-003 "Quantidade
                            TEXT-003 "Quantidade
                            'LFIMG'
                            100
                            'LFIMG'
                            'LIPS'
                            'CURR'
                            abap_true.
ENDFORM.

"" FORM F_CREATE_ALVTREE_HIERARCHY
FORM f_create_alvtree_hierarchy.
  PERFORM f_load_itens_into_tree.

  CALL METHOD go_alv_tree->column_optimize
    EXCEPTIONS
      start_column_not_found = 1
      end_column_not_found   = 2
      OTHERS                 = 3.

  CALL METHOD go_alv_tree->update_calculations.

  CALL METHOD go_alv_tree->frontend_update.

ENDFORM.

"" FORM F_LOAD_ITENS_INTO_TREE
FORM f_load_itens_into_tree.

  DATA:
    lv_item       TYPE lips-matnr,
    lv_cabeca_key TYPE lvc_nkey,
    lv_item_key   TYPE lvc_nkey.

  LOOP AT gt_relatorio INTO gs_relatorio.

    gs_relacao-tabix = sy-tabix.

    ADD 1 TO gs_relacao-linha.

    IF gs_relatorio-vbeln <> lv_item.
      lv_item = gs_relatorio-vbeln.
      PERFORM f_builder_header CHANGING lv_cabeca_key.
      APPEND gs_relacao TO gt_relacao.
      ADD 1 TO gs_relacao-linha.
    ENDIF.

    PERFORM f_add_item_line USING lv_cabeca_key
                            CHANGING lv_item_key.
    APPEND gs_relacao TO gt_relacao.
  ENDLOOP.
ENDFORM.

"" FORM F_BUILDER_HEADER
FORM f_builder_header CHANGING p_node_key TYPE lvc_nkey.
  DATA:
    lv_node_text   TYPE lvc_value,
    lt_item_layout TYPE lvc_t_layi,
    ls_item_layout TYPE lvc_s_layi,
    is_node_layout TYPE lvc_s_layn
    .

  ls_item_layout-fieldname = go_alv_tree->c_hierarchy_column_name.
  ls_item_layout-style     = cl_gui_column_tree=>style_default.
  ls_item_layout-class     = cl_gui_column_tree=>item_class_link.
  lv_node_text             = gs_relatorio-vbeln.
  APPEND ls_item_layout TO lt_item_layout.
  CLEAR ls_item_layout.

  is_node_layout-n_image   = icon_closed_folder.
  is_node_layout-exp_image = icon_open_folder.

  CALL METHOD go_alv_tree->add_node
    EXPORTING
      i_relat_node_key = c_raiz
      i_relationship   = cl_gui_column_tree=>relat_first_child
      is_node_layout   = is_node_layout
      it_item_layout   = lt_item_layout
      i_node_text      = lv_node_text
    IMPORTING
      e_new_node_key   = p_node_key.
ENDFORM.

"" FORM F_ADD_ITEM_LINE
FORM f_add_item_line USING p_relate_key TYPE lvc_nkey
                     CHANGING p_node_key TYPE lvc_nkey.
  DATA:
    lv_node_text   TYPE lvc_value,
    lt_item_layout TYPE lvc_t_layi,
    ls_item_layout TYPE lvc_s_layi,
    is_node_layout TYPE lvc_s_layn.

  ls_item_layout-fieldname = go_alv_tree->c_hierarchy_column_name.
  ls_item_layout-style     = cl_gui_column_tree=>style_default.
  lv_node_text             = gs_relatorio-matnr.
  APPEND ls_item_layout TO lt_item_layout.
  CLEAR ls_item_layout.

  is_node_layout-n_image = icon_material.
  is_node_layout-exp_image = icon_material.

  CALL METHOD go_alv_tree->add_node
    EXPORTING
      i_relat_node_key = p_relate_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      is_node_layout   = is_node_layout
      it_item_layout   = lt_item_layout
      i_node_text      = lv_node_text
      is_outtab_line   = gs_relatorio
    IMPORTING
      e_new_node_key   = p_node_key.
ENDFORM.

"" FORM F_CRIA_TOP_OF_PAGE
FORM f_cria_top_of_page.
  DATA: lv_datum(10) TYPE c.

  FREE: gt_list_commentary.
  CLEAR: gs_list_commentary.

  gs_list_commentary-typ  = c_comtyp_h.       "H
  gs_list_commentary-info = c_cabecalho_tree. "Cabeçalho Tree
  APPEND gs_list_commentary TO gt_list_commentary.
  CLEAR gs_list_commentary.

  gs_list_commentary-typ  = c_comtyp_s.      "S
  gs_list_commentary-key  = c_autor.         "Autor:
  gs_list_commentary-info = c_lucas_martins. "Lucas Martins de Oliveira
  APPEND gs_list_commentary TO gt_list_commentary.
  CLEAR gs_list_commentary.

  gs_list_commentary-typ  = c_comtyp_s. "S
  gs_list_commentary-key  = c_data.     "Data:
  gs_list_commentary-info = sy-datum.
  APPEND gs_list_commentary TO gt_list_commentary.
  CLEAR gs_list_commentary.
ENDFORM.

"" FORM F_REGISTER_EVENTS
FORM f_register_events.
  DATA: lt_events TYPE cntl_simple_events,
        ls_event  TYPE cntl_simple_event.

  CALL METHOD go_alv_tree->get_registered_events
    IMPORTING
      events = lt_events.

  ls_event-eventid = cl_gui_column_tree=>eventid_link_click.
  APPEND ls_event TO lt_events.
  ls_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  APPEND ls_event TO lt_events.
  ls_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  APPEND ls_event TO lt_events.

  CALL METHOD go_alv_tree->set_registered_events
    EXPORTING
      events = lt_events.

  SET HANDLER lcl_event_handler=>handle_item_double_click FOR go_alv_tree.
  SET HANDLER lcl_event_handler=>handle_node_double_click FOR go_alv_tree.
  SET HANDLER lcl_event_handler=>handle_link_click        FOR go_alv_tree.
ENDFORM.
