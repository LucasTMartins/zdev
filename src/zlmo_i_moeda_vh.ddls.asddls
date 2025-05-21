@AbapCatalog.sqlViewName: 'ZLMOIMOEDAVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo de moeda'
define view zlmo_i_moeda_vh
  as select from tcurc
    inner join   tcurt on  tcurc.waers = tcurt.waers
                       and tcurt.spras = $session.system_language
{
      @ObjectModel.text.element: ['Ltext']
      @UI.textArrangement: #TEXT_LAST
  key tcurc.waers as Waers,
      tcurt.ltext as Ltext
}
