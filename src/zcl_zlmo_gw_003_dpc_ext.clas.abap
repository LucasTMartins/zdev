class ZCL_ZLMO_GW_003_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_003_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods CLIENTESET_GET_ENTITY
    redefinition .
  methods CLIENTESET_GET_ENTITYSET
    redefinition .
  methods PRODUTOSET_GET_ENTITY
    redefinition .
  methods PRODUTOSET_GET_ENTITYSET
    redefinition .
  methods PVENDASET_CREATE_ENTITY
    redefinition .
  methods PVENDASET_DELETE_ENTITY
    redefinition .
  methods PVENDASET_GET_ENTITY
    redefinition .
  methods PVENDASET_GET_ENTITYSET
    redefinition .
  methods PVENDASET_UPDATE_ENTITY
    redefinition .
  methods VENDASET_CREATE_ENTITY
    redefinition .
  methods VENDASET_DELETE_ENTITY
    redefinition .
  methods VENDASET_GET_ENTITY
    redefinition .
  methods VENDASET_GET_ENTITYSET
    redefinition .
  methods VENDASET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_003_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    CONSTANTS: lc_id                 TYPE string  VALUE 'Id',
               lc_prioridade         TYPE string  VALUE 'Prioridade',
               lc_alterar_status     TYPE string  VALUE 'alterarStatus',
               lc_alterar_prioridade TYPE string  VALUE 'alterarPrioridade',
               lc_e                  TYPE c       VALUE 'E',
               lc_symsgid_one        TYPE symsgid VALUE '1',
               lc_symsgno_one        TYPE symsgno VALUE '1',
               lc_domnam             TYPE dd01l-domname VALUE 'ZLMO_D_PRIORIDADE_VENDA',
               BEGIN OF lc_msg,
                 campo_id          TYPE symsgv VALUE 'Campo Id não encontrado',
                 campo_prior       TYPE symsgv VALUE 'Campo Prioridade não encontrado',
                 id_nao_encontrado TYPE symsgv VALUE 'Valor de Id não existe na tabela',
                 atualizar         TYPE symsgv VALUE 'Ocorreu um erro durante a atualização da tabela',
                 prioridade        TYPE symsgv VALUE 'Valor de prioridade inválido',
               END OF lc_msg.
    DATA: lv_id         TYPE string,
          lv_prioridade TYPE string,
          ls_return     TYPE zlmo_t_venda.

    IF line_exists( it_parameter[ name = lc_id ] ).
      lv_id = it_parameter[ name = lc_id ]-value.
    ELSE.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-campo_id
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    SELECT SINGLE *
      FROM zlmo_t_venda
      INTO @DATA(ls_venda)
      WHERE id EQ @lv_id.

    IF ls_venda IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_nao_encontrado
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    CASE iv_action_name.
      WHEN lc_alterar_status.
        IF ls_venda-ativo EQ abap_true.
          ls_venda-ativo = space.
        ELSE.
          ls_venda-ativo = abap_true.
        ENDIF.
      WHEN lc_alterar_prioridade.
        DATA: lv_domvalue TYPE dd07d-domvalue.

        IF line_exists( it_parameter[ name = lc_prioridade ] ).
          lv_prioridade = it_parameter[ name = lc_prioridade ]-value.
        ELSE.
          me->mo_context->get_message_container( )->add_message(
            iv_msg_type               = lc_e
            iv_msg_id                 = lc_symsgid_one
            iv_msg_number             = lc_symsgno_one
            iv_msg_v1                 = lc_msg-campo_prior
          ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = me->mo_context->get_message_container( ).
        ENDIF.

        "convertendo prioridade para valor compatível com domvalue
        lv_domvalue = lv_prioridade.
        SHIFT lv_domvalue LEFT DELETING LEADING space.

        "verificando se o valor de propriedade é válido
        CALL FUNCTION 'FM_DOMAINVALUE_CHECK'
          EXPORTING
            i_domname         = lc_domnam
            i_domvalue        = lv_domvalue
          EXCEPTIONS
            input_error       = 1
            value_not_allowed = 2
            OTHERS            = 3.

        "caso a prioridade seja inválida
        IF sy-subrc <> 0.
          me->mo_context->get_message_container( )->add_message(
            iv_msg_type               = lc_e
            iv_msg_id                 = lc_symsgid_one
            iv_msg_number             = lc_symsgno_one
            iv_msg_v1                 = lc_msg-prioridade
          ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = me->mo_context->get_message_container( ).
        ENDIF.

        ls_venda-prioridade = lv_prioridade.
      WHEN OTHERS.
        TRY.
            CALL METHOD super->/iwbep/if_mgw_appl_srv_runtime~execute_action
              EXPORTING
                iv_action_name          = iv_action_name
                it_parameter            = it_parameter
                io_tech_request_context = io_tech_request_context
              IMPORTING
                er_data                 = er_data.
          CATCH /iwbep/cx_mgw_busi_exception.
          CATCH /iwbep/cx_mgw_tech_exception.
        ENDTRY.
    ENDCASE.

    "atualizando a tabela z
    UPDATE zlmo_t_venda FROM ls_venda.

    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-atualizar
      ).

      ROLLBACK WORK.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    COMMIT WORK.
    MOVE-CORRESPONDING ls_venda TO ls_return.

    IF ls_return IS NOT INITIAL.
      me->copy_data_to_ref(
        EXPORTING
          is_data = ls_return
        CHANGING
          cr_data = er_data
      ).
    ENDIF.
  ENDMETHOD.


  METHOD clienteset_get_entity.
    DATA: lv_id TYPE zlmo_t_cliente-id.

    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmo_t_cliente
      INTO @DATA(ls_cliente)
      WHERE id EQ @lv_id.

    MOVE-CORRESPONDING ls_cliente TO er_entity.
  ENDMETHOD.


  METHOD clienteset_get_entityset.
    DATA: lr_id TYPE RANGE OF zlmo_t_cliente-id.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Id'.
          lr_id = VALUE #( FOR id IN ls_filter-select_options ( CORRESPONDING #( id ) ) ).
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM zlmo_t_cliente
      INTO TABLE @DATA(lt_cliente)
      WHERE id IN @lr_id.

    MOVE-CORRESPONDING lt_cliente TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
      EXPORTING
        is_paging = is_paging
      CHANGING
        ct_data   = et_entityset
    ).

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = it_order
      CHANGING
        ct_data  = et_entityset
    ).
  ENDMETHOD.


  method PRODUTOSET_GET_ENTITY.
    DATA: lv_id TYPE zlmo_t_produto-id.

    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmo_t_produto
      INTO @DATA(ls_produto)
      WHERE id EQ @lv_id.

    MOVE-CORRESPONDING ls_produto TO er_entity.
  endmethod.


  METHOD produtoset_get_entityset.
    DATA: lr_id TYPE RANGE OF zlmo_t_produto-id.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Id'.
          lr_id = VALUE #( FOR id IN ls_filter-select_options ( CORRESPONDING #( id ) ) ).
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM zlmo_t_produto
      INTO TABLE @DATA(lt_produto)
      WHERE id IN @lr_id.

    MOVE-CORRESPONDING lt_produto TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
      EXPORTING
        is_paging = is_paging
      CHANGING
        ct_data   = et_entityset
    ).

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = it_order
      CHANGING
        ct_data  = et_entityset
    ).
  ENDMETHOD.


  METHOD pvendaset_create_entity.
    CONSTANTS: lc_e           TYPE c             VALUE 'E',
               lc_symsgid_one TYPE symsgid       VALUE '1',
               lc_symsgno_one TYPE symsgno       VALUE '1',
               BEGIN OF lc_msg,
                 id_venda           TYPE symsgv VALUE 'Id_venda vazio',
                 venda_nao_existe   TYPE symsgv VALUE 'Venda não existe na tabela de vendas',
                 id_produto         TYPE symsgv VALUE 'Id_produto vazio',
                 produto_nao_existe TYPE symsgv VALUE 'Produto não existe na tabela de produtos',
                 quantidade         TYPE symsgv VALUE 'Quantidade vazia ou menor que zero',
                 cadastro           TYPE symsgv VALUE 'Erro ao cadastrar',
               END OF lc_msg.
    "Entidade para saida
    DATA: ls_entity TYPE zcl_zlmo_gw_003_mpc=>ts_pvenda.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "caso o id_venda esteja vazio
    IF ls_entity-id_venda IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_venda
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se a venda existe na tabela venda
    SELECT SINGLE id
      FROM zlmo_t_venda
      INTO @DATA(ls_venda)
      WHERE id EQ @ls_entity-id_venda.

    "caso a venda não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-venda_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso o id_produto esteja vazio
    IF ls_entity-id_produto IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_produto
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se o cliente existe na tabela cliente
    SELECT SINGLE id
      FROM zlmo_t_produto
      INTO @DATA(ls_produto)
      WHERE id EQ @ls_entity-id_produto.

    "caso o cliente não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-produto_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso a quantidade esteja vazia ou seja igual a zero
    IF ls_entity-quantidade IS INITIAL OR ls_entity-quantidade LT 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-quantidade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "passando alterações
    INSERT zlmo_t_pvenda FROM ls_entity.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cadastro
      ).

      ROLLBACK WORK.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    COMMIT WORK.
    er_entity = ls_entity.
  ENDMETHOD.


  METHOD pvendaset_delete_entity.
    "chaves primárias
    DATA: lv_id TYPE zlmo_t_pvenda-id.

    "filtrando dados
    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    "deletando dados
    DELETE FROM zlmo_t_pvenda WHERE id EQ lv_id.

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
    ENDIF.
  ENDMETHOD.


  METHOD pvendaset_get_entity.
    "chave primária
    DATA: lv_id TYPE zlmo_t_pvenda-id.

    "filtrando os dados necessários
    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmo_t_pvenda
      INTO @DATA(ls_pvenda)
      WHERE id EQ @lv_id.

    "passando para a tabela de saida
    MOVE-CORRESPONDING ls_pvenda TO er_entity.
  ENDMETHOD.


  METHOD pvendaset_get_entityset.
    "chaves primárias
    DATA: lr_id          TYPE RANGE OF zlmo_t_pvenda-id,
          lr_id_venda    TYPE RANGE OF zlmo_t_pvenda-id_venda,
          lr_id_produto TYPE RANGE OF zlmo_t_pvenda-id_produto.

    "passando filtros
    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Id'.
          lr_id = VALUE #( FOR id IN ls_filter-select_options ( CORRESPONDING #( id ) ) ).
        WHEN 'IdVenda'.
          lr_id_venda = VALUE #( FOR id_venda IN ls_filter-select_options ( CORRESPONDING #( id_venda ) ) ).
        WHEN 'IdProduto'.
          lr_id_produto = VALUE #( FOR id_produto IN ls_filter-select_options ( CORRESPONDING #( id_produto ) ) ).
      ENDCASE.
    ENDLOOP.

    "buscando dados condizentes ao filtro
    SELECT *
      FROM zlmo_t_pvenda
      INTO TABLE @DATA(lt_pvenda)
      WHERE id IN @lr_id.

    "passando para tabela de saida
    MOVE-CORRESPONDING lt_pvenda TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
      EXPORTING
        is_paging = is_paging
      CHANGING
        ct_data   = et_entityset
    ).

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = it_order
      CHANGING
        ct_data  = et_entityset
    ).
  ENDMETHOD.


  METHOD pvendaset_update_entity.
    CONSTANTS: lc_e           TYPE c             VALUE 'E',
               lc_symsgid_one TYPE symsgid       VALUE '1',
               lc_symsgno_one TYPE symsgno       VALUE '1',
               BEGIN OF lc_msg,
                 id_venda           TYPE symsgv VALUE 'Id_venda vazio',
                 venda_nao_existe   TYPE symsgv VALUE 'Venda não existe na tabela de vendas',
                 id_produto         TYPE symsgv VALUE 'Id_produto vazio',
                 produto_nao_existe TYPE symsgv VALUE 'Produto não existe na tabela de produtos',
                 quantidade         TYPE symsgv VALUE 'Quantidade vazia ou menor que zero',
                 cadastro           TYPE symsgv VALUE 'Erro ao cadastrar',
               END OF lc_msg.
    "chaves primárias e entidade para saida
    DATA: lv_id     TYPE zlmo_t_pvenda-id,
          ls_entity TYPE zcl_zlmo_gw_003_mpc=>ts_pvenda.

    "filtrando dados
    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "caso o id_venda esteja vazio
    IF ls_entity-id_venda IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_venda
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se a venda existe na tabela venda
    SELECT SINGLE id
      FROM zlmo_t_venda
      INTO @DATA(ls_venda)
      WHERE id EQ @ls_entity-id_venda.

    "caso a venda não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-venda_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso o id_produto esteja vazio
    IF ls_entity-id_produto IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_produto
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se o cliente existe na tabela cliente
    SELECT SINGLE id
      FROM zlmo_t_produto
      INTO @DATA(ls_produto)
      WHERE id EQ @ls_entity-id_produto.

    "caso o cliente não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-produto_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso a quantidade esteja vazia ou seja igual a zero
    IF ls_entity-quantidade IS INITIAL OR ls_entity-quantidade LT 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-quantidade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "atualizando dados
    UPDATE zlmo_t_pvenda SET id_venda   = ls_entity-id_venda
                             id_produto = ls_entity-id_produto
                             quantidade = ls_entity-quantidade
                             WHERE id EQ lv_id.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cadastro
      ).

      ROLLBACK WORK.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.


  METHOD vendaset_create_entity.
    CONSTANTS: lc_e           TYPE c             VALUE 'E',
               lc_symsgid_one TYPE symsgid       VALUE '1',
               lc_symsgno_one TYPE symsgno       VALUE '1',
               lc_domnam      TYPE dd01l-domname VALUE 'ZLMO_D_PRIORIDADE_VENDA',
               BEGIN OF lc_msg,
                 validade           TYPE symsgv VALUE 'Data de validade expirada',
                 cadastro           TYPE symsgv VALUE 'Erro ao cadastrar',
                 prioridade         TYPE symsgv VALUE 'Valor de prioridade inválido',
                 id_cliente         TYPE symsgv VALUE 'Id_cliente vazio',
                 cliente_nao_existe TYPE symsgv VALUE 'Cliente não existe na tabela de clientes',
               END OF lc_msg.
    DATA: ls_entity   TYPE zcl_zlmo_gw_003_mpc=>ts_venda,
          lv_domvalue TYPE dd07d-domvalue.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "caso a validade já tenha expirado
    IF ls_entity-dt_validade < sy-datum.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-validade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "convertendo prioridade para valor compatível com domvalue
    lv_domvalue = ls_entity-prioridade.
    SHIFT lv_domvalue LEFT DELETING LEADING space.

    "verificando se o valor de propriedade é válido
    CALL FUNCTION 'FM_DOMAINVALUE_CHECK'
      EXPORTING
        i_domname         = lc_domnam
        i_domvalue        = lv_domvalue
      EXCEPTIONS
        input_error       = 1
        value_not_allowed = 2
        OTHERS            = 3.

    "caso a prioridade seja inválida
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-prioridade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso o id_cliente esteja vazio
    IF ls_entity-id_cliente IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_cliente
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se o cliente existe na tabela cliente
    SELECT SINGLE id
      FROM zlmo_t_cliente
      INTO @DATA(ls_cliente)
      WHERE id EQ @ls_entity-id_cliente.

    "caso o cliente não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cliente_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "inserindo valor na tabela z
    INSERT zlmo_t_venda FROM ls_entity.

    IF sy-subrc NE 0. "retornando mensagem de erro caso o cadastro tenha falhado
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cadastro
      ).

      ROLLBACK WORK.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    COMMIT WORK.
    er_entity = ls_entity. "retornando cadastro caso tenha sido um sucesso
  ENDMETHOD.


  METHOD vendaset_delete_entity.
    DATA: lv_id TYPE zlmo_t_venda-id.

    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    DELETE FROM zlmo_t_venda WHERE id EQ lv_id.

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
    ENDIF.
  ENDMETHOD.


  METHOD vendaset_get_entity.
    DATA: lv_id TYPE zlmo_t_venda-id.

    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmo_t_venda
      INTO @DATA(ls_venda)
      WHERE id EQ @lv_id.

    MOVE-CORRESPONDING ls_venda TO er_entity.
  ENDMETHOD.


  METHOD vendaset_get_entityset.
    DATA: lr_id          TYPE RANGE OF zlmo_t_venda-id,
          lr_prioridade  TYPE RANGE OF zlmo_t_venda-prioridade,
          lr_ativo       TYPE RANGE OF zlmo_t_venda-ativo,
          lr_dt_validade TYPE RANGE OF zlmo_t_venda-dt_validade,
          lr_id_cliente  TYPE RANGE OF zlmo_t_venda-id_cliente.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Id'.
          lr_id = VALUE #( FOR id IN ls_filter-select_options ( CORRESPONDING #( id ) ) ).
        WHEN 'Prioridade'.
          lr_prioridade = VALUE #( FOR prioridade IN ls_filter-select_options ( CORRESPONDING #( prioridade ) ) ).
        WHEN 'Ativo'.
          lr_ativo = VALUE #( FOR ativo IN ls_filter-select_options ( CORRESPONDING #( ativo ) ) ).
        WHEN 'Dt_validade'.
          lr_dt_validade = VALUE #( FOR dt_validade IN ls_filter-select_options ( CORRESPONDING #( dt_validade ) ) ).
        WHEN 'Id_cliente'.
          lr_id_cliente = VALUE #( FOR id_cliente IN ls_filter-select_options ( CORRESPONDING #( id_cliente ) ) ).
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM zlmo_t_venda
      INTO TABLE @DATA(lt_venda)
      WHERE id IN @lr_id
        AND prioridade IN @lr_prioridade
        AND ativo IN @lr_ativo
        AND dt_validade IN @lr_dt_validade
        AND id_cliente IN @lr_id_cliente.

    MOVE-CORRESPONDING lt_venda TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
      EXPORTING
        is_paging = is_paging
      CHANGING
        ct_data   = et_entityset
    ).

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = it_order
      CHANGING
        ct_data  = et_entityset
    ).
  ENDMETHOD.


  METHOD vendaset_update_entity.
    CONSTANTS: lc_e           TYPE c             VALUE 'E',
               lc_symsgid_one TYPE symsgid       VALUE '1',
               lc_symsgno_one TYPE symsgno       VALUE '1',
               lc_domnam      TYPE dd01l-domname VALUE 'ZLMO_D_PRIORIDADE_VENDA',
               BEGIN OF lc_msg,
                 validade           TYPE symsgv VALUE 'Data de validade expirada',
                 cadastro           TYPE symsgv VALUE 'Erro ao cadastrar',
                 prioridade         TYPE symsgv VALUE 'Valor de prioridade inválido',
                 id_cliente         TYPE symsgv VALUE 'Id_cliente vazio',
                 cliente_nao_existe TYPE symsgv VALUE 'Cliente não existe na tabela de clientes',
               END OF lc_msg.
    DATA: lv_id       TYPE zlmo_t_venda-id,
          ls_entity   TYPE zcl_zlmo_gw_003_mpc=>ts_venda,
          lv_domvalue TYPE dd07d-domvalue.

    IF line_exists( it_key_tab[ name = 'Id' ] ).
      lv_id = it_key_tab[ name = 'Id' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "caso a validade já tenha expirado
    IF ls_entity-dt_validade < sy-datum.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-validade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "convertendo prioridade para valor compatível com domvalue
    lv_domvalue = ls_entity-prioridade.
    SHIFT lv_domvalue LEFT DELETING LEADING space.

    "verificando se o valor de propriedade é válido
    CALL FUNCTION 'FM_DOMAINVALUE_CHECK'
      EXPORTING
        i_domname         = lc_domnam
        i_domvalue        = lv_domvalue
      EXCEPTIONS
        input_error       = 1
        value_not_allowed = 2
        OTHERS            = 3.

    "caso a prioridade seja inválida
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-prioridade
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "caso o id_cliente esteja vazio
    IF ls_entity-id_cliente IS INITIAL.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-id_cliente
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    "buscando se o cliente existe na tabela cliente
    SELECT SINGLE id
      FROM zlmo_t_cliente
      INTO @DATA(ls_cliente)
      WHERE id EQ @ls_entity-id_cliente.

    "caso o cliente não exista na tabela
    IF sy-subrc <> 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cliente_nao_existe
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    UPDATE zlmo_t_venda SET id_cliente  = ls_entity-id_cliente
                            descricao   = ls_entity-descricao
                            dt_validade = ls_entity-dt_validade
                            criado_em   = ls_entity-criado_em
                            prioridade  = ls_entity-prioridade
                            ativo       = ls_entity-ativo
                            WHERE id EQ lv_id.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = lc_e
        iv_msg_id                 = lc_symsgid_one
        iv_msg_number             = lc_symsgno_one
        iv_msg_v1                 = lc_msg-cadastro
      ).

      ROLLBACK WORK.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
