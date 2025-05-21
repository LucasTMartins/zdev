*&---------------------------------------------------------------------*
*& Include          ZLMOR024F01
*&---------------------------------------------------------------------*
"" FORM F_SELECT_DATA
FORM f_select_data.

  "selecionando dados de documentos SD: dados de item
  SELECT vbeln posnr matnr lfimg
    FROM lips
    INTO TABLE gt_lips
    WHERE vbeln IN s_vbeln.

  IF sy-subrc <> 0.
    MESSAGE i398 WITH TEXT-001 space space space DISPLAY LIKE gc_display_e. "Nenhum registro encontrado
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
      no_html_header              = abap_true
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

  CALL METHOD go_alv_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = lv_hierarchy_header
    CHANGING
      it_fieldcatalog     = gt_fieldcat
      it_outtab           = gt_relatorio_itens.

ENDFORM.

""  FORM F_BUILD_HIERARCHY_HEADER
FORM f_build_hierarchy_header CHANGING p_hierarchy_header TYPE treev_hhdr.
  p_hierarchy_header-heading = gc_fornmat. "Fornecimento / Material
  p_hierarchy_header-tooltip = gc_fornmat. "Fornecimento / Material
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
  DATA: lv_item       TYPE lips-matnr,
        lv_cabeca_key TYPE lvc_nkey,
        lv_item_key   TYPE lvc_nkey.

  CLEAR gs_relatorio.
*  SORT gt_relatorio BY vbeln DESCENDING. "ordenando ao contrário para a adição de nodes
  LOOP AT gt_relatorio INTO gs_relatorio.
    IF gs_relatorio-vbeln <> lv_item.
      lv_item = gs_relatorio-vbeln.
      PERFORM f_builder_header CHANGING lv_cabeca_key.
    ENDIF.

    PERFORM f_add_item_line USING lv_cabeca_key
                            CHANGING lv_item_key.
  ENDLOOP.
*  SORT gt_relatorio BY vbeln ASCENDING. "voltando ordenação crescente
ENDFORM.

"" FORM F_BUILDER_HEADER
FORM f_builder_header CHANGING p_node_key TYPE lvc_nkey.
  DATA:lv_node_text   TYPE lvc_value,
       lt_item_layout TYPE lvc_t_layi,
       ls_item_layout TYPE lvc_s_layi,
       is_node_layout TYPE lvc_s_layn.

  CLEAR ls_item_layout.
  ls_item_layout-fieldname = go_alv_tree->c_hierarchy_column_name.
  ls_item_layout-style     = cl_gui_column_tree=>style_default.
  lv_node_text             = gs_relatorio-vbeln.
  APPEND ls_item_layout TO lt_item_layout.

  CLEAR gs_tree.
  gs_tree-fornmat = gs_relatorio-vbeln.
  APPEND gs_tree TO gt_tree.

  is_node_layout-n_image   = icon_closed_folder.
  is_node_layout-exp_image = icon_open_folder.

  CALL METHOD go_alv_tree->add_node
    EXPORTING
      i_relat_node_key = gc_raiz
      i_relationship   = cl_gui_column_tree=>relat_first_child
      is_node_layout   = is_node_layout
      it_item_layout   = lt_item_layout
      i_node_text      = lv_node_text
    IMPORTING
      e_new_node_key   = p_node_key.
ENDFORM.

"" FORM F_ADD_ITEM_LINE
FORM f_add_item_line USING  p_relate_key TYPE lvc_nkey
                     CHANGING p_node_key TYPE lvc_nkey.
  DATA: lv_node_text   TYPE lvc_value,
        lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi,
        is_node_layout TYPE lvc_s_layn.

  CLEAR ls_item_layout.
  ls_item_layout-fieldname = go_alv_tree->c_hierarchy_column_name.
  ls_item_layout-style     = cl_gui_column_tree=>style_default.
  lv_node_text             = gs_relatorio-matnr.
  APPEND ls_item_layout TO lt_item_layout.

  CLEAR gs_tree.
  gs_tree-fornmat    = gs_relatorio-matnr.
  gs_tree-item       = gs_relatorio-posnr.
  gs_tree-quantidade = gs_relatorio-lfimg.
  APPEND gs_tree TO gt_tree.

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

FORM f_imprimir_ole.
  DATA: lv_selected_folder TYPE string,
        lv_complete_path   TYPE char256,
        lv_table_size(6)   TYPE n,
        lv_row_number      TYPE i VALUE 1.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = gc_window_title
      initial_folder  = gc_initial_folder_path
    CHANGING
      selected_folder = lv_selected_folder
    EXCEPTIONS
      cntl_error      = 1
      error_no_gui    = 2
      OTHERS          = 3.
  CHECK NOT lv_selected_folder IS INITIAL.

