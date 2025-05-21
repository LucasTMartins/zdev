class ZCL_ZLMO_GW_008_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_008_DPC
  create public .

public section.
protected section.

  methods ZLMOT021SET_DELETE_ENTITY
    redefinition .
  methods ZLMOT021SET_GET_ENTITY
    redefinition .
  methods ZLMOT021SET_GET_ENTITYSET
    redefinition .
  methods ZLMOT021SET_UPDATE_ENTITY
    redefinition .
  methods ZLMOT021SET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_008_DPC_EXT IMPLEMENTATION.


  METHOD zlmot021set_create_entity.
    "Entidade para saida
    DATA: ls_entity TYPE zcl_zlmo_gw_008_mpc=>ts_zlmot021.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    " Validando se os dados obrigatórios foram informados
    IF   ls_entity-lgnum IS INITIAL
      OR ls_entity-werks IS INITIAL
      OR ls_entity-matnr IS INITIAL.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'Dados obrigatórios não informados.'.

    ELSE.
      SELECT SINGLE lgnum
        FROM zlmot021
        INTO @DATA(lv_lgnum)
        WHERE lgnum EQ @ls_entity-lgnum
          AND werks EQ @ls_entity-werks
          AND matnr EQ @ls_entity-matnr.

      " Validando se o matérial já existe
      IF sy-subrc EQ 0.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_container = me->mo_context->get_message_container( )
            message           = |Material: { ls_entity-lgnum } { ls_entity-werks } { ls_entity-matnr } já cadastrado|.
      ELSE.
        " Inserindo valores restantes
        ls_entity-ativo      = abap_true.
        ls_entity-status     = 'P'.
        ls_entity-criado_por = sy-uname.
        ls_entity-dt_criacao = sy-datum.
        ls_entity-hr_criacao = sy-uzeit.

        " Inseridos novos valores
        INSERT zlmot021 FROM ls_entity.

        " Retornando a entidade criada na resposta da requisição
        IF sy-subrc EQ 0.
          er_entity = ls_entity.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zlmot021set_delete_entity.
    "chaves primárias
    DATA: lv_lgnum TYPE zlmot021-lgnum,
          lv_werks TYPE zlmot021-werks,
          lv_matnr TYPE zlmot021-matnr.

    "filtrando dados
    IF line_exists( it_key_tab[ name = 'Lgnum' ] ).
      lv_lgnum = it_key_tab[ name = 'Lgnum' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Werks' ] ).
      lv_werks = it_key_tab[ name = 'Werks' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Matnr' ] ).
      lv_matnr = it_key_tab[ name = 'Matnr' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    "deletando dados
    DELETE FROM zlmot021 WHERE lgnum EQ lv_lgnum
                           AND werks EQ lv_werks
                           AND matnr EQ lv_matnr.

    IF sy-subrc EQ 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type = 'S'
        iv_msg_id = '00'
        iv_msg_number = '1'
        iv_msg_v1 = 'Registro excluído com sucesso!'
        iv_is_leading_message = abap_true
        iv_add_to_response_header = abap_true
      ).
    ELSE.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type = 'E'
        iv_msg_id = '00'
        iv_msg_number = '1'
        iv_msg_text = 'Erro ao excluir registro!'
        iv_is_leading_message = abap_true
        iv_add_to_response_header = abap_true
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.
  ENDMETHOD.


  METHOD zlmot021set_get_entity.
    "chave primária
    DATA: lv_lgnum TYPE zlmot021-lgnum,
          lv_werks TYPE zlmot021-werks,
          lv_matnr TYPE zlmot021-matnr.

    "filtrando os dados necessários
    IF line_exists( it_key_tab[ name = 'Lgnum' ] ).
      lv_lgnum = it_key_tab[ name = 'Lgnum' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Werks' ] ).
      lv_werks = it_key_tab[ name = 'Werks' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Matnr' ] ).
      lv_matnr = it_key_tab[ name = 'Matnr' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmot021
      INTO @DATA(ls_saida)
      WHERE lgnum EQ @lv_lgnum
        AND werks EQ @lv_werks
        AND matnr EQ @lv_matnr.

    "passando para a tabela de saida
    MOVE-CORRESPONDING ls_saida TO er_entity.
  ENDMETHOD.


  METHOD zlmot021set_get_entityset.
    "chaves primárias
    DATA: lr_lgnum     TYPE RANGE OF zlmot021-lgnum,
          lr_werks     TYPE RANGE OF zlmot021-werks,
          lr_matnr     TYPE RANGE OF zlmot021-matnr,
          lr_ativo     TYPE RANGE OF zlmot021-ativo,
          lr_status    TYPE RANGE OF zlmot021-status,
          lr_criadopor TYPE RANGE OF zlmot021-criado_por,
          lt_order     TYPE /iwbep/t_mgw_sorting_order.

    "passando filtros
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Lgnum'.
          lr_lgnum  = VALUE #( FOR lgnum IN ls_filter-select_options ( CORRESPONDING #( lgnum ) ) ).
        WHEN 'Werks'.
          lr_werks  = VALUE #( FOR werks IN ls_filter-select_options ( CORRESPONDING #( werks ) ) ).
        WHEN 'Matnr'.
          lr_matnr  = VALUE #( FOR matnr IN ls_filter-select_options ( CORRESPONDING #( matnr ) ) ).
        WHEN 'Ativo'.
          lr_ativo  = VALUE #( FOR ativo IN ls_filter-select_options ( CORRESPONDING #( ativo ) ) ).
        WHEN 'Status'.
          lr_status = VALUE #( FOR status IN ls_filter-select_options ( CORRESPONDING #( status ) ) ).
        WHEN 'CriadoPor'.
          lr_criadopor = VALUE #( FOR criado_por IN ls_filter-select_options ( CORRESPONDING #( criado_por ) ) ).
      ENDCASE.
    ENDLOOP.

    "buscando dados filtrando pelo centro e status
    IF lr_werks IS NOT INITIAL.
      SELECT *
        FROM zlmot021
        INTO TABLE @DATA(lt_saida)
        WHERE lgnum  IN @lr_lgnum
          AND werks  IN @lr_werks
          AND ativo  IN @lr_ativo
          AND status IN @lr_status.
    ENDIF.

    "buscando dados filtrando pelo material e status
    IF lr_matnr IS NOT INITIAL AND lt_saida IS INITIAL. "caso a tabela interna esteja vazia, o dado filtrado pelo campo de pesquisa não é um centro
      SELECT *
        FROM zlmot021
        INTO TABLE @lt_saida
        WHERE lgnum  IN @lr_lgnum
          AND matnr  IN @lr_matnr
          AND ativo  IN @lr_ativo
          AND status IN @lr_status.
    ENDIF.

    "buscando dados filtrando pelo usuário que criou e status
    IF lr_criadopor IS NOT INITIAL AND lt_saida IS INITIAL. "caso a tabela interna esteja vazia, o dado filtrado pelo campo de pesquisa não é um material e nem um centro
      SELECT *
        FROM zlmot021
        INTO TABLE @lt_saida
        WHERE lgnum      IN @lr_lgnum
          AND ativo      IN @lr_ativo
          AND status     IN @lr_status
          AND criado_por IN @lr_criadopor.
    ENDIF.

    "buscando dados filtrando pelo apenas pelo status
    IF lr_werks IS INITIAL. "caso o lr_werks esteja vazio, o lr_matnr e o lr_criadopor também estarão, pois são preenchidos sempre juntos, e a tabela estará vazia por não entrar nas outras buscas
      SELECT *
        FROM zlmot021
        INTO TABLE @lt_saida
        WHERE lgnum  IN @lr_lgnum
          AND ativo  IN @lr_ativo
          AND status IN @lr_status.
    ENDIF.

    SORT lt_saida BY dt_criacao DESCENDING lgnum werks matnr ASCENDING.

    "passando para tabela de saida
    MOVE-CORRESPONDING lt_saida TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
      EXPORTING
        is_paging = is_paging
      CHANGING
        ct_data   = et_entityset
    ).

    LOOP AT it_order INTO DATA(ls_order).
      IF ls_order-property = 'CriadoPor'.
        ls_order-property = 'criado_por'.
      ENDIF.
      IF ls_order-property = 'HrCriacao'.
        ls_order-property = 'hr_criacao'.
      ENDIF.
      IF ls_order-property = 'DtCriacao'.
        ls_order-property = 'dt_criacao'.
      ENDIF.

      APPEND ls_order TO lt_order.
    ENDLOOP.

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = lt_order
      CHANGING
        ct_data  = et_entityset
    ).
  ENDMETHOD.


  METHOD zlmot021set_update_entity.
    "chaves primárias e entidade para saida
    DATA: lv_lgnum  TYPE zlmot021-lgnum,
          lv_werks  TYPE zlmot021-werks,
          lv_matnr  TYPE zlmot021-matnr,
          ls_entity TYPE zcl_zlmo_gw_008_mpc=>ts_zlmot021.

    "filtrando dados
    IF line_exists( it_key_tab[ name = 'Lgnum' ] ).
      lv_lgnum = it_key_tab[ name = 'Lgnum' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Werks' ] ).
      lv_werks = it_key_tab[ name = 'Werks' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Matnr' ] ).
      lv_matnr = it_key_tab[ name = 'Matnr' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "atualizando dados
    UPDATE zlmot021 SET ativo      = ls_entity-ativo
                        status     = ls_entity-status
                        criado_por = sy-uname
                        hr_criacao = sy-uzeit
                        dt_criacao = sy-datum
                    WHERE lgnum EQ lv_lgnum
                      AND werks EQ lv_werks
                      AND matnr EQ lv_matnr.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = 'E'
        iv_msg_id                 = '2'
        iv_msg_number             = '2'
        iv_msg_v1                 = 'Erro ao atualizar!'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ELSE.
      er_entity = ls_entity.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
