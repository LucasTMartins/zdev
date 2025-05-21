@AbapCatalog.sqlViewName: 'ZLMOIBUKRSVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo empresa'
define view zlmo_i_bukrs_vh
  as select from t001
{
      @ObjectModel.text.element: ['Butxt']
      @UI.textArrangement: #TEXT_LAST
  key bukrs as Bukrs,
      butxt as Butxt
}