* Cria o documento Excel
  PERFORM f_cria_documento.

* Cabeçalho da planilha
  CLEAR gt_lines_ole[].
  gs_lines_ole-value = gc_fornmat.    APPEND gs_lines_ole TO gt_lines_ole.
  gs_lines_ole-value = gc_item.       APPEND gs_lines_ole TO gt_lines_ole.
  gs_lines_ole-value = gc_quantidade. APPEND gs_lines_ole TO gt_lines_ole.

* Adicione o cabeçalho ALV aos dados a serem impressos
  IF gt_data_ole IS INITIAL.
    PERFORM add_line2print_from_table.

* Imprime o resto dos dados do ALV
    CLEAR gs_tree.
    LOOP AT gt_tree INTO gs_tree.
      PERFORM add_line2print USING gs_tree 0.

      lv_row_number += 1.

      IF gs_tree-item IS INITIAL. "verificando se a linha é de um fornecimento ou de um material
        ""linha de fornecimento na cor amarela
        PERFORM set_soft_colour USING lv_row_number                 "Linha inical
                                      gc_colini                     "Coluna inicial
                                      lv_row_number                 "Linha final
                                      gc_colend                     "Coluna final
                                      gc_theme_col-black abap_true  "Cor da fonte
                                      0 space                       "Fonte sombreamento
                                      gc_theme_col-yellow abap_true "Cor de fundo
                                      '0.49' abap_true.             "Cor de fundo sombreamento
      ELSE.
        ""linha de material na cor azul
        PERFORM set_soft_colour USING lv_row_number                     "Linha inical
                                      gc_colini                         "Coluna inicial
                                      lv_row_number                     "Linha final
                                      gc_colend                         "Coluna final
                                      gc_theme_col-black abap_true      "Cor da fonte
                                      0 space                           "Fonte sombreamento
                                      gc_theme_col-pal_blue abap_true   "Cor de fundo
                                      '0.49' abap_true.                 "Cor de fundo sombreamento
      ENDIF.
    ENDLOOP.
  ENDIF.

* Copia e cola os dados da célula A1 (sem isso os dados não aparecem na tabela)
  PERFORM paste_clipboard USING 1 1.

* Altera a cor do cabeçalho do ALV
  "Range células
  PERFORM set_soft_colour USING 1                            "Linha inical
                                gc_colini                    "Coluna inicial
                                1                            "Linha final
                                gc_colend                    "Coluna final
                                gc_theme_col-black abap_true "Cor da fonte
                                0 space                      "Fonte sombreamento
                                gc_theme_col-red abap_true   "Cor de fundo
                                '0.49' abap_true.            "Cor de fundo sombreamento

  lv_table_size = lines( gt_tree ) + 1. "pegando número de linhas da tabela para criação de bordas
  PERFORM add_border USING 1 1 lv_table_size 3. "Adiciona bordas
  "Range células
  " 1 = Linha inical
  " 1 = Coluna Inicial
  " lv_table_size = Linha Final
  " 3 = Coluna Final

* Ajusta a largura das células ao conteúdo
  DATA: lo_columns TYPE ole2_object.
  CALL METHOD OF go_application 'Columns' = lo_columns.
  CALL METHOD OF lo_columns 'Autofit'.

* Bloqueia as células para a edição e trava na célula 1 ao abrir
  PERFORM lock_cells USING 1 1 1 1.

* Nome do arquivo
  CONCATENATE lv_selected_folder gc_barra gc_nome_arquivo sy-uzeit INTO lv_complete_path.

* Salva documento
  CALL METHOD OF go_workbook 'SaveAs'
    EXPORTING
      #1 = lv_complete_path.

  IF sy-subrc EQ 0.
    MESSAGE i398 WITH TEXT-004 space space space DISPLAY LIKE gc_display_s. "Arquivo baixado com sucesso
  ELSE.
    MESSAGE i398 WITH TEXT-005 space space space DISPLAY LIKE gc_display_e. "Erro ao baixar o arquivo
  ENDIF.

* Fecha o documento e libere memória
  PERFORM close_document.
ENDFORM.

FORM f_cria_documento.
  CREATE OBJECT go_application 'Excel.Application'.
  CALL METHOD OF go_application 'Workbooks' = go_workbooks.
  CALL METHOD OF go_workbooks 'Add' = go_workbook.
  SET PROPERTY OF go_application 'Visible'     = 0.
  GET PROPERTY OF go_application 'ACTIVESHEET' = go_worksheet.
