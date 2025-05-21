@AbapCatalog.sqlViewName: 'ZCDSLMOV_VH_USER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Users'
@Search.searchable: true
define view zcdslmo_vh_users
  as select from zlmot016
{
  key userid as Userid,
      @Search.defaultSearchElement: true
      email  as Email
}
