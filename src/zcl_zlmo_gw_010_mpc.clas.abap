class ZCL_ZLMO_GW_010_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
    begin of TS_ADMPEDIDOSETTYPE.
      include type ZLMO_I_ADM_PEDIDOS.
  types:
    end of TS_ADMPEDIDOSETTYPE .
  types:
   TT_ADMPEDIDOSETTYPE type standard table of TS_ADMPEDIDOSETTYPE .
  types:
    begin of TS_ZLMO_I_BUKRS_VHTYPE.
      include type ZLMO_I_BUKRS_VH.
  types:
    end of TS_ZLMO_I_BUKRS_VHTYPE .
  types:
   TT_ZLMO_I_BUKRS_VHTYPE type standard table of TS_ZLMO_I_BUKRS_VHTYPE .
  types:
    begin of TS_ZLMO_I_CLIENT_VHTYPE.
      include type ZLMO_I_CLIENT_VH.
  types:
    end of TS_ZLMO_I_CLIENT_VHTYPE .
  types:
   TT_ZLMO_I_CLIENT_VHTYPE type standard table of TS_ZLMO_I_CLIENT_VHTYPE .
  types:
    begin of TS_ZLMO_I_MATNR_VHTYPE.
      include type ZLMO_I_MATNR_VH.
  types:
    end of TS_ZLMO_I_MATNR_VHTYPE .
  types:
   TT_ZLMO_I_MATNR_VHTYPE type standard table of TS_ZLMO_I_MATNR_VHTYPE .
  types:
    begin of TS_ZLMO_I_MOEDA_VHTYPE.
      include type ZLMO_I_MOEDA_VH.
  types:
    end of TS_ZLMO_I_MOEDA_VHTYPE .
  types:
   TT_ZLMO_I_MOEDA_VHTYPE type standard table of TS_ZLMO_I_MOEDA_VHTYPE .
  types:
    begin of TS_ZLMO_I_UM_VHTYPE.
      include type ZLMO_I_UM_VH.
  types:
    end of TS_ZLMO_I_UM_VHTYPE .
  types:
   TT_ZLMO_I_UM_VHTYPE type standard table of TS_ZLMO_I_UM_VHTYPE .

  constants GC_ADMPEDIDOSETTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AdmPedidoSetType' ##NO_TEXT.
  constants GC_ZLMO_I_BUKRS_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'zlmo_i_bukrs_vhType' ##NO_TEXT.
  constants GC_ZLMO_I_CLIENT_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'zlmo_i_client_vhType' ##NO_TEXT.
  constants GC_ZLMO_I_MATNR_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'zlmo_i_matnr_vhType' ##NO_TEXT.
  constants GC_ZLMO_I_MOEDA_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'zlmo_i_moeda_vhType' ##NO_TEXT.
  constants GC_ZLMO_I_UM_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'zlmo_i_um_vhType' ##NO_TEXT.

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZCL_ZLMO_GW_010_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZLMO_GW_010_SRV' ).

define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
    TRY.
        if_sadl_gw_model_exposure_data~get_model_exposure( )->expose( model )->expose_vocabulary( vocab_anno_model ).
      CATCH cx_sadl_exposure_error INTO DATA(lx_sadl_exposure_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
          EXPORTING
            previous = lx_sadl_exposure_error.
    ENDTRY.
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20241010170849'.                  "#EC NOTEXT
 DATA: lv_rds_last_modified TYPE timestamp .
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
 lv_rds_last_modified =  GET_LAST_MODIFIED_RDS_4( ).
 IF rv_last_modified LT lv_rds_last_modified.
 rv_last_modified  = lv_rds_last_modified .
 ENDIF .
  endmethod.


  method GET_LAST_MODIFIED_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
*    @@TYPE_SWITCH:
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20241010200849'.
    TRY.
        rv_last_modified_rds = CAST cl_sadl_gw_model_exposure( if_sadl_gw_model_exposure_data~get_model_exposure( ) )->get_last_modified( ).
      CATCH cx_root ##CATCH_ALL.
        rv_last_modified_rds = co_gen_date_time.
    ENDTRY.
    IF rv_last_modified_rds < co_gen_date_time.
      rv_last_modified_rds = co_gen_date_time.
    ENDIF.
  endmethod.


  method IF_SADL_GW_MODEL_EXPOSURE_DATA~GET_MODEL_EXPOSURE.
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20241010200849'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="" >|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_ADM_PEDIDOS" binding="ZLMO_I_ADM_PEDIDOS" />|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_BUKRS_VH" binding="ZLMO_I_BUKRS_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_CLIENT_VH" binding="ZLMO_I_CLIENT_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_MATNR_VH" binding="ZLMO_I_MATNR_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_MOEDA_VH" binding="ZLMO_I_MOEDA_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZLMO_I_UM_VH" binding="ZLMO_I_UM_VH" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="AdmPedidoSet" dataSource="ZLMO_I_ADM_PEDIDOS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="zlmo_i_bukrs_vh" dataSource="ZLMO_I_BUKRS_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="zlmo_i_client_vh" dataSource="ZLMO_I_CLIENT_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="zlmo_i_matnr_vh" dataSource="ZLMO_I_MATNR_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="zlmo_i_moeda_vh" dataSource="ZLMO_I_MOEDA_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="zlmo_i_um_vh" dataSource="ZLMO_I_UM_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZLMO_GW_010' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.
ENDCLASS.
