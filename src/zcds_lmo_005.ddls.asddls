@AbapCatalog.sqlViewName: 'ZCDSV_LMO_005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view com parametro e where'
define view zcds_lmo_005
  with parameters
    p_moeda : abap.char( 3 )
  as select from scarr
{
  key carrid   as Carrid,
      carrname as Carrname,
      currcode as Currcode,
      url      as Url
}
where
  currcode = $parameters.p_moeda
