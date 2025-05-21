class ZCL_ZLMO_GW_002_MPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_002_MPC
  create public .

public section.

  types:
    BEGIN OF ts_companhiahorariodeep,
             carrid                     TYPE scarr-carrid,
             CompanhiaDeepToHorarioDeep TYPE TABLE OF ts_horariodeep WITH DEFAULT KEY,
           END OF ts_companhiahorariodeep .

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_002_MPC_EXT IMPLEMENTATION.


  METHOD define.
    super->define( ).

    model->get_entity_type( 'CompanhiaDeep' )->bind_structure( iv_structure_name = 'ZCL_ZLMO_GW_002_MPC_EXT=>TS_COMPANHIAHORARIODEEP' ).
  ENDMETHOD.
ENDCLASS.
