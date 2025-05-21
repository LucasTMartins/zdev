@AbapCatalog.sqlViewName: 'ZLMOIADMPEDIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Administração de Pedidos'
@Metadata.allowExtensions: true

@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true

@ObjectModel.createEnabled: true
@ObjectModel.updateEnabled: true
@ObjectModel.deleteEnabled: true

@ObjectModel.writeActivePersistence: 'ZLMOT023'
@ObjectModel.semanticKey: [ 'NumPedido' ]

@OData.publish: true // Para publicar serviço OData
@OData.entitySet.name: 'AdmPedidoSet'

@Search.searchable: true // Para adicionar campos de pesquisa

define view zlmo_i_adm_pedidos
  as select from zlmot023
{
      @Search: {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.9,
        ranking : #HIGH
      }
      @UI.lineItem: [{ position: 10, label: '{i18n>lineItemTableNumPedidoColumn}' }]
//      @EndUserText.label: '{i18n>lineItemTableNumPedidoColumn}'
      @ObjectModel.readOnly: true
  key num_pedido    as NumPedido,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'Matnr', name: 'ZLMO_I_MATNR_VH' } }]
      @Search: {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.7
      }
      @UI: {
        lineItem: [{ position: 20, label: '{i18n>lineItemTableMatnrColumn}' }],
        selectionField: [{ position: 22 }],
        textArrangement: #TEXT_LAST
      }
//      @EndUserText.label: '[{i18n>lineItemTableMatnrColumn}]'
      //@ObjectModel.text.element: ['Descricao']
      material      as Material,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'Bukrs', name: 'ZLMO_I_BUKRS_VH' } }]
      @Search: { 
        defaultSearchElement: true, 
        fuzzinessThreshold: 0.7 
      }
      @UI: {
        lineItem: [{ position: 30, label: '{i18n>lineItemTableBukrsColumn}' }],
        selectionField: [{ position: 33 }]
      }
//      @EndUserText.label: '{i18n>lineItemTableBukrsColumn}'
      empresa       as Empresa,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'Kunnr', name: 'ZLMO_I_CLIENT_VH' } }]
      @Search: { 
        defaultSearchElement: true, 
        fuzzinessThreshold: 1 
      }
      @UI.lineItem: [{ position: 40, label: '{i18n>lineItemTableKunnrColumn}' }]
//      @EndUserText.label: '{i18n>lineItemTableKunnrColumn}'
      cliente       as Cliente,

      @UI.lineItem: [{ position: 50, label: '{i18n>lineItemTableDescricaoColumn}' }]
      @EndUserText.label: 'Description'
      descricao     as Descricao,

      @UI.lineItem: [{ position: 60, label: '{i18n>lineItemTableQuantidadeColumn}' }]
//      @EndUserText.label: '{i18n>lineItemTableQuantidadeColumn}'
      @Semantics.quantity.unitOfMeasure: 'Um'
      quantidade    as Quantidade,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'Mseh3', name: 'ZLMO_I_UM_VH' } }]
      um            as Um,

      @UI.lineItem: [{ position: 70, label: '{i18n>lineItemTableValLiqColumn}' }]
      @EndUserText.label: 'Net Value'
      @Semantics.amount.currencyCode: 'Moeda'
      valor_liquido as ValorLiquido,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'Waers', name: 'ZLMO_I_MOEDA_VH' } }]
      moeda         as Moeda,

      @UI.lineItem: [{ position: 80, label: '{i18n>lineItemTableDtDocumentoColumn}' }]
//      @EndUserText.label: '{i18n>lineItemTableDtDocumentoColumn}'
      dt_documento  as DtDocumento,

      @Search: { 
        defaultSearchElement: true, 
        fuzzinessThreshold: 1, 
        ranking : #HIGH 
      }
      @UI: {
        lineItem: [{ position: 90, label: '{i18n>lineItemTableStatusColumn}' }]
//        hidden: true
      }
//      @EndUserText.label: '{i18n>lineItemTableStatusColumn}'
      //      case status_pedido
      //      when 'L' then 'Liberado'
      //      when 'P' then 'Pendente'
      //      when 'R' then 'Reprovado'
      //      when 'E' then 'Estornado'
      //      else 'Código Inválido!'
      //      end           as StatusPedido
      status_pedido as StatusPedido
}
