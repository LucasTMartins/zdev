@AbapCatalog.sqlViewName: 'ZLMOV_VH_MATNR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Matnr'
define view ZLMO_VH_MATNR
  as select from mara
    inner join   makt on  mara.matnr = makt.matnr
                      and spras      = $session.system_language
{
  key mara.matnr,
      makt.maktx
}