ENDFORM.

FORM add_line2print_from_table.
  CLEAR gs_data_ole.
  LOOP AT gt_lines_ole INTO gs_lines_ole.
    CONCATENATE gs_data_ole gs_lines_ole-value INTO gs_data_ole
    SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
  ENDLOOP.

  ""Retirando primeiro horizontal_tab:
  SHIFT gs_data_ole BY 1 PLACES LEFT.

  APPEND gs_data_ole TO gt_data_ole. CLEAR gs_data_ole.
ENDFORM.

FORM add_line2print USING p_data       TYPE any
                          p_num_cols   TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.
  DATA: lv_cont TYPE i,
        lv_char TYPE char128.

  DATA: lo_abap_typedescr TYPE REF TO cl_abap_typedescr.

  CLEAR gs_data_ole.
  DO.
    ADD 1 TO lv_cont.
    ASSIGN COMPONENT lv_cont OF STRUCTURE p_data TO <field>.
    IF sy-subrc NE 0. EXIT. ENDIF.

*   Os dados de conversão dependem do tipo de espécie.
    CALL METHOD cl_abap_typedescr=>describe_by_data
      EXPORTING
        p_data      = <field>
      RECEIVING
        p_descr_ref = lo_abap_typedescr.

    CASE lo_abap_typedescr->type_kind.
*     Char
      WHEN lo_abap_typedescr->typekind_char.
        CONCATENATE gs_data_ole <field> INTO gs_data_ole
        SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
*     Data
      WHEN lo_abap_typedescr->typekind_date.
        WRITE <field> TO lv_char DD/MM/YYYY.
        CONCATENATE gs_data_ole lv_char INTO gs_data_ole
        SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
*     Hora
      WHEN lo_abap_typedescr->typekind_time.
        CONCATENATE <field>(2) <field>+2(2) <field>+4(2) INTO lv_char SEPARATED BY ':'.
        CONCATENATE gs_data_ole lv_char INTO gs_data_ole
        SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
*    Outros
      WHEN OTHERS.
        WRITE <field> TO lv_char.
        CONCATENATE gs_data_ole lv_char INTO gs_data_ole
        SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    ENDCASE.

*   Exit the loop?
    IF lv_cont EQ p_num_cols.
      EXIT.
    ENDIF.
  ENDDO.

* Sai da primeira horizontal_tab:
  SHIFT gs_data_ole BY 1 PLACES LEFT.

  APPEND gs_data_ole TO gt_data_ole. CLEAR gs_data_ole.

ENDFORM.                    "add_line2print

FORM paste_clipboard USING p_row TYPE i
                           p_col TYPE i.

  DATA: lo_cell TYPE ole2_object.

* Copiar para a área de transferência no ABAP
  CALL FUNCTION 'CONTROL_FLUSH'
    EXCEPTIONS
      OTHERS = 3.
  CALL FUNCTION 'CLPB_EXPORT' "exportando para excel
    TABLES
      data_tab   = gt_data_ole
    EXCEPTIONS
      clpb_error = 1
      OTHERS     = 2.

* Seleciona a célula A1
  CALL METHOD OF go_worksheet 'Cells' = lo_cell
  EXPORTING
  #1 = p_row
  #2 = p_col.

* Cola a área de transferência da célula A1
  CALL METHOD OF lo_cell 'SELECT'.
  CALL METHOD OF go_worksheet 'PASTE'.

ENDFORM.  "paste_clipboard

*&———————————————————————*
*  –>  p_rowini  p_colini Célula de intervalo inicial
*  –>  p_rowend  p_colend Célula de intervalo final
*  –>  p_colour     Cor da fonte
*  –>  p_colourx    Defina como X se quiser alterar a cor
*  –>  p_shade      Matiz e sombra
*  –>  p_shadex     Defina como X se quiser alterar a tonalidade
*  –>  p_bkg_col    Cor de fundo da célula
*  –>  p_bkg_colx   Defina como X se quiser alterar a cor de fundo
*  –>  p_bkg_shade  Matiz e sombra
*  –>  p_bkg_shadex Defina como X se quiser alterar a tonalidade
*&———————————————————————*
FORM set_soft_colour USING  p_rowini
                            p_colini
                            p_rowend
                            p_colend
                            p_colour     TYPE i
                            p_colourx    TYPE char1
                            p_shade      TYPE float
                            p_shadex     TYPE char1
                            p_bkg_col    TYPE i
                            p_bkg_colx   TYPE char1
                            p_bkg_shade  TYPE float
                            p_bkg_shadex TYPE char1.

  DATA: lo_cellstart TYPE ole2_object,
        lo_cellend   TYPE ole2_object,
        lo_selection TYPE ole2_object,
        lo_range     TYPE ole2_object,
        lo_font      TYPE ole2_object,
        lo_interior  TYPE ole2_object.

