*&---------------------------------------------------------------------*
*& Include          MZLMO008F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM f_create_alvtree_container
*&---------------------------------------------------------------------*
FORM f_create_alvtree_container.
  DATA: lt_node_table    TYPE treev_ntab,
        lt_item_table    TYPE gty_item_table,
        ls_event         TYPE cntl_simple_event,
        lt_events        TYPE cntl_simple_events,
        hierarchy_header TYPE treev_hhdr.

  "criando objeto de eventos
  CREATE OBJECT go_events.

  "criando objeto container
  CREATE OBJECT go_custom_container
    EXPORTING
      container_name              = gc_container_name_alv "CONTAINER_ALV
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

  "criando cabeçalho
  hierarchy_header-heading = TEXT-001.       " cabeçalho
  hierarchy_header-width   = 45.             " tamanho: 45 caracteres

  "criando objeto tree column
  CREATE OBJECT go_tree
    EXPORTING
      parent                      = go_custom_container                      "container
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single "classe para ALV Column
      item_selection              = abap_true                                "seleção de itens
      hierarchy_column_name       = gc_column-column1                        "coluna 1
      hierarchy_header            = hierarchy_header                         "cabeçalho
    EXCEPTIONS
      cntl_system_error           = 1
      create_error                = 2
      failed                      = 3
      illegal_node_selection_mode = 4
      illegal_column_name         = 5
      lifetime_error              = 6.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "criando objeto container
  CREATE OBJECT go_container_out
    EXPORTING
      container_name              = gc_container_name_out "CONTAINER_OUT
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


  "node duplo click
  ls_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  ls_event-appl_event = 'X'. " process PAI if event occurs
  APPEND ls_event TO lt_events.

  " item duplo click
  ls_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  ls_event-appl_event = 'X'.
  APPEND ls_event TO lt_events.

  CALL METHOD go_tree->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "verificando clicks
  SET HANDLER go_events->handle_node_double_click FOR go_tree.
  SET HANDLER go_events->handle_item_double_click FOR go_tree.

  "construindo tabelas de nós e itens
  PERFORM f_build_node_and_item_table USING lt_node_table lt_item_table.

  "passnado nós e itens para tree column
  CALL METHOD go_tree->add_nodes_and_items
    EXPORTING
      node_table                     = lt_node_table
      item_table                     = lt_item_table
      item_table_structure_name      = gc_mtreeitm
    EXCEPTIONS
      failed                         = 1
      cntl_system_error              = 3
      error_in_tables                = 4
      dp_error                       = 5
      table_structure_name_not_found = 6.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "inicia com o nó raíz já expandido
  CALL METHOD go_tree->expand_node
    EXPORTING
      node_key            = gc_nodekey-root
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
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_build_node_and_item_table
*&---------------------------------------------------------------------*
FORM f_build_node_and_item_table "construindo tabelas de nós e itens
  USING
    lt_node_table TYPE treev_ntab
    lt_item_table TYPE gty_item_table.

  DATA: lv_node TYPE treev_node,
        lv_item TYPE mtreeitm.

* Nó raiz "Controle"
  lv_node-node_key = gc_nodekey-root. " chave do nó
  CLEAR lv_node-relatkey.             " O nó raiz não possui parent
  CLEAR lv_node-relatship.            " node.

  lv_node-hidden   = space.      " O nó é visivel,
  lv_node-disabled = space.      " selecionável,
  lv_node-isfolder = abap_true.  " uma pasta.
  CLEAR lv_node-n_image.         " Pasta fechada por padrão
  CLEAR lv_node-exp_image.       " Pasta aberta por padrão
  CLEAR lv_node-expander.        " veja abaixo
  APPEND lv_node TO lt_node_table.

* Nó "checkin"
  CLEAR lv_node.
  lv_node-node_key  = gc_nodekey-checkin.
  lv_node-relatkey  = gc_nodekey-root.
  lv_node-relatship = cl_gui_column_tree=>relat_last_child.
  lv_node-n_image   = gc_icons-checkin.
  APPEND lv_node TO lt_node_table.

* nó "marcar_voo"
  CLEAR lv_node.
  lv_node-node_key  = gc_nodekey-marcar_voo.
  lv_node-relatkey  = gc_nodekey-root.
  lv_node-relatship = cl_gui_column_tree=>relat_last_child.
  lv_node-n_image   = gc_icons-marcar_voo.
  APPEND lv_node TO lt_node_table.

