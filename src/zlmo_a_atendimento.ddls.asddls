@AbapCatalog.sqlViewName: 'ZLMOV_A_ATENDIM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Análise de Atendimentos'

@OData.publish: true

@UI: { 
    chart: [
        {
            title: 'Valor Atendimento por Loja',
            chartType: #COLUMN,
            qualifier: 'chartDefault',
            dimensions: [ 'Loja' ],
            measures: [ 'Valor' ],
            dimensionAttributes: [
                { dimension: 'Loja', role: #SERIES }
            ],
            measureAttributes: [
                { measure: 'Valor', role: #AXIS_1 }
            ]
        }
    ],
    headerInfo: {typeName: 'Atendimento', typeNamePlural: 'Atendimentos'},
    presentationVariant: [
        {
            qualifier: 'Default',
            text: 'Default',
            sortOrder: [
                { by: 'Valor', direction: #ASC }
            ],
            includeGrandTotal: false,
            initialExpansionLevel: 0,
            visualizations: [ {type: #AS_CHART, qualifier: 'chartDefault'} ]
        }
    ],
    selectionPresentationVariant: [{ 
        qualifier: 'Default',
        presentationVariantQualifier: 'Default',
        selectionVariantQualifier: 'Default'
     }]
}
define view ZLMO_A_ATENDIMENTO
  as select from zlmot_petatendim
  association [0..1] to zlmot_petcliente        as _Cliente on Cliente = _Cliente.id
  association [0..*] to zlmo_i_item_atendimento as _Item    on zlmot_petatendim.id = _Item.Id
{
      @UI: {
        lineItem: [
              { position: 10, label: 'Data do atendimento', value: 'Data' },
              { position: 20, label: 'Loja',                value: 'Loja' },
              { position: 30, label: 'Atendente',           value: 'Atendente' },
              { position: 40, label: 'Id',                  value: 'Id' },
              { position: 50, label: 'Descrição Status',    value: 'Status_txt' },
              { position: 60, label: 'ID do Cliente',       value: 'Cliente' },
              { position: 70, label: 'Nome',                value: 'Nome' },
              { position: 80, label: 'Valor',               value: 'Valor' }
          ]}
          
      @UI.selectionField: [{ position: 10 }]
      @EndUserText.label: 'Id'
  key id            as IdAtendi,
      @UI.selectionField: [{ position: 70 }]
      @EndUserText.label: 'Data'
      data          as Data,
      @UI.selectionField: [{ position: 20 }]
      @EndUserText.label: 'Loja'
      loja          as Loja,
      @UI.selectionField: [{ position: 50 }]
      @EndUserText.label: 'Cliente'
      cliente       as Cliente,
      @UI.selectionField: [{ position: 60 }]
      @EndUserText.label: 'Nome'
      _Cliente.nome as Nome,
      status        as Status,

      @UI.selectionField: [{ position: 30 }]
      @EndUserText.label: 'Status'
      case status
      when 'I' then 'Iniciado'
      when 'F' then 'Finalizado'
      when 'C' then 'Cancelado'
      when 'A' then 'Agendado'
      end           as Status_txt,

      @UI.selectionField: [{ position: 40 }]
      @EndUserText.label: 'Atendente'
      atendente     as Atendente,
      
      @DefaultAggregation: #SUM
      valor         as Valor,
      _Cliente,
      _Item
}
