@AbapCatalog.sqlViewName: 'ZLMOSTATUSVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo de moeda'
define view zlmo_i_status_vh
  as select from dd07v
{
  key valpos as Valpos,
      @ObjectModel.text.element: ['DocCtgText']
  key domvalue_l as DocCtg,
      @Semantics.text: true
      ddtext     as DocCtgText
}
where
      domname    = 'ZLMO_E_STATUS2'
  and ddlanguage = $session.system_language