* nó "impr_cartao"
  CLEAR lv_node.
  lv_node-node_key  = gc_nodekey-impr_cartao.
  lv_node-relatkey  = gc_nodekey-root.
  lv_node-relatship = cl_gui_column_tree=>relat_last_child.
  lv_node-n_image   = gc_icons-impr_cartao.
  APPEND lv_node TO lt_node_table.

  ""ITENS
  CLEAR lv_item.
  lv_item-node_key  = gc_nodekey-root.
  lv_item-item_name = gc_column-column1.
  lv_item-class     = cl_gui_column_tree=>item_class_text.
  lv_item-text      = gc_itemtext-root. "controle
  APPEND lv_item TO lt_item_table.

  CLEAR lv_item.
  lv_item-node_key  = gc_nodekey-checkin.
  lv_item-item_name = gc_column-column1.
  lv_item-class     = cl_gui_column_tree=>item_class_text.
  lv_item-text      = gc_itemtext-checkin. "checkin
  APPEND lv_item TO lt_item_table.

  CLEAR lv_item.
  lv_item-node_key  = gc_nodekey-marcar_voo.
  lv_item-item_name = gc_column-column1.
  lv_item-class     = cl_gui_column_tree=>item_class_text.
  lv_item-text      = gc_itemtext-marcar_voo. "marcar vôo
  APPEND lv_item TO lt_item_table.

  CLEAR lv_item.
  lv_item-node_key  = gc_nodekey-impr_cartao.
  lv_item-item_name = gc_column-column1.
  lv_item-class     = cl_gui_column_tree=>item_class_text.
  lv_item-text      = gc_itemtext-impr_cartao. "imprimir cartão de embarque
  APPEND lv_item TO lt_item_table.
ENDFORM.                    " build_node_and_item_table

*&---------------------------------------------------------------------*
*& FORM f_fetch_binary_data
*&---------------------------------------------------------------------*
FORM f_fetch_binary_data.
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp "carregando imagem da tela inicial
    EXPORTING
      p_object  = gc_img_param-p_object "GRAPHICS
      p_name    = gc_img_param-p_name   "ZAVIAO_EMBARQUE
      p_id      = gc_img_param-p_id     "BMAP
      p_btype   = gc_img_param-p_btype  "BCOL
    RECEIVING
      p_bmp     = gv_bindata
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  gt_picbin = cl_document_bcs=>xstring_to_solix( gv_bindata ).
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_create_url
*&---------------------------------------------------------------------*
FORM f_create_url.
  CALL FUNCTION 'DP_CREATE_URL' "imagem da tela inicial
    EXPORTING
      type    = gc_type_img   "image
      subtype = gc_sbtype_img "X-UNKNOWN
    TABLES
      data    = gt_picbin
    CHANGING
      url     = gv_url
    EXCEPTIONS
      OTHERS  = 4.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_valid_checkin
*&---------------------------------------------------------------------*
FORM f_valid_checkin.
  CLEAR gs_checkin.

  SELECT SINGLE * "coletando dados para checkin
    FROM sbook
    INTO CORRESPONDING FIELDS OF gs_checkin
    WHERE carrid = gs_0120-carrid
    AND   bookid = gs_0120-bookid.

  IF gs_checkin IS INITIAL.                                        "verificando se foi encontrado alguma reserva
    MESSAGE i398 WITH TEXT-002 space space space DISPLAY LIKE 'E'. "Reserva não encontrada!
  ELSEIF gs_checkin-reserved = abap_true AND gs_checkin-cancelled = space.
    gv_subscreen = '0130'.
  ELSE.                                                            "caso tenha sido encontrado dados mas ainda não reservados
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = TEXT-003 "Atenção
        text_question         = TEXT-004 "Reserva ainda não marcada. Deseja efetuar a marcação?
        text_button_1         = TEXT-005 "Sim
        text_button_2         = TEXT-006 "Não
        display_cancel_button = abap_true
      IMPORTING
        answer                = gv_answer_checkin
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  IF gv_answer_checkin = '1'.                "Caso a resposta do popup seja SIM
    gs_checkin-reserved = abap_true.         "marcar o campo de reservado
    APPEND gs_checkin TO gt_checkin.

    CALL FUNCTION 'SAPBC_GLOBAL_UPDATE_BOOK' "atualizar tabela sbook com a nova reserva
      TABLES
        booking_tab = gt_checkin.

    gv_subscreen = '0130'.
  ENDIF.

  CLEAR gv_answer_checkin.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_popup_marcar_voo
