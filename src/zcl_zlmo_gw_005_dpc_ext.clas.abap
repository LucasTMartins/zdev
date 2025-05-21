class ZCL_ZLMO_GW_005_DPC_EXT definition
  public
  inheriting from ZCL_ZLMO_GW_005_DPC
  create public .

public section.
protected section.

  methods ZCDS_LMO_013_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLMO_GW_005_DPC_EXT IMPLEMENTATION.


  METHOD zcds_lmo_013_get_entityset.
    if_sadl_gw_dpc_util~get_dpc( )->get_entityset( EXPORTING io_tech_request_context = io_tech_request_context
                                                   IMPORTING et_data                 = et_entityset
                                                             es_response_context     = es_response_context ).

    BREAK lmartins.
  ENDMETHOD.
ENDCLASS.
