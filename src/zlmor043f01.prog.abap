*&---------------------------------------------------------------------*
*& Include          ZLMOR043F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-001. "Selecionando dados. Aguarde...

  "Passando dados para alv tree
  FREE gt_tree.
  SELECT ebeln
    FROM ekko
    INTO TABLE gt_tree
    WHERE ebeln IN s_ebeln.   "documento de compra

  "verificando se a tabela está vazia
  IF gt_tree[] IS INITIAL.
    MESSAGE i398 WITH TEXT-002 space space space.   "Nenhum registro encontrado
    STOP.
  ENDIF.

  "Passando dados para alv grid
  FREE gt_grid.
  SELECT ebeln ebelp uniqueid aedat matnr
    FROM ekpo
    INTO TABLE gt_grid
    WHERE ebeln IN s_ebeln.   "documento de compra

  "verificando se a tabela está vazia
  IF gt_grid[] IS INITIAL.
    MESSAGE i398 WITH TEXT-002 space space space.   "Nenhum registro encontrado
    STOP.
  ENDIF.

  SORT: gt_tree  BY ebeln, "ordenando tabelas
        gt_grid  BY ebeln ebelp.
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_add_campo
*&--------------------------------------------------------------------
FORM f_add_campo USING p_fieldname
                       p_tabname
                       p_seltext_l
                 CHANGING p_fieldcat TYPE STANDARD TABLE.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-tabname   = p_tabname.
  gs_fieldcat-scrtext_l = p_seltext_l.

  APPEND gs_fieldcat TO p_fieldcat.
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_fieldcat_init
*&--------------------------------------------------------------------
FORM f_fieldcat_init.
  PERFORM f_add_campo USING gc_fieldcat_build-ebeln    gc_fieldcat_build-ekpo TEXT-003 CHANGING gt_fieldcat_grid. "Documento de compra
  PERFORM f_add_campo USING gc_fieldcat_build-ebelp    gc_fieldcat_build-ekpo TEXT-004 CHANGING gt_fieldcat_grid. "Item
  PERFORM f_add_campo USING gc_fieldcat_build-uniqueid gc_fieldcat_build-ekpo TEXT-005 CHANGING gt_fieldcat_grid. "Item do documento
  PERFORM f_add_campo USING gc_fieldcat_build-aedat    gc_fieldcat_build-ekpo TEXT-006 CHANGING gt_fieldcat_grid. "Data da modificação
  PERFORM f_add_campo USING gc_fieldcat_build-matnr    gc_fieldcat_build-ekpo TEXT-007 CHANGING gt_fieldcat_grid. "Material
ENDFORM.

*&--------------------------------------------------------------------
*& FORM f_display_docking
*&--------------------------------------------------------------------
FORM f_display_docking.
  IF go_container_tree IS INITIAL.    ""Container do alv tree
    CREATE OBJECT go_container_tree
      EXPORTING
        repid                       = sy-repid
        dynnr                       = sy-dynnr
        side                        = go_container_tree->dock_at_left
        extension                   = 600
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_dynpro_dynpro_link = 4
        lifetime_error              = 5
        OTHERS                      = 6.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv_tree       ""ALV tree
      EXPORTING
        parent                      = go_container_tree
        node_selection_mode         = cl_gui_simple_tree=>node_sel_mode_single ""classe para ALV simple
      EXCEPTIONS
        cntl_system_error           = 1
        create_error                = 2
        failed                      = 3
        illegal_node_selection_mode = 4
        lifetime_error              = 5
        OTHERS                      = 6.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_container_grid ""Container do alv grid
      EXPORTING
        repid                       = sy-repid
        dynnr                       = sy-dynnr
        side                        = go_container_grid->dock_at_bottom
        extension                   = 170
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_dynpro_dynpro_link = 4
        lifetime_error              = 5
        OTHERS                      = 6.

    IF sy-subrc <> 0.
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

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_application.

* Events tree control
    SET HANDLER go_application->handle_tree_drag FOR go_alv_tree.
    SET HANDLER go_application->handle_tree_drop_complete FOR go_alv_tree.

