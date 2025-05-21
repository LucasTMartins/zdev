@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HUs que entraram na câmara fria'
@Metadata.allowExtensions: true
define root view entity zlmo_i_hu_camara
  as select from zlmot024
{
  key huident      as Huident,
      data_criacao as DataCriacao,
      hora_criacao as HoraCriacao,
      usuario      as Usuario
}
