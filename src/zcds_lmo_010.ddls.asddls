@AbapCatalog.sqlViewName: 'ZCDSV_LMO_010'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS para Odata'
@OData.publish: true
define view zcds_lmo_010
  as select from spfli
    right outer join scarr on spfli.carrid = scarr.carrid
{
  @EndUserText.label: 'ID Comp. Aerea'
  key spfli.carrid    as Carrid,
  key spfli.connid    as Connid,
      spfli.countryfr as Countryfr,
      spfli.cityfrom  as Cityfrom,
      spfli.airpfrom  as Airpfrom,
      spfli.countryto as Countryto,
      spfli.cityto    as Cityto,
      spfli.airpto    as Airpto,
//      spfli.fltime    as Fltime,
      spfli.deptime   as Deptime,
      spfli.arrtime   as Arrtime,
      spfli.distance  as Distance,
      spfli.distid    as Distid,
      spfli.fltype    as Fltype,
      spfli.period    as Period
}