* Events grid control
    SET HANDLER go_application->handle_grid_drop FOR go_alv_grid.
    SET HANDLER go_application->handle_node_double_click FOR go_alv_grid.

    PERFORM f_build_node USING gt_node_table. "Construindo tabelas de nós

    CALL METHOD go_alv_tree->add_nodes     "Criando nós da tabela
      EXPORTING
        table_structure_name           = gc_mtreesnode
        node_table                     = gt_node_table
      EXCEPTIONS
        failed                         = 1
        error_in_node_table            = 2
        dp_error                       = 3
        table_structure_name_not_found = 4
        OTHERS                         = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_alv_tree->expand_node ""Inicia com o nó raíz já expandido
      EXPORTING
        node_key            = gc_nodekey_root
      EXCEPTIONS
        failed              = 1
        illegal_level_count = 2
        cntl_system_error   = 3
        node_not_found      = 4
        cannot_expand_leaf  = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "Layout do ALV Grid
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-grid_title = text-004.

    CALL METHOD go_alv_grid->set_table_for_first_display ""Monta tela do Alv grid
      EXPORTING
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_grid[]
        it_fieldcatalog               = gt_fieldcat_grid[]
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_build_node
*&---------------------------------------------------------------------*
FORM f_build_node USING lt_node_table TYPE gty_node_table.
  DATA: lv_node        TYPE mtreesnode,
        lv_effect      TYPE i,
        lv_handle_tree TYPE i,
        lv_handle_grid TYPE i.

  CREATE OBJECT go_behaviour_tree.
  lv_effect = cl_dragdrop=>move + cl_dragdrop=>copy.
  CALL METHOD go_behaviour_tree->add
    EXPORTING
      flavor     = text-008
      dragsrc    = abap_true
      droptarget = space
      effect     = lv_effect.
  CALL METHOD go_behaviour_tree->get_handle
    IMPORTING
      handle = lv_handle_tree.

* define a drag & Drop behaviour for the whole grid
  CREATE OBJECT go_behaviour_grid.
  lv_effect = cl_dragdrop=>move + cl_dragdrop=>copy.
  CALL METHOD go_behaviour_grid->add
    EXPORTING
      flavor     = text-008
      dragsrc    = space
      droptarget = abap_true
      effect     = lv_effect.
  CALL METHOD go_behaviour_grid->get_handle
    IMPORTING
      handle = lv_handle_grid.

  "Nó raiz "Documento de compra"
  CLEAR lv_node.
  lv_node-node_key = gc_nodekey_root. "Documento de compra
  lv_node-isfolder = abap_true.       "É uma pasta.
  lv_node-text     = TEXT-003.        "Documento de compra
  APPEND lv_node TO lt_node_table.

  CLEAR gs_tree.
  LOOP AT gt_tree INTO gs_tree. "trazendo dados de documento de compra
    PERFORM f_add_node USING gs_tree-ebeln gs_tree-ebeln lv_handle_tree CHANGING lt_node_table. "criando nós dos documentos de compra
  ENDLOOP.

  gs_layout-s_dragdrop-row_ddid = lv_handle_grid.
ENDFORM.                    " f_build_node

*&---------------------------------------------------------------------*
*& FORM f_add_node
*&---------------------------------------------------------------------*
FORM f_add_node USING p_nodekey
                      p_text
                      p_handle_grid TYPE i
                CHANGING p_nodetable TYPE STANDARD TABLE.
  DATA: lv_node        TYPE mtreesnode.

  CLEAR lv_node.
  lv_node-node_key   = p_nodekey.
  lv_node-text       = p_text.
  lv_node-isfolder   = space.       "Não é uma pasta.
  lv_node-relatkey   = gc_nodekey_root.
  lv_node-relatship  = cl_gui_simple_tree=>relat_last_child.
  lv_node-dragdropid = p_handle_grid.
  APPEND lv_node TO p_nodetable.
ENDFORM. "f_add_node
