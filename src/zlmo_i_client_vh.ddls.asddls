@AbapCatalog.sqlViewName: 'ZLMOICLIENTVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo cliente'
define view zlmo_i_client_vh
  as select from kna1
{
      @ObjectModel.text.element: ['Name1']
      @UI.textArrangement: #TEXT_LAST
  key kna1.kunnr as Kunnr,
      kna1.name1 as Name1
}
