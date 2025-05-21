@AbapCatalog.sqlViewName: 'ZLMOV_I_VENDAS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Overview Page de vendas'

@OData: {
    publish: true,
    entitySet.name: 'PedidoSet'
}

@Search.searchable: true

define view zlmo_i_vendas
  as select from zlmot019
{
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 } // 10% (0.1) -- 70% (0.7) -- 0.1 to 1
      @EndUserText.label: 'Pedido'
      @UI.selectionField: [{ position: 10 }]
  key num_pedido       as NumPedido,
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZLMO_VH_MATNR', element: 'matnr' } }]
      @UI.selectionField: [{ position: 20 }]
  key material         as Material,
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZLMO_VH_BUKRS', element: 'CompanyCode' } }]
      @UI.selectionField: [{ position: 30 }]
  key empresa          as Empresa,
      @UI.selectionField: [{ position: 40 }]
  key cliente          as Cliente,
      descricao        as Descricao,
      @Semantics.amount.currencyCode: 'Um'
      @Aggregation.default: #SUM
      quantidade       as Quantidade,
      um               as Um,
      @Semantics.amount.currencyCode: 'Moeda'
      @Aggregation.default: #SUM
      valor_bruto      as ValorBruto,
      @Semantics.amount.currencyCode: 'Moeda'
      @Aggregation.default: #SUM
      valor_liquido    as ValorLiquido,
      @Semantics.amount.currencyCode: 'Moeda'
      @Aggregation.default: #SUM
      valor_c_desconto as ValorCDesconto,
      moeda            as Moeda,
      status           as Status,

      case status
      when '1' then 'Em processamento'
      when '2' then 'Finalizado'
      end as Status_txt,
      
      @UI.selectionField: [{ position: 40 }]
      dt_documento     as DtDocumento
}
