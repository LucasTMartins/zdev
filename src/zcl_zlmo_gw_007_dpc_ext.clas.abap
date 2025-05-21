class ZCL_ZLMO_GW_007_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_007_DPC
  create public .

public section.
protected section.

  methods SCARRSET_CREATE_ENTITY
    redefinition .
  methods SCARRSET_DELETE_ENTITY
    redefinition .
  methods SCARRSET_GET_ENTITY
    redefinition .
  methods SCARRSET_GET_ENTITYSET
    redefinition .
  methods SCARRSET_UPDATE_ENTITY
    redefinition .
  methods SPFLISET_GET_ENTITY
    redefinition .
  methods SPFLISET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_007_DPC_EXT IMPLEMENTATION.


  METHOD scarrset_create_entity.
    DATA: ws_entity TYPE zcl_zlmo_gw_007_mpc=>ts_scarr.

    " Pegando as entradas do usuário
    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ws_entity
    ).

    " Validando se os dados obrigatórios foram informados
    IF ws_entity-carrid IS INITIAL.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'Dados obrigatórios não informados.'.

    ELSE.

      SELECT SINGLE carrid
               FROM scarr
               INTO @DATA(lv_carrid)
               WHERE carrid EQ @ws_entity-carrid.

      " Validando se a companhia aérea já existe
      IF sy-subrc EQ 0.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_container = me->mo_context->get_message_container( )
            message           = |Companhia aérea: { ws_entity-carrid } já cadastrada|.
      ELSE.

        " Inseridos novos valores
        INSERT scarr FROM ws_entity.

        " Retornando a entidade criada na resposta da requisição
        IF sy-subrc EQ 0.
          er_entity = ws_entity.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD scarrset_delete_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    DATA(keys) = io_tech_request_context->get_keys( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>) WITH KEY name = 'CARRID'.
    IF <key> IS ASSIGNED.
      lv_carrid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'ID da companhia aérea não informada.'.
    ENDIF.

    DELETE FROM scarr WHERE carrid EQ lv_carrid.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = |Erro ao excluir registro de ID: { lv_carrid }|.
    ENDIF.
  ENDMETHOD.


  METHOD scarrset_get_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    DATA(keys) = io_tech_request_context->get_keys( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
      WITH KEY name = 'CARRID'.

    IF <key> IS ASSIGNED.
      lv_carrid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF er_entity
      FROM scarr
      WHERE carrid EQ lv_carrid.
  ENDMETHOD.


  METHOD scarrset_get_entityset.
    DATA: filter_select_options TYPE /iwbep/t_mgw_select_option,
          lr_carrid             TYPE RANGE OF scarr-carrid,
          lr_carrname           TYPE RANGE OF scarr-carrname,
          wa_carrid             LIKE LINE OF lr_carrid,
          wa_carrname           LIKE LINE OF lr_carrname,
          sortorder             TYPE abap_sortorder_tab.

    filter_select_options = io_tech_request_context->get_filter( )->get_filter_select_options( ).
    LOOP AT filter_select_options ASSIGNING FIELD-SYMBOL(<fielter_select_options>).

      LOOP AT <fielter_select_options>-select_options ASSIGNING FIELD-SYMBOL(<select_options>).
        CASE <fielter_select_options>-property.
          WHEN 'CARRID'.
            MOVE-CORRESPONDING <select_options> TO wa_carrid.
            APPEND wa_carrid TO lr_carrid.
          WHEN 'CARRNAME'.
            MOVE-CORRESPONDING <select_options> TO wa_carrname.
            APPEND wa_carrname TO lr_carrname.
        ENDCASE.
      ENDLOOP.

    ENDLOOP.

    SELECT carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      FROM scarr
      WHERE carrid IN lr_carrid
        AND carrname IN lr_carrname.

    LOOP AT it_order ASSIGNING FIELD-SYMBOL(<order>).

      APPEND INITIAL LINE TO sortorder ASSIGNING FIELD-SYMBOL(<sortorder>).

      <sortorder>-name = <order>-property.

      IF <order>-order = 'desc'.
        <sortorder>-descending = abap_true.
      ENDIF.

    ENDLOOP.

    SORT et_entityset BY (sortorder).
  ENDMETHOD.


  METHOD scarrset_update_entity.
    DATA: ws_entity TYPE zcl_zlmo_gw_007_mpc=>ts_scarr.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ws_entity
    ).

    IF ws_entity-carrid IS INITIAL.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'Dados obrigatórios não informados.'.

    ELSE.

      UPDATE scarr FROM ws_entity.

      IF sy-subrc EQ 0.
        er_entity = ws_entity.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  method SPFLISET_GET_ENTITY.
    DATA: lv_carrid TYPE spfli-carrid,
          lv_connid TYPE spfli-connid.

    DATA(keys) = io_tech_request_context->get_keys( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
      WITH KEY name = 'CARRID'.
    IF <key> IS ASSIGNED.
      lv_carrid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    READ TABLE keys ASSIGNING <key>
  WITH KEY name = 'CONNID'.
    IF <key> IS ASSIGNED.
      lv_connid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE carrid, connid, countryfr, cityfrom, airpfrom, countryto, cityto, airpto, fltime, deptime, arrtime, distance, distid, fltype, period
      INTO @DATA(wa_spfli)
      FROM spfli
      WHERE carrid EQ @lv_carrid
        AND connid EQ @lv_connid.

    MOVE-CORRESPONDING wa_spfli TO er_entity.
  endmethod.


  METHOD spfliset_get_entityset.
    DATA: filter_select_options TYPE /iwbep/t_mgw_select_option,
          lr_carrid             TYPE RANGE OF spfli-carrid,
          lr_connid             TYPE RANGE OF spfli-connid,
          wa_carrid             LIKE LINE OF lr_carrid,
          wa_connid             LIKE LINE OF lr_connid.

    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<f_tab_key>) WITH KEY name = 'Carrid'.
    IF sy-subrc EQ 0.
      wa_carrid-sign = 'I'.

      wa_carrid-option = 'EQ'.
      wa_carrid-low = <f_tab_key>-value.
      APPEND wa_carrid TO lr_carrid.
    ENDIF.

    filter_select_options = io_tech_request_context->get_filter( )->get_filter_select_options( ).
    LOOP AT filter_select_options ASSIGNING FIELD-SYMBOL(<fielter_select_options>).

      READ TABLE <fielter_select_options>-select_options ASSIGNING FIELD-SYMBOL(<select_options>) INDEX 1.
      CASE <fielter_select_options>-property.
        WHEN 'CARRID'.
          MOVE-CORRESPONDING <select_options> TO wa_carrid.
          APPEND wa_carrid TO lr_carrid.
        WHEN 'CONNID'.
          MOVE-CORRESPONDING <select_options> TO wa_connid.
          APPEND wa_connid TO lr_connid.
      ENDCASE.

    ENDLOOP.

    SELECT carrid, connid, countryfr, cityfrom, airpfrom, countryto, cityto, airpto, fltime, deptime, arrtime, distance, distid, fltype, period
      INTO TABLE @DATA(lt_entityset)
      FROM spfli
      WHERE carrid IN @lr_carrid
        AND connid IN @lr_connid.

    MOVE-CORRESPONDING lt_entityset TO et_entityset.
  ENDMETHOD.
ENDCLASS.
