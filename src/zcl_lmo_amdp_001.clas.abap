CLASS zcl_lmo_amdp_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.
    CLASS-METHODS: get_flights FOR TABLE FUNCTION zcds_lmo_007.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lmo_amdp_001 IMPLEMENTATION.
  METHOD get_flights BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT USING scarr spfli.
    RETURN SELECT sc.mandt as client,
                  sc.carrid,
  sp.connid,
      sc.carrname,
      sc.currcode,
      sc.url,
      sp.countryfr,
      sp.airpfrom,
      sp.countryto,
      sp.cityfrom,
      sp.cityto
    from scarr as sc
    inner join spfli as sp
    on sc.carrid = sp.carrid;
  endmethod.

ENDCLASS.
