@AbapCatalog.sqlViewName: 'ZLMOV_I_ITEM_AT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Itens atendimento'
define view zlmo_i_item_atendimento
  as select from zlmot_petiatendi
  association [0..1] to zlmot_petproduto as _Produto on produto_id = _Produto.id
{
  key id                 as Id,
      item_id            as ItemId,
      @UI.lineItem: [{ position: 10 }]
      @EndUserText.label: 'ID de Produto'
      produto_id         as ProdutoId,
      @UI.lineItem: [{ position: 20 }]
      @EndUserText.label: 'Descrição'
      _Produto.descricao as Descricao,
      @UI.lineItem: [{ position: 30 }]
      @EndUserText.label: 'Quantidade'
      quantidade         as Quantidade,
      @UI.lineItem: [{ position: 40 }]
      @EndUserText.label: 'Valor'
      valor              as Valor
}
