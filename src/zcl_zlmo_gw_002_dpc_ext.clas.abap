class ZCL_ZLMO_GW_002_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_002_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods COMPANHIAAEREASE_CREATE_ENTITY
    redefinition .
  methods COMPANHIAAEREASE_DELETE_ENTITY
    redefinition .
  methods COMPANHIAAEREASE_GET_ENTITY
    redefinition .
  methods COMPANHIAAEREASE_GET_ENTITYSET
    redefinition .
  methods COMPANHIAAEREASE_UPDATE_ENTITY
    redefinition .
  methods HORARIOVOOSET_CREATE_ENTITY
    redefinition .
  methods HORARIOVOOSET_DELETE_ENTITY
    redefinition .
  methods HORARIOVOOSET_GET_ENTITY
    redefinition .
  methods HORARIOVOOSET_GET_ENTITYSET
    redefinition .
  methods HORARIOVOOSET_UPDATE_ENTITY
    redefinition .
  methods VOOSSET_CREATE_ENTITY
    redefinition .
  methods VOOSSET_DELETE_ENTITY
    redefinition .
  methods VOOSSET_GET_ENTITY
    redefinition .
  methods VOOSSET_GET_ENTITYSET
    redefinition .
  methods VOOSSET_UPDATE_ENTITY
    redefinition .
private section.

  methods COMPANHIAHORARIO_DEEP_ENTITY
    importing
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      !IO_EXPAND type ref to /IWBEP/IF_MGW_ODATA_EXPAND
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C
    exporting
      !ER_DEEP_ENTITY type ZCL_ZLMO_GW_002_MPC_EXT=>TS_COMPANHIAHORARIODEEP .
ENDCLASS.



CLASS ZCL_ZLMO_GW_002_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY.
    DATA: ls_companhiahorario_deep TYPE zcl_zlmo_gw_002_mpc_ext=>ts_companhiahorariodeep.

    CASE iv_entity_name.
      WHEN 'CompanhiaDeep'.
        me->companhiahorario_deep_entity(
          EXPORTING
            io_data_provider        = io_data_provider
            it_key_tab              = it_key_tab
            it_navigation_path      = it_navigation_path
            io_expand               = io_expand
            io_tech_request_context = io_tech_request_context
          IMPORTING
            er_deep_entity          = ls_companhiahorario_deep
        ).

        copy_data_to_ref(
          EXPORTING
            is_data = ls_companhiahorario_deep
          CHANGING
            cr_data = er_deep_entity
        ).

