*&---------------------------------------------------------------------*
*& Domain       : WM                                                   *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 13.09.2023                                           *
*& Description  : Criando ALV orientado a objeto                       *
*&---------------------------------------------------------------------*

REPORT zlmor022 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : ekko, ekpo, makt.

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_ekko,
         ebeln TYPE ekko-ebeln, "n doc
         bukrs TYPE ekko-bukrs, "empresa
         lifnr TYPE ekko-lifnr, "fornecedor
         bedat TYPE ekko-bedat, "data
       END OF gty_ekko,

       BEGIN OF gty_ekpo,
         ebeln TYPE ekpo-ebeln, "n doc
         matnr TYPE ekpo-matnr, "material
         werks TYPE ekpo-werks, "centro
         lgort TYPE ekpo-lgort, "deposito
       END OF gty_ekpo,

       BEGIN OF gty_saida,
         ebeln TYPE ekko-ebeln, "n doc
         bukrs TYPE ekko-bukrs, "empresa
         lifnr TYPE ekko-lifnr, "fornecedor
         bedat TYPE ekko-bedat, "data
         matnr TYPE ekpo-matnr, "material
         werks TYPE ekpo-werks, "centro
         lgort TYPE ekpo-lgort, "deposito
         maktx TYPE makt-maktx, "descricao
       END OF gty_saida
       .

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA: gt_ekko  TYPE TABLE OF gty_ekko,
      gt_ekpo  TYPE TABLE OF gty_ekpo,
      gt_makt  TYPE TABLE OF makt,
      gt_saida TYPE TABLE OF gty_saida
      .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA: gs_ekko  TYPE gty_ekko,
      gs_ekpo  TYPE gty_ekpo,
      gs_makt  TYPE makt,
      gs_saida TYPE gty_saida
      .

DATA: go_grid1            TYPE REF TO cl_gui_alv_grid,
      gt_fieldcat         TYPE lvc_t_fcat,
      gs_fieldcat         TYPE lvc_s_fcat,
      gs_layout           TYPE lvc_s_layo,
      gs_variant          TYPE disvariant,
      go_custom_container TYPE REF TO cl_gui_custom_container,
      gt_exclude          TYPE ui_functions.

"" Variaveis
DATA: gv_but TYPE stb_button.

""Constantes
DATA: gc_selmode     TYPE c      VALUE 'D',
      gc_isave       TYPE c      VALUE 'A',
      gc_delbut_func TYPE string VALUE 'DELETE',
      gc_delbut_icon TYPE string VALUE '@11@',
      gc_delbut_type TYPE p      VALUE 4,
      gc_delbut_text TYPE string VALUE 'Deletar'
      .

**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS:
   s_ebeln FOR ekko-ebeln,
   s_matnr FOR ekpo-matnr.
SELECTION-SCREEN END OF BLOCK b1.

INCLUDE zprimeiro_ooclalmo.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM f_select_data.
  PERFORM f_prepare_data.
  PERFORM f_print.

*
*& FORM SELECT DATA
*
*&--------------------------------------------------------------------
*
FORM f_select_data.
  "limpando tabelas
  FREE: gt_ekko, gt_ekpo, gt_makt, gt_saida.
  "limpando estruturas
  CLEAR: gs_ekko, gs_ekpo, gs_makt, gs_saida.

  "selecionando dados de cabeçalho do documento de compra
  SELECT ebeln bukrs lifnr bedat
    FROM ekko
    INTO TABLE gt_ekko
    WHERE ebeln IN s_ebeln.

  "verificando erros
  IF sy-subrc <> 0.
    MESSAGE S000(00) WITH TEXT-001 DISPLAY LIKE 'E'. "Nenhum registro encontrado em ekko
    STOP.
  ENDIF.

  "selecionando dados de item do documento de compras
  SELECT ebeln matnr werks lgort
    FROM ekpo
    INTO TABLE gt_ekpo
    FOR ALL ENTRIES IN gt_ekko
    WHERE ebeln = gt_ekko-ebeln
    AND matnr IN s_matnr.

  "verificando erros
  IF sy-subrc <> 0.
    MESSAGE S000(00) WITH TEXT-002 DISPLAY LIKE 'E'. "Nenhum registro encontrado em ekpo
    STOP.
  ENDIF.

  "selecionando dados de textos breves de material
  SELECT *
    FROM makt
    INTO TABLE gt_makt
    FOR ALL ENTRIES IN gt_ekpo
    WHERE matnr = gt_ekpo-matnr
    AND spras = sy-langu.

  "ordenando dados
  SORT: gt_ekko BY ebeln,
        gt_ekpo BY ebeln,
        gt_makt BY matnr.
