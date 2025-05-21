@AbapCatalog.sqlViewName: 'ZLMOIMATNRVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa para campo material'
define view zlmo_i_matnr_vh
  as select from mara
    inner join   makt on  mara.matnr = makt.matnr
                      and spras      = $session.system_language
{
      @ObjectModel.text.element: [ 'Maktx' ]
      @UI.textArrangement: #TEXT_LAST
  key mara.matnr as Matnr,
      makt.maktx as Maktx
}
