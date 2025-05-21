@AbapCatalog.sqlViewName: 'ZCDSV_LMO_003'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Estudando Associations'
define view zcds_lmo_003
  as select from scarr
  association [1] to spfli as _scarr_to_spfli on $projection.Carrid = _scarr_to_spfli.carrid
{
  key carrid   as Carrid,
      carrname as Carrname,
      currcode as Currcode,
      url      as Url,
      _scarr_to_spfli // Make association public
}
