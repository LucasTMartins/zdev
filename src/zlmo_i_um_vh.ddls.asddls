@AbapCatalog.sqlViewName: 'ZLMOIUMVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo de UM'
define view zlmo_i_um_vh
  as select distinct from t006a
{
  key t006a.spras as Spras,
  key t006a.msehi as Msehi,
      @ObjectModel.text.element: ['Mseht']
      @UI.textArrangement: #TEXT_LAST
      t006a.mseh3 as Mseh3,
      t006a.mseht as Mseht
} where spras = $session.system_language
