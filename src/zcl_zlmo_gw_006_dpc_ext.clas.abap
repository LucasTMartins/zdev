class ZCL_ZLMO_GW_006_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_006_DPC
  create public .

public section.
protected section.

  methods SCARRSET_CREATE_ENTITY
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
  methods SCARRSET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_006_DPC_EXT IMPLEMENTATION.


  METHOD scarrset_create_entity.
    DATA: ti_scarr  TYPE STANDARD TABLE OF scarr,
          ws_entity TYPE zcl_zlmo_gw_006_mpc=>ts_scarr.

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
      SELECT SINGLE carrid
        FROM scarr
        INTO  @DATA(lv_carrid)
        WHERE carrid EQ @ws_entity-carrid.

      IF sy-subrc IS INITIAL.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error
            message_container = me->mo_context->get_message_container( )
            message           = |Companhia Aérea: { ws_entity-carrid } já cadastrada.|.
      ELSE.
        INSERT scarr FROM ws_entity.

        IF sy-subrc IS INITIAL.
          er_entity = ws_entity.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD scarrset_delete_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    DATA(keys) = io_tech_request_context->get_keys( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
      WITH KEY name = 'CARRID'.

    IF <key> IS ASSIGNED.
      lv_carrid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'Id da Companhia Aérea não informado.'.
    ENDIF.

    DELETE FROM scarr WHERE carrid EQ lv_carrid.

    IF NOT sy-subrc is INITIAL.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message = |Erro ao Excluir registro de ID: { lv_carrid }|.
    ENDIF.
  ENDMETHOD.


  METHOD scarrset_get_entity.
    DATA: variavel_carrid TYPE scarr-carrid.

    DATA(keys) = io_tech_request_context->get_keys( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>)
      WITH KEY name = 'CARRID'.

    IF <key> IS ASSIGNED.
      variavel_carrid = <key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF er_entity
      FROM scarr
      WHERE carrid EQ variavel_carrid.
  ENDMETHOD.


  METHOD scarrset_get_entityset.
    DATA: filter_select_options TYPE /iwbep/t_mgw_select_option,
          range_carrid          TYPE RANGE OF scarr-carrid,
          range_carrname        TYPE RANGE OF scarr-carrname,
          wa_carrid             LIKE LINE OF range_carrid,
          wa_carrname           LIKE LINE OF range_carrname,
          sortorder             TYPE abap_sortorder_tab.

    filter_select_options = io_tech_request_context->get_filter( )->get_filter_select_options( ).
    LOOP AT filter_select_options ASSIGNING FIELD-SYMBOL(<filter_select_options>).
      LOOP AT <filter_select_options>-select_options ASSIGNING FIELD-SYMBOL(<select_options>).
        CASE <filter_select_options>-property.
          WHEN 'CARRID'.
            MOVE-CORRESPONDING <select_options> TO wa_carrid.
            APPEND wa_carrid TO range_carrid.
          WHEN 'CARRNAME'.
            MOVE-CORRESPONDING <select_options> TO wa_carrname.
            APPEND wa_carrname TO range_carrname.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    SELECT carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF TABLE et_entityset
      FROM scarr
      WHERE carrid   IN range_carrid
        AND carrname IN range_carrname.

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
    DATA: ws_entity TYPE zcl_zlmo_gw_006_mpc=>ts_scarr.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ws_entity
    ).

    IF ws_entity-carrid IS INITIAL.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = me->mo_context->get_message_container( )
          message           = 'Dados obrigatórios não informados'.
    ELSE.
      UPDATE scarr FROM ws_entity.

      IF sy-subrc IS INITIAL.
        er_entity = ws_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD spfliset_get_entity.
    DATA: lv_carrid TYPE spfli-carrid,
          lv_connid TYPE spfli-connid.

    data(keys) = io_tech_request_context->get_keys( ).

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

    SELECT SINGLE carrid, connid, countryfr, cityfrom, airpfrom,
                  countryto, cityto, airpto, fltime, deptime,
                  arrtime, distance, distid, fltype, period
      INTO @DATA(wa_spfli)
      FROM spfli
      WHERE carrid EQ @lv_carrid
        AND connid EQ @lv_connid.

      MOVE-CORRESPONDING wa_spfli TO er_entity.
    ENDMETHOD.


  METHOD spfliset_get_entityset.
    DATA: filter_select_options TYPE /iwbep/t_mgw_select_option,
          range_carrid          TYPE RANGE OF spfli-carrid,
          range_connid          TYPE RANGE OF spfli-connid,
          wa_carrid             LIKE LINE OF range_carrid,
          wa_connid             LIKE LINE OF range_connid.

    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<f_tab_key>)
      WITH KEY name = 'Carrid'.
    IF sy-subrc EQ 0.
      wa_carrid-sign = 'I'.
      wa_carrid-option = 'EQ'.
      wa_carrid-low = <f_tab_key>-value.
      APPEND wa_carrid TO range_carrid.
    ENDIF.

    filter_select_options = io_tech_request_context->get_filter( )->get_filter_select_options( ).
    LOOP AT filter_select_options ASSIGNING FIELD-SYMBOL(<filter_select_options>).
      READ TABLE <filter_select_options>-select_options ASSIGNING FIELD-SYMBOL(<select_options>) INDEX 1.

      CASE <filter_select_options>-property.
        WHEN 'CARRID'.
          MOVE-CORRESPONDING <select_options> TO wa_carrid.
          APPEND wa_carrid TO range_carrid.
        WHEN 'CONNID'.
          MOVE-CORRESPONDING <select_options> TO wa_connid.
          APPEND wa_connid TO range_connid.
      ENDCASE.
    ENDLOOP.

    SELECT carrid, connid, countryfr, cityfrom, airpfrom,
           countryto, cityto, airpto, fltime, deptime,
           arrtime, distance, distid, fltype, period
      INTO TABLE @DATA(t_entityset)
      FROM spfli
      WHERE carrid IN @range_carrid
        AND connid IN @range_connid.

    MOVE-CORRESPONDING t_entityset TO et_entityset.
  ENDMETHOD.
ENDCLASS.
