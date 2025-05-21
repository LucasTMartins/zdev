@EndUserText.label: 'HUs que entraram na câmara fria'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define root view entity zlmo_c_hu_camara
  provider contract transactional_query
  as projection on zlmo_i_hu_camara
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'HU'
      @UI.selectionField: [{ position: 10 }]
  key Huident,
      @EndUserText.label: 'Data de Criação'
      DataCriacao,
      @EndUserText.label: 'Horário de Criação'
      HoraCriacao,
      @EndUserText.label: 'Usuário'
      Usuario
}