* Seleciona o intervalo de células:
  CALL METHOD OF go_worksheet 'Cells' = lo_cellstart
    EXPORTING
      #1 = p_rowini
      #2 = p_colini.
  CALL METHOD OF go_worksheet 'Cells' = lo_cellend
    EXPORTING
      #1 = p_rowend
      #2 = p_colend.
  CALL METHOD OF go_worksheet 'Range' = lo_range
    EXPORTING
      #1 = lo_cellstart
      #2 = lo_cellend.

*   Formato:
  CALL METHOD OF lo_range 'FONT' = lo_font.

*   Cor:
  IF p_colourx EQ abap_true.
    SET PROPERTY OF lo_font 'ThemeColor' = p_colour.
    IF  p_shadex EQ abap_true.
      SET PROPERTY OF lo_font 'TintAndShade' = p_shade.
    ENDIF.
  ENDIF.

* Cor de fundo:
  IF p_bkg_colx EQ abap_true.
    CALL METHOD OF lo_range 'Interior' = lo_interior.
    SET PROPERTY OF lo_interior 'ThemeColor' = p_bkg_col.
    IF p_bkg_shadex EQ abap_true.
      SET PROPERTY OF lo_interior 'TintAndShade' = p_bkg_shade.
    ENDIF.
  ENDIF.

ENDFORM.       "set_soft_colour

FORM add_border  USING p_rowini
                       p_colini
                       p_rowend
                       p_colend.

  DATA: lo_cellstart TYPE ole2_object,
        lo_cellend   TYPE ole2_object,
        lo_selection TYPE ole2_object,
        lo_range     TYPE ole2_object,
        lo_borders   TYPE ole2_object.

* Seleciona o intervalo de células:
  CALL METHOD OF go_worksheet 'Cells' = lo_cellstart
  EXPORTING
  #1 = p_rowini
  #2 = p_colini.
  CALL METHOD OF go_worksheet 'Cells' = lo_cellend
  EXPORTING
  #1 = p_rowend
  #2 = p_colend.
  CALL METHOD OF go_worksheet 'Range' = lo_range
  EXPORTING
  #1 = lo_cellstart
  #2 = lo_cellend.

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '7'. "xledgeleft
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '8'. "xledgetop
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '9'. "xledgebottom
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '10'. "xledgeright
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '11'. "xlinsidevertical
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

  CALL METHOD OF lo_range 'Borders' = lo_borders EXPORTING #1 = '12'. "xlinsidehorizontal
  SET PROPERTY OF lo_borders 'LineStyle' = '1'. "xlcontinuous

ENDFORM.   "add border

*&———————————————————————*
*&      Form  Lock cells
*&———————————————————————*
*  Lock Cells
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*———————————————————————-*
FORM lock_cells  USING p_rowini p_colini
p_rowend p_colend.

  DATA: lo_cellstart TYPE ole2_object,
        lo_cellend   TYPE ole2_object,
        lo_selection TYPE ole2_object,
        lo_range     TYPE ole2_object.

* Select the Range of Cells:
  CALL METHOD OF go_worksheet 'Cells' = lo_cellstart
  EXPORTING
  #1 = p_rowini
  #2 = p_colini.
  CALL METHOD OF go_worksheet 'Cells' = lo_cellend
  EXPORTING
  #1 = p_rowend
  #2 = p_colend.
  CALL METHOD OF go_worksheet 'Range' = lo_range
  EXPORTING
  #1 = lo_cellstart
  #2 = lo_cellend.

  CALL METHOD OF lo_range 'select'.
  CALL METHOD OF go_application 'Selection' = lo_selection.
  SET PROPERTY OF lo_selection 'Locked' = 1.

  "Bloqueia as células para a edição:
  CALL METHOD OF go_worksheet 'Protect'
    EXPORTING
      #01 = 0
      #02 = 0.

ENDFORM.   "lock_cells

FORM close_document.
  CALL METHOD OF go_application 'QUIT'.
  FREE OBJECT go_worksheet.
  FREE OBJECT go_workbook.
  FREE OBJECT go_workbooks.
  FREE OBJECT go_application.
ENDFORM.                    "close_document