*&---------------------------------------------------------------------*
FORM f_popup_marcar_voo.
  DATA: lt_fields     TYPE TABLE OF sval,
        ls_fields     TYPE sval,
        lv_returncode TYPE c.

  IF lt_fields IS INITIAL. "Evitando que adicione novamente os campos
    "passando dados da tabela para o popup
    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields-tabname.    "sflight
    ls_fields-fieldname  = gc_popup_fields-fieldname1. "CARRID
    ls_fields-field_attr = gc_popup_fields-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                  "Obrigatorio indicar um valor
    ls_fields-fieldtext  = TEXT-008.                   "Texto descritivo esquerdo // Companhia aérea
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields-tabname.    "sflight
    ls_fields-fieldname  = gc_popup_fields-fieldname2. "CONNID
    ls_fields-field_attr = gc_popup_fields-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                  "Obrigatorio indicar um valor
    ls_fields-fieldtext  = TEXT-009.                   "N° vôo
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields-tabname.    "sflight
    ls_fields-fieldname  = gc_popup_fields-fieldname3. "FLDATE
    ls_fields-field_attr = gc_popup_fields-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                  "Obrigatorio indicar um valor
    ls_fields-fieldtext  = TEXT-010.                   "Data vôo
    APPEND ls_fields TO lt_fields.
  ENDIF.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = TEXT-007 "Verificar assentos
    IMPORTING
      returncode      = lv_returncode
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSEIF lv_returncode IS NOT INITIAL.
    gv_subscreen = 0110.
    ""Para forçar o PAI a rodar e recarregar a tela no PBO. Sem isso o programa espera pressionar enter
    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
      EXPORTING
        functioncode           = '='
      EXCEPTIONS
        function_not_supported = 0
        OTHERS                 = 0.
    EXIT.
  ENDIF.

  "PASSANDO OS DADOS DO POPUP PARA VAR
  LOOP AT lt_fields INTO ls_fields.
    IF ls_fields-fieldname     = gc_popup_fields-fieldname1. "CARRID
      gv_popup_param-carrid = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields-fieldname2. "CONNID
      gv_popup_param-connid = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields-fieldname3. "FLDATE
      gv_popup_param-fldate = ls_fields-value.
    ENDIF.
  ENDLOOP.

  PERFORM f_valid_assentos. "validando assentos e chamando tela 0150

  ""Para forçar o PAI a rodar e recarregar a tela no PBO. Sem isso o programa espera pressionar enter
  CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
    EXPORTING
      functioncode           = '='
    EXCEPTIONS
      function_not_supported = 1
      OTHERS                 = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_valid_marcar_voo
*&---------------------------------------------------------------------*
FORM f_valid_marcar_voo.
  "ATUALIZANDO TABELA SBOOK
  CALL FUNCTION 'SAPBC_GLOBAL_BOOK'
    EXPORTING
      iv_carrid                  = gs_sbook-carrid
      iv_connid                  = gs_sbook-connid
      iv_fldate                  = gs_sbook-fldate
      iv_customer                = gs_sbook-customid
      iv_agency                  = gs_sbook-agencynum
      iv_class                   = gs_sbook-class
      iv_smoker                  = gs_sbook-smoker
      iv_luggweight              = gs_sbook-luggweight
      iv_wunit                   = gs_sbook-wunit
    EXCEPTIONS
      invalid_customer           = 1
      agency_and_counter         = 2
      invalid_travel_agency      = 3
      invalid_counter            = 4
      neither_agency_nor_counter = 5
      flight_not_found           = 6
      flight_locked              = 7
      flight_booked_out          = 8
      no_bookid_available        = 9
      insert_sbook_rejected      = 10
      update_sflight_rejected    = 11
      invalid_class              = 12
      OTHERS                     = 13.

  IF sy-subrc NE 0.
    ROLLBACK WORK.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    EXIT.
  ELSE.
    COMMIT WORK.
    MESSAGE i398 WITH TEXT-014 space space space DISPLAY LIKE 'I'. "Marcação efetuada
    gv_subscreen = '0160'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_popup_impr
