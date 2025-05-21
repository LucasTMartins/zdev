@AbapCatalog.sqlViewName: 'ZCDSV_LMO_002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estudando joins'
define view zcds_lmo_002
  as select from spfli
    inner join   scarr on spfli.carrid = scarr.carrid
{
  @EndUserText.label: 'ID Comp. Aerea'
  key spfli.carrid    as Carrid,
  key spfli.connid    as Connid,
      scarr.carrname  as Carrname,
      scarr.currcode  as Currcode,
      scarr.url       as Url,
      spfli.countryfr as Countryfr,
      spfli.cityfrom  as Cityfrom,
      spfli.airpfrom  as Airpfrom,
      spfli.countryto as Countryto,
      spfli.cityto    as Cityto,
      spfli.airpto    as Airpto,
      spfli.fltime    as Fltime,
      spfli.deptime   as Deptime,
      spfli.arrtime   as Arrtime,
      spfli.distance  as Distance,
      spfli.distid    as Distid,
      spfli.fltype    as Fltype,
      spfli.period    as Period
}
