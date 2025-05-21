@AbapCatalog.sqlViewName: 'ZCDSLMOV_VH_UUSR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Unique Users'
define view zcdslmo_vh_unique_user
  as select from zlmot016
{
  key userid as Userid,
      @Search.defaultSearchElement: true
      email  as Email
} where userid = $session.user