*&---------------------------------------------------------------------*
FORM f_popup_impr.
  DATA: lt_fields     TYPE TABLE OF sval,
        ls_fields     TYPE sval,
        ls_saida      TYPE zslmo005,
        lv_returncode TYPE c.

  IF lt_fields IS INITIAL. "Evitando que adicione novamente os campos
    "passando dados da tabela para o popup
    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname1. "CARRID
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                   "Obrigatorio indicar um valor
    IF gs_sbook-carrid IS NOT INITIAL.
      ls_fields-value      = gs_sbook-carrid.
    ENDIF.
    ls_fields-fieldtext  = TEXT-008.                    "Texto descritivo esquerdo
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname2. "CONNID
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                   "Obrigatorio indicar um valor
    IF gs_sbook-connid IS NOT INITIAL.
      ls_fields-value      = gs_sbook-connid.
    ENDIF.
    ls_fields-fieldtext  = TEXT-009.                    "N° vôo
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname3. "FLDATE
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                   "Obrigatorio indicar um valor
    IF gs_sbook-fldate IS NOT INITIAL.
      ls_fields-value      = gs_sbook-fldate.
    ENDIF.
    ls_fields-fieldtext  = TEXT-010.                    "Data vôo
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname4. "BOOKID
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-field_obl  = abap_true.                   "Obrigatorio indicar um valor
    IF gs_0120-bookid IS NOT INITIAL.
      ls_fields-value      = gs_0120-bookid.
    ENDIF.
    ls_fields-fieldtext  = TEXT-013.                    "N° de marcação
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname5. "FLAG
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-fieldtext  = TEXT-015.                    "Baixar local?
    APPEND ls_fields TO lt_fields.

    CLEAR ls_fields.
    ls_fields-tabname    = gc_popup_fields2-tabname.    "ZSLMO005
    ls_fields-fieldname  = gc_popup_fields2-fieldname6. "FILENAME
    ls_fields-field_attr = gc_popup_fields2-field_attr. "Atributo para visualização do campo
    ls_fields-fieldtext  = TEXT-016.                    "Caminho do arquivo
    APPEND ls_fields TO lt_fields.
  ENDIF.

  CALL FUNCTION 'POPUP_GET_VALUES_USER_HELP'
    EXPORTING
      f4_formname     = 'F_MC_IMPR_POPUP'
      f4_programname  = sy-repid
      popup_title     = TEXT-017
    IMPORTING
      returncode      = lv_returncode
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSEIF lv_returncode IS NOT INITIAL.
    gv_subscreen = 0110.

    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE' ""Para forçar o PAI a rodar e recarregar a tela no PBO. Sem isso o programa espera pressionar enter
      EXPORTING
        functioncode           = '='
      EXCEPTIONS
        function_not_supported = 0
        OTHERS                 = 0.
    EXIT.
  ENDIF.

  LOOP AT lt_fields INTO ls_fields.
    IF ls_fields-fieldname     = gc_popup_fields2-fieldname1. "CARRID
      ls_saida-carrid   = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields2-fieldname2. "CONNID
      ls_saida-connid   = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields2-fieldname3. "FLDATE
      ls_saida-fldate   = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields2-fieldname4. "BOOKID
      ls_saida-bookid   = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields2-fieldname5. "FLAG
      ls_saida-flag     = ls_fields-value.
    ELSEIF ls_fields-fieldname = gc_popup_fields2-fieldname6. "FILENAME
      ls_saida-filename = ls_fields-value.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'ZF_LMO_CARTAO_EMBARQUE'
    EXPORTING
      i_carrid      = ls_saida-carrid
      i_connid      = ls_saida-connid
      i_fldate      = ls_saida-fldate
      i_bookid      = ls_saida-bookid
      i_flag_local  = ls_saida-flag
      i_file        = ls_saida-filename
    IMPORTING
      ev_msg_sucess = gv_impr_function-msg_sucess
      ev_msg_error  = gv_impr_function-msg_error
    EXCEPTIONS
      OTHERS        = 0.

  IF gv_impr_function-msg_error IS NOT INITIAL.
    MESSAGE i398 WITH gv_impr_function-msg_error DISPLAY LIKE 'E'.
    EXIT.
  ELSE.
    MESSAGE i398 WITH gv_impr_function-msg_sucess DISPLAY LIKE 'S'.
    CLEAR: gs_0120, gs_sbook, gv_checkin_param.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_valid_assentos