*    	WHEN .
*    	WHEN OTHERS.
    ENDCASE.
  endmethod.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

    DATA: lv_printname TYPE string,
          lv_document  TYPE string,
          ls_return    TYPE bapiret2.

    IF line_exists( it_parameter[ name = 'PrinterName' ] ).
      lv_printname = it_parameter[ name = 'PrinterName' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_parameter[ name = 'Document' ] ).
      lv_document = it_parameter[ name = 'Document' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    CASE iv_action_name.
      WHEN 'zf_lmo_print_001'.
        ls_return-message = 'Deu certo'.
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

    IF ls_return IS NOT INITIAL.
      me->copy_data_to_ref(
        EXPORTING
          is_data = ls_return
        CHANGING
          cr_data = er_data
      ).
    ENDIF.
  ENDMETHOD.


  METHOD companhiaaerease_create_entity.
    DATA: ls_entity TYPE zcl_zlmo_gw_002_mpc=>ts_companhiaaerea.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    INSERT zlmot012 FROM ls_entity.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = 'E'
        iv_msg_id                 = '1'
        iv_msg_number             = '1'
        iv_msg_v1                 = 'Erro ao cadastrar'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ELSE.
      er_entity = ls_entity.
    ENDIF.
  ENDMETHOD.


  METHOD companhiaaerease_delete_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    DELETE FROM zlmot012 WHERE carrid EQ lv_carrid.

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
      "Deletando da tabela de voos
      DELETE FROM zlmot013 WHERE carrid = lv_carrid.

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

      "Deletando da tabela de horário de voos
      DELETE FROM zlmot014 WHERE carrid = lv_carrid.

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
    ENDIF.
  ENDMETHOD.


  METHOD companhiaaerease_get_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM scarr
      INTO @er_entity
      WHERE carrid EQ @lv_carrid.
  ENDMETHOD.


  METHOD companhiaaerease_get_entityset.
    CONSTANTS: lc_carrid(6)   TYPE c VALUE 'Carrid',
               lc_currcode(8) TYPE c VALUE 'Currcode'.
    DATA: lr_carrid TYPE RANGE OF scarr-carrid.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN lc_carrid.
          lr_carrid = VALUE #( FOR carrid IN ls_filter-select_options ( CORRESPONDING #( carrid ) ) ).
        WHEN lc_currcode.
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM scarr
      INTO TABLE @et_entityset
      WHERE carrid IN @lr_carrid.

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


  METHOD companhiaaerease_update_entity.
    DATA: lv_carrid TYPE scarr-carrid,
          ls_entity TYPE zcl_zlmo_gw_002_mpc=>ts_companhiaaerea.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    UPDATE zlmot012 SET carrname = ls_entity-carrname
                        currcode = ls_entity-currcode
                        url      = ls_entity-url
                        WHERE carrid EQ lv_carrid.

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


  METHOD companhiahorario_deep_entity.
    DATA: ls_deep_entity TYPE zcl_zlmo_gw_002_mpc_ext=>ts_companhiahorariodeep,
          lt_spfli       TYPE STANDARD TABLE OF spfli.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_deep_entity
    ).

    lt_spfli = VALUE #( FOR item IN ls_deep_entity-companhiadeeptohorariodeep WHERE ( carrid eq ls_deep_entity-carrid ) ( CORRESPONDING #( item ) ) ).

    IF lt_spfli IS NOT INITIAL.
      INSERT zlmot014 FROM TABLE lt_spfli.

      IF sy-subrc NE 0.
        me->mo_context->get_message_container( )->add_message(
          iv_msg_type               = 'E'
          iv_msg_id                 = '1'
          iv_msg_number             = '1'
          iv_msg_v1                 = 'Erro ao cadastrar'
        ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = me->mo_context->get_message_container( ).
      ELSE.
        er_deep_entity = ls_deep_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD horariovooset_create_entity.
    DATA: ls_entity TYPE zcl_zlmo_gw_002_mpc=>ts_horariovoo,
          ls_spfli  TYPE spfli.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    MOVE-CORRESPONDING ls_entity TO ls_spfli.

    INSERT zlmot014 FROM ls_spfli.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = 'E'
        iv_msg_id                 = '1'
        iv_msg_number             = '1'
        iv_msg_v1                 = 'Erro ao cadastrar'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ELSE.
      er_entity = ls_entity.
    ENDIF.
  ENDMETHOD.


  METHOD horariovooset_delete_entity.
    DATA: lv_carrid TYPE spfli-carrid,
          lv_connid TYPE spfli-connid.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    DELETE FROM zlmot014 WHERE carrid EQ lv_carrid.

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
      "Deletando da tabela de voos
      DELETE FROM zlmot013 WHERE carrid = lv_carrid
                             AND connid = lv_connid.

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
    ENDIF.
  ENDMETHOD.


  METHOD horariovooset_get_entity.
    DATA: lv_carrid TYPE spfli-carrid,
          lv_connid TYPE spfli-connid.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM spfli
      INTO @DATA(ls_spfli)
      WHERE carrid EQ @lv_carrid
        AND connid EQ @lv_connid.

    MOVE-CORRESPONDING ls_spfli TO er_entity.
  ENDMETHOD.


  METHOD horariovooset_get_entityset.
    DATA: lr_carrid TYPE RANGE OF spfli-carrid,
          lr_connid TYPE RANGE OF spfli-connid.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Carrid'.
          lr_carrid = VALUE #( FOR carrid IN ls_filter-select_options ( CORRESPONDING #( carrid ) ) ).
        WHEN 'Connid'.
          lr_connid = VALUE #( FOR connid IN ls_filter-select_options ( CORRESPONDING #( connid ) ) ).
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM spfli
      INTO TABLE @DATA(lt_spfli)
      WHERE carrid IN @lr_carrid
        AND connid IN @lr_connid.

    MOVE-CORRESPONDING lt_spfli TO et_entityset.

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


  METHOD horariovooset_update_entity.
    DATA: lv_carrid TYPE spfli-carrid,
          lv_connid TYPE spfli-connid,
          ls_entity TYPE zcl_zlmo_gw_002_mpc=>ts_horariovoo.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    UPDATE zlmot014 SET countryfr = ls_entity-countryfr
                        cityfrom  = ls_entity-cityfrom
                        airpfrom  = ls_entity-airpfrom
                        countryto = ls_entity-countryto
                        cityto    = ls_entity-cityto
                        airpto    = ls_entity-airpto
                        fltime    = ls_entity-fltime
                        deptime   = ls_entity-deptime
                        arrtime   = ls_entity-arrtime
                        distance  = ls_entity-distance
                        distid    = ls_entity-distid
                        fltype    = ls_entity-fltype
                        period    = ls_entity-period
                        WHERE carrid EQ lv_carrid
                          AND connid EQ lv_connid.

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


  method VOOSSET_CREATE_ENTITY.
    DATA: ls_entity TYPE ZCL_ZLMO_GW_002_MPC=>TS_VOOS.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    INSERT zlmot013 FROM ls_entity.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = 'E'
        iv_msg_id                 = '1'
        iv_msg_number             = '1'
        iv_msg_v1                 = 'Erro ao cadastrar'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ELSE.
      er_entity = ls_entity.
    ENDIF.
  endmethod.


  method VOOSSET_DELETE_ENTITY.
    DATA: lv_carrid TYPE sflight-carrid,
          lv_connid TYPE sflight-connid,
          lv_fldate TYPE sflight-fldate.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Fldate' ] ).
      lv_fldate = it_key_tab[ name = 'Fldate' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    DELETE FROM zlmot013 WHERE carrid EQ lv_carrid.

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
  endmethod.


  METHOD voosset_get_entity.
    DATA: lv_carrid TYPE sflight-carrid,
          lv_connid TYPE sflight-connid,
          lv_fldate TYPE sflight-fldate.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Fldate' ] ).
      lv_fldate = it_key_tab[ name = 'Fldate' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM sflight
      INTO @er_entity
      WHERE carrid EQ @lv_carrid
        AND connid EQ @lv_connid
        AND fldate EQ @lv_fldate.
  ENDMETHOD.


  METHOD voosset_get_entityset.
    DATA: lr_carrid TYPE RANGE OF sflight-carrid,
          lr_connid TYPE RANGE OF sflight-connid,
          lr_fldate TYPE RANGE OF sflight-fldate.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Carrid'.
          lr_carrid = VALUE #( FOR carrid IN ls_filter-select_options ( CORRESPONDING #( carrid ) ) ).
        WHEN 'Connid'.
          lr_connid = VALUE #( FOR connid IN ls_filter-select_options ( CORRESPONDING #( connid ) ) ).
        WHEN 'Fldate'.
          lr_fldate = VALUE #( FOR fldate IN ls_filter-select_options ( CORRESPONDING #( fldate ) ) ).
      ENDCASE.
    ENDLOOP.

    SELECT *
      FROM sflight
      INTO TABLE @et_entityset
      WHERE carrid IN @lr_carrid
        AND connid IN @lr_connid
        AND fldate IN @lr_fldate.

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


  METHOD voosset_update_entity.
    DATA: lv_carrid TYPE sflight-carrid,
          lv_connid TYPE sflight-connid,
          lv_fldate TYPE sflight-fldate,
          ls_entity TYPE zcl_zlmo_gw_002_mpc=>ts_voos.

    IF line_exists( it_key_tab[ name = 'Carrid' ] ).
      lv_carrid = it_key_tab[ name = 'Carrid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Connid' ] ).
      lv_connid = it_key_tab[ name = 'Connid' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    IF line_exists( it_key_tab[ name = 'Fldate' ] ).
      lv_fldate = it_key_tab[ name = 'Fldate' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    UPDATE zlmot013 SET currency   = ls_entity-currency
                        price      = ls_entity-price
                        paymentsum = ls_entity-paymentsum
                        planetype  = ls_entity-planetype
                        seatsmax   = ls_entity-seatsmax
                        seatsmax_b = ls_entity-seatsmax_b
                        seatsmax_f = ls_entity-seatsmax_f
                        seatsocc   = ls_entity-seatsocc
                        seatsocc_b = ls_entity-seatsocc_b
                        seatsocc_f = ls_entity-seatsocc_f
                        WHERE carrid EQ lv_carrid
                          AND connid EQ lv_connid
                          AND fldate EQ lv_fldate.

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
