@AbapCatalog.sqlViewName: 'ZLMOV_I_ATENDIM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lista de Atendimentos'

@OData.publish: true

@UI: { headerInfo: { typeName: 'Atendimento', 
                     typeNamePlural: 'Lista de Atendimentos',
                     title: { type: #STANDARD, value: 'Nome'},
                     description.value: 'Id' },
       presentationVariant: [{ sortOrder: [{ by: 'Data', direction: #DESC }] }]}
define view ZLMOCDS_I_ATENDIM
  as select from zlmot_petatendim
  association [0..1] to zlmot_petcliente as _Cliente on Cliente = _Cliente.id
  association [0..*] to zlmo_i_item_atendimento as _Item on zlmot_petatendim.id = _Item.Id 
{

      @UI.facet: [
      {
        id: 'ValorTotal',
        purpose: #HEADER,
        type: #DATAPOINT_REFERENCE,
        position: 10,
        targetQualifier: 'ValueData'
       },
       {
        id: 'Status',
        purpose: #HEADER,
        type: #DATAPOINT_REFERENCE,
        position: 20,
        targetQualifier: 'StatusData'
       },
       //Facets do corpo
       {
        id: 'InfoGeral',
        purpose: #STANDARD,
        label: 'Informações Gerais',
        type: #COLLECTION,
        position: 10
       },
       {
        id: 'Cliente',
        purpose: #STANDARD,
        label: 'Dados do Cliente',
        type: #IDENTIFICATION_REFERENCE,
        position: 10,
        parentId: 'InfoGeral'
       },
       {
        id: 'Atendimento',
        purpose: #STANDARD,
        label: 'Dados do Atendimento',
        type: #FIELDGROUP_REFERENCE,
        position: 20,
        parentId: 'InfoGeral',
        targetQualifier: 'AtendimentoGroup'
       },
       {
        id: 'Item',
        purpose: #STANDARD,
        label: 'Itens',
        type: #LINEITEM_REFERENCE,
        position: 10,
        targetElement: '_Item'
       }]

      @UI: {lineItem:       [{ position: 10 }],
            selectionField: [{ position: 10 }]}
  key id            as Id,
      @UI: {lineItem:       [{ position: 20 }],
            selectionField: [{ position: 20 }],
            fieldGroup:     [{ qualifier: 'AtendimentoGroup', position: 10 }]}
      @EndUserText.label: 'Data do Atendimento'
      data          as Data,
      @UI: {lineItem:       [{ position: 30 }],
            selectionField: [{ position: 30 }],
            fieldGroup:     [{ qualifier: 'AtendimentoGroup', position: 30 }]}
      @EndUserText.label: 'Loja'
      loja          as Loja,
      @UI: {lineItem:       [{ position: 40 }],
            selectionField: [{ position: 40 }],
            identification: [{ position: 10 }]}
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZLMOCDS_I_CLIENTE', element: 'ID' }}]
      @EndUserText.label: 'ID do Cliente'
      cliente       as Cliente,
      @UI: {lineItem:       [{ position: 40 }],
            identification: [{ position: 20 }]}
      @EndUserText.label: 'Nome'
      _Cliente.nome as Nome,
      @UI: {lineItem:       [{ position: 50 }],
            selectionField: [{ position: 50 }]}
      status        as Status,

      @UI: {lineItem:       [{ position: 60 }],
            dataPoint: {title: 'Status', qualifier: 'StatusData'}}
      @EndUserText.label: 'Descrição Status'
      case status
      when 'I' then 'Iniciado'
      when 'F' then 'Finalizado'
      when 'C' then 'Cancelado'
      when 'A' then 'Agendado'
      end           as Status_txt,

      @UI: {lineItem:       [{ position: 70 }],
            selectionField: [{ position: 70 }],
            fieldGroup:     [{ qualifier: 'AtendimentoGroup', position: 20 }]}
      @EndUserText.label: 'Atendente'
      atendente     as Atendente,
      @UI: {lineItem:       [{ position: 80 }],
            dataPoint: { qualifier: 'ValueData', title: 'Valor Total' }}
      @EndUserText.label: 'Valor'
      //      @Semantics.currencyCode: true
      valor         as Valor,
      _Cliente,
      _Item
}