*&---------------------------------------------------------------------*
FORM f_valid_assentos.
  DATA: lv_seatsaval(3) TYPE n.

  "VERIFICANDO DISPONIBILIDADE DE ASSENTOS
  SELECT seatsmax seatsocc seatsmax_b seatsocc_b seatsmax_f seatsocc_f
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight
    WHERE carrid = gv_popup_param-carrid
    AND   connid = gv_popup_param-connid
    AND   fldate = gv_popup_param-fldate.

  IF gt_sflight IS INITIAL.
    MESSAGE i398 WITH TEXT-011 space space space DISPLAY LIKE 'E'. "Vôo não encontrado!
    EXIT.
  ENDIF.

  CLEAR gs_sflight.
  READ TABLE gt_sflight INTO gs_sflight INDEX 1.
  lv_seatsaval = gs_sflight-seatsmax - gs_sflight-seatsocc + gs_sflight-seatsmax_b - gs_sflight-seatsocc_b + gs_sflight-seatsmax_f - gs_sflight-seatsocc_f.

  IF lv_seatsaval = 0.
    MESSAGE i398 WITH TEXT-012 space space space DISPLAY LIKE 'E'. "Reserva não encontrada!
    EXIT.
  ENDIF.

  gv_subscreen = '0150'.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM f_valid_assentos
*&---------------------------------------------------------------------*
FORM f_valid_reserva.
  CLEAR gs_lmot008.

  "PASSANDO DADOS PARA A TABELA ZLMOT008
  gs_lmot008-carrid     = gs_checkin-carrid.
  gv_popup_param-carrid = gs_checkin-carrid. "variavel de companhia aérea para tela de marcação
  gs_lmot008-connid     = gs_checkin-connid.
  gv_popup_param-connid = gs_checkin-connid. "variavel de num de vôo para tela de marcação
  gs_lmot008-fldate     = gs_checkin-fldate.
  gv_popup_param-fldate = gs_checkin-fldate. "variavel de data do vôo para tela de marcação
  gs_lmot008-bookid     = gs_checkin-bookid.
  gs_lmot008-seatnum    = gv_checkin_param-seatnum.

  IF gv_checkin_param-seatrow CA sy-abcde. "verificando se o campo possui apenas letras
    gs_lmot008-seatrow    = gv_checkin_param-seatrow.
  ELSE.
    MESSAGE  TEXT-026 type 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  gs_lmot008-location   = gv_checkin_param-location.
  gs_lmot008-reserved   = abap_true.
  gs_lmot008-cancelled  = space.

  INSERT INTO zlmot008 VALUES gs_lmot008.

  IF sy-subrc = '0'.
    COMMIT WORK.
    MESSAGE i398 WITH TEXT-022 space space space DISPLAY LIKE 'S'. "Reserva efetuada!
  ELSEIF sy-subrc = '4'.
    ROLLBACK WORK.
    MESSAGE i398 WITH TEXT-025 space space space DISPLAY LIKE 'E'. "Os dados inseridos já foram reservados
    EXIT.
  ELSE.
    ROLLBACK WORK.
    MESSAGE i398 WITH TEXT-023 space space space DISPLAY LIKE 'E'. "Reserva falhou!
    EXIT.
  ENDIF.

  PERFORM f_valid_assentos. "verificando disponibilidade de assentos e transferindo para tela 0150
ENDFORM.

