@AbapCatalog.sqlViewName: 'ZLMOV_I_CLIENTE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lista de Clientes'
define view ZLMOCDS_I_CLIENTE
  as select from zlmot_petcliente
{
  key id       as Id,
      nome     as Nome,
      sexo     as Sexo,
      rua      as Rua,
      cep      as Cep,
      cidade   as Cidade,
      uf       as Uf,
      nro_pets as NroPets
}
