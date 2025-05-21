class ZCL_ZLMO_GW_010_01_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_010_01_DPC
  create public .

public section.
protected section.

  methods SCARRSET_CREATE_ENTITY
    redefinition .
  methods SCARRSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_010_01_DPC_EXT IMPLEMENTATION.


  METHOD scarrset_create_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    DATA(lv_keys) = io_tech_request_context->get_source_keys( ).

    READ TABLE lv_keys ASSIGNING FIELD-SYMBOL(<lfs_key>) WITH KEY name = 'CARRID'.

    IF <lfs_key> IS ASSIGNED.
      lv_carrid = <lfs_key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF er_entity
      FROM scarr
      WHERE carrid EQ lv_carrid.
  ENDMETHOD.


  METHOD scarrset_get_entity.
    DATA: lv_carrid TYPE scarr-carrid.

    DATA(lv_keys) = io_tech_request_context->get_keys( ).

    READ TABLE lv_keys ASSIGNING FIELD-SYMBOL(<lfs_key>) WITH KEY name = 'CARRID'.

    IF <lfs_key> IS ASSIGNED.
      lv_carrid = <lfs_key>-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF er_entity
      FROM scarr
      WHERE carrid EQ lv_carrid.
  ENDMETHOD.
ENDCLASS.