ENDFORM.
*&--------------------------------------------------------------------
*
*& FORM PREPARE DATA
*
*&--------------------------------------------------------------------
*
FORM f_prepare_data.
  LOOP AT gt_ekpo INTO gs_ekpo.
    "lendo dados de itens e cabeçalhos de documentos para tabela de saida
    READ TABLE gt_ekko
      INTO gs_ekko
      WITH KEY ebeln = gs_ekpo-ebeln BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-ebeln = gs_ekko-ebeln.
      gs_saida-bukrs = gs_ekko-bukrs.
      gs_saida-lifnr = gs_ekko-lifnr.
      gs_saida-bedat = gs_ekko-bedat.
      gs_saida-matnr = gs_ekpo-matnr.
      gs_saida-werks = gs_ekpo-werks.
      gs_saida-lgort = gs_ekpo-lgort.

      "lendo dados de descrição para tabela de saida
      READ TABLE gt_makt
        INTO gs_makt
        WITH KEY matnr = gs_ekpo-matnr BINARY SEARCH.

      "verificando erros
      IF sy-subrc = 0.
        gs_saida-maktx = gs_makt-maktx.
      ENDIF.

      "repassando dados para tabela de saida
      APPEND gs_saida TO gt_saida.
      CLEAR gs_saida.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&--------------------------------------------------------------------
*
*& FORM PRINT
*
*&--------------------------------------------------------------------
*
FORM f_print.
  "montando fieldcat e chamando tela principal
  PERFORM f_build_fields.
  CALL SCREEN '100'.
ENDFORM.
*&--------------------------------------------------------------------
*
*& FORM BUILD FIELDS
*
*&--------------------------------------------------------------------
*
FORM f_build_fields.
  "montando fieldcat
  PERFORM f_add_field USING 'EBELN' 'Nº do documento'
  ' ' ' '.
  PERFORM f_add_field USING 'BUKRS' 'Empresa'
  ' ' ' '.
  PERFORM f_add_field USING 'LIFNR' 'Nº conta do fornecedor'
  ' ' ' '.
  PERFORM f_add_field USING 'BEDAT' 'Data do documento de compra'
  ' ' ' '.
  PERFORM f_add_field USING 'MATNR' 'Nº do material'
  ' ' ' '.
  PERFORM f_add_field USING 'WERKS' 'Centro'
  ' ' ' '.
  PERFORM f_add_field USING 'LGORT' 'Depósito'
  ' ' ' '.
  PERFORM f_add_field USING 'MAKTX' 'Texto breve de material'
  ' ' ' '.
ENDFORM.
*&--------------------------------------------------------------------
*
*& FORM ADD FIELD
*
*&--------------------------------------------------------------------
*
FORM f_add_field USING p_fieldname
                       p_seltext_l
                       p_checkbox
                       p_edit.
  "montando campo de fieldcat
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-scrtext_l = p_seltext_l.
  gs_fieldcat-checkbox  = p_checkbox.
  gs_fieldcat-edit      = p_edit.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

INCLUDE zlmor022o01.
INCLUDE zlmor022i01.

*&--------------------------------------------------------------------
*
*& Form F_CRIA_OBJETOS_ALV
*
*&--------------------------------------------------------------------
*
FORM f_cria_objetos_alv.
  IF go_custom_container IS INITIAL.
    REFRESH: gt_exclude.
    CREATE OBJECT go_custom_container
      EXPORTING
        container_name              = 'CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    "exclui botões do alv
    PERFORM exclude_tb_functions CHANGING gt_exclude.

    "Cria objeto de controle alv
    CREATE OBJECT go_grid1
      EXPORTING
        i_parent = go_custom_container.

    "Recebe os eventos acontecidos no grid
    CREATE OBJECT event_receiver.
    SET HANDLER event_receiver->catch_hotspot       FOR go_grid1.
    SET HANDLER event_receiver->handle_user_command FOR go_grid1.
    SET HANDLER event_receiver->handle_toolbar      FOR go_grid1.

    gs_variant-report    = sy-repid.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-sel_mode   = gc_selmode.

    "Imprime o ALV
    CALL METHOD go_grid1->set_table_for_first_display
      EXPORTING
        is_variant           = gs_variant
        i_save               = gc_isave
        is_layout            = gs_layout
        it_toolbar_excluding = gt_exclude
      CHANGING
        it_fieldcatalog      = gt_fieldcat
        it_outtab            = gt_saida[].

    CALL METHOD go_grid1->set_toolbar_interactive.
  ENDIF.
ENDFORM.
FORM exclude_tb_functions CHANGING pt_exclude TYPE ui_functions.
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
