@AbapCatalog.sqlViewName: 'ZCDSLMOV_VH_TOOL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Tools'
@Search.searchable: true
define view zcdslmo_vh_tools
  as select from zlmot018
{
      @UI.hidden: true
  key toolsid  as Toolsid,
      @Search.defaultSearchElement: true
      toolname as Toolname
}