FORM f_mc_impr_popup USING     tabname fieldname display
                     CHANGING  returncode value.

  TYPES: BEGIN OF lty_mc_carrid, "dados que serão buscados no matchcode
           carrid TYPE sbook-carrid,
         END OF lty_mc_carrid,
         BEGIN OF lty_mc_connid,
           connid TYPE sbook-connid,
         END OF lty_mc_connid,
         BEGIN OF lty_mc_fldate,
           fldate TYPE sbook-fldate,
         END OF lty_mc_fldate,
         BEGIN OF lty_mc_bookid,
           bookid TYPE sbook-bookid,
         END OF lty_mc_bookid.

  DATA: lt_mc_carrid TYPE TABLE OF lty_mc_carrid,
        lt_mc_connid TYPE TABLE OF lty_mc_connid,
        lt_mc_fldate TYPE TABLE OF lty_mc_fldate,
        lt_mc_bookid TYPE TABLE OF lty_mc_bookid,
        lt_return    TYPE STANDARD TABLE OF ddshretval,
        ls_return    TYPE ddshretval.

  CASE fieldname.
    WHEN gc_popup_fields2-fieldname1. "CARRID
      SELECT carrid "buscando dados de valores de companhia aérea
        FROM sbook
        INTO CORRESPONDING FIELDS OF TABLE lt_mc_carrid.

      SORT lt_mc_carrid BY carrid. "ordenando valores
      DELETE ADJACENT DUPLICATES FROM lt_mc_carrid COMPARING carrid.

      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "chamando matchcode
        EXPORTING
          retfield        = 'CARRID'
          dynpprog        = sy-repid
          value_org       = 'S'
        TABLES
          value_tab       = lt_mc_carrid[]
          return_tab      = lt_return[]
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2.

      IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        READ TABLE lt_return INTO ls_return INDEX 1.
        value  = ls_return-fieldval.
      ENDIF.

    WHEN gc_popup_fields2-fieldname2. "CONNID
      SELECT connid "buscando dados de valores de num do vôo
        FROM sbook
        INTO CORRESPONDING FIELDS OF TABLE lt_mc_connid.

      SORT lt_mc_connid BY connid. "ordenando valores
      DELETE ADJACENT DUPLICATES FROM lt_mc_connid COMPARING connid.

      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "chamando matchcode
        EXPORTING
          retfield        = 'CONNID'
          dynpprog        = sy-repid
          value_org       = 'S'
        TABLES
          value_tab       = lt_mc_connid[]
          return_tab      = lt_return[]
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2.

      IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        READ TABLE lt_return INTO ls_return INDEX 1.
        value         = ls_return-fieldval.
      ENDIF.

    WHEN gc_popup_fields2-fieldname3. "FLDATE
      SELECT fldate "buscando dados de valores de data do vôo
        FROM sbook
        INTO CORRESPONDING FIELDS OF TABLE lt_mc_fldate.

      SORT lt_mc_fldate BY fldate. "ordenando valores
      DELETE ADJACENT DUPLICATES FROM lt_mc_fldate COMPARING fldate.

      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "chamando matchcode
        EXPORTING
          retfield        = 'FLDATE'
          dynpprog        = sy-repid
          value_org       = 'S'
        TABLES
          value_tab       = lt_mc_fldate[]
          return_tab      = lt_return[]
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2.

      IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        READ TABLE lt_return INTO ls_return INDEX 1.
        value         = ls_return-fieldval.
      ENDIF.

    WHEN gc_popup_fields2-fieldname4. "BOOKID
      SELECT bookid "buscando dados de valores de data do vôo
        FROM sbook
        INTO CORRESPONDING FIELDS OF TABLE lt_mc_bookid
        UP TO 100 ROWS.

      SORT lt_mc_bookid BY bookid. "ordenando valores
      DELETE ADJACENT DUPLICATES FROM lt_mc_bookid COMPARING bookid.

      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "chamando matchcode
        EXPORTING
          retfield        = 'BOOKID'
          dynpprog        = sy-repid
          value_org       = 'S'
        TABLES
          value_tab       = lt_mc_bookid[]
          return_tab      = lt_return[]
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2.

      IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        READ TABLE lt_return INTO ls_return INDEX 1.
        value = ls_return-fieldval.
      ENDIF.

    WHEN gc_popup_fields2-fieldname6. "FILENAME
      DATA:
        lv_path_ini TYPE string VALUE 'C:\',
        lv_path_sel TYPE string.

      CALL METHOD cl_gui_frontend_services=>directory_browse
        EXPORTING
          initial_folder  = lv_path_ini
        CHANGING
          selected_folder = lv_path_sel
        EXCEPTIONS
          cntl_error      = 1
          error_no_gui    = 2
          OTHERS          = 3.

      IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        CONCATENATE lv_path_sel '\cartao_embarque.pdf' INTO lv_path_sel.
        value = lv_path_sel.
      ENDIF.
  ENDCASE.
ENDFORM.
