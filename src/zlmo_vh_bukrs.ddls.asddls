@AbapCatalog.sqlViewName: 'ZLMOV_VH_BUKRS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Bukrs'
define view ZLMO_VH_BUKRS
  as select from t001
{
  key bukrs      as Bukrs,
      butxt      as Butxt,
      ort01      as Ort01,
      t001.waers as Currency,
      t001.spras as Language
}
