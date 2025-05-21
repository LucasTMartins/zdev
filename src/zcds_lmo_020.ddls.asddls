@AbapCatalog.sqlViewName: 'ZCDSV_LMO_020'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testando CDS'

@ObjectModel: {
    modelCategory: #BUSINESS_OBJECT,
    compositionRoot: true,
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    writeActivePersistence: 'zlmot019'
}


@OData.publish: true
define view zcds_lmo_020
  as select from zlmot019 as _order
{
  key num_pedido       as NumPedido,
  key material         as Material,
  key empresa          as Empresa,
  key cliente          as Cliente,
      descricao        as Descricao,
      quantidade       as Quantidade,
      um               as Um,
      valor_bruto      as ValorBruto,
      valor_liquido    as ValorLiquido,
      valor_c_desconto as ValorCDesconto,
      moeda            as Moeda,
      status           as Status,
      dt_documento     as DtDocumento,
      hr_criacao       as HrCriacao,
      criado_por       as CriadoPor
}
