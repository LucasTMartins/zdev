class ZCL_ZLMO_GW_009_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_009_DPC
  create public .

public section.
protected section.

  methods ADMPEDIDOSET_CREATE_ENTITY
    redefinition .
  methods ADMPEDIDOSET_DELETE_ENTITY
    redefinition .
  methods ADMPEDIDOSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_009_DPC_EXT IMPLEMENTATION.


  METHOD admpedidoset_create_entity.
    SET PARAMETER ID 'SADL_DDIC_CRUD_MODE' FIELD 'X'.

    DATA: ls_entity TYPE zcl_zlmo_gw_009_mpc=>ts_admpedidosettype,
          ls_pedido TYPE zlmot023.
    io_data_provider->read_entry_data(
    IMPORTING es_data = ls_entity
    ).

    SELECT num_pedido
      FROM zlmot023
      INTO TABLE @DATA(gt_num_pedido)
      ORDER BY num_pedido DESCENDING.

    IF sy-subrc = 0.
      ls_pedido-num_pedido = ( gt_num_pedido[ 1 ]-num_pedido ) + 1.
    ELSE.
      ls_pedido-num_pedido = 1.
      ls_pedido-num_pedido = |{ ls_pedido-num_pedido ALPHA = IN }|.
    ENDIF.

    ls_pedido-material = ls_entity-material.
    ls_pedido-empresa = ls_entity-empresa.
    ls_pedido-cliente = ls_entity-cliente.
    ls_pedido-descricao = ls_entity-descricao.
    ls_pedido-quantidade = ls_entity-quantidade.
    ls_pedido-um = ls_entity-um.
    ls_pedido-valor_bruto = ( ls_entity-valorliquido + ( ls_entity-valorliquido * 15 ) / 100 ).
    ls_pedido-valor_liquido = ls_entity-valorliquido.
    ls_pedido-valor_c_desconto = ( ls_entity-valorliquido - ( ls_entity-valorliquido * 20 ) / 100 ).
    ls_pedido-moeda = ls_entity-moeda.
    ls_pedido-status_pedido = 'P'.
    ls_pedido-dt_documento = sy-datum.
    ls_pedido-hr_criacao = sy-uzeit.
    ls_pedido-criado_por = sy-uname.
    INSERT zlmot023 FROM ls_pedido.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  METHOD admpedidoset_delete_entity.
    SET PARAMETER ID 'SADL_DDIC_CRUD_MODE' FIELD 'X'.

    DATA(lt_keys) = io_tech_request_context->get_keys( ).

    READ TABLE lt_keys INTO DATA(gs_keys) WITH KEY name = 'NUMPEDIDO'.

    DELETE FROM zlmot023 WHERE num_pedido = gs_keys-value.
    IF sy-subrc <> 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  METHOD admpedidoset_update_entity.
    SET PARAMETER ID 'SADL_DDIC_CRUD_MODE' FIELD 'X'.

    DATA: ls_entity TYPE zcl_zlmo_gw_009_mpc=>ts_admpedidosettype,
          ls_pedido TYPE zlmot023.

    io_data_provider->read_entry_data(
      IMPORTING es_data = ls_entity
    ).

    ls_pedido-num_pedido        = ls_entity-numpedido.
    ls_pedido-material          = ls_entity-material.
    ls_pedido-empresa           = ls_entity-empresa.
    ls_pedido-cliente           = ls_entity-cliente.
    ls_pedido-descricao         = ls_entity-descricao.
    ls_pedido-quantidade        = ls_entity-quantidade.
    ls_pedido-um                = ls_entity-um.
    ls_pedido-valor_bruto       = ( ls_entity-valorliquido + ( ls_entity-valorliquido * 15 ) / 100 ).
    ls_pedido-valor_liquido     = ls_entity-valorliquido.
    ls_pedido-valor_c_desconto  = ( ls_entity-valorliquido - ( ls_entity-valorliquido * 20 ) / 100 ).
    ls_pedido-moeda             = ls_entity-moeda.
    ls_pedido-status_pedido     = ls_entity-statuspedido.
    ls_pedido-dt_documento      = ls_entity-dtdocumento.
    MODIFY zlmot023 FROM ls_pedido.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
