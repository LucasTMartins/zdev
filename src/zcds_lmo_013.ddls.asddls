@AbapCatalog.sqlViewName: 'ZCDSV_LMO_013'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório Base Conhecimento'

@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.createEnabled: true
@ObjectModel.updateEnabled: true
@ObjectModel.deleteEnabled: true
@ObjectModel.writeActivePersistence: 'zlmot016'

@OData.publish: true
define view zcds_lmo_013
  as select from zlmot016 as _user
  association [0..*] to zlmot017 as _user_tools on $projection.Userid = _user_tools.userid
{
      @UI: {
        lineItem:       [{ position: 10 }],
        selectionField: [{ position: 10 }]
      }
      @Consumption.valueHelpDefinition: [{ entity: {name: 'zcdslmo_vh_users', element: 'Userid'}}]
  key _user.userid          as Userid,
      @UI: {
        lineItem:       [{ position: 20 }],
        selectionField: [{ position: 20 }]
      }
      @Consumption.valueHelpDefinition: [{ entity: {name: 'zcdslmo_vh_users', element: 'Email'}}]
      _user.email           as Email,
      @UI.lineItem: [{ position: 30 }]
      _user.fullname        as Fullname,
      @UI: {
        lineItem:       [{ position: 40, label: 'Tool' }],
        selectionField: [{ position: 30 }]
      }
      @Consumption.valueHelpDefinition: [{ entity: {name: 'zcdslmo_vh_tools', element: 'Toolname'}}]
      @EndUserText.label: 'Tool'
      _user_tools.toolname  as Toolname,
      @UI.lineItem: [{ position: 50 }]
      _user_tools.knowledge as Knowledge,
      @UI.lineItem: [{ position: 60 }]
      _user_tools.interest  as Interest,
      @UI: {
        lineItem:       [{ position: 70, label: 'Training' }],
        selectionField: [{ position: 40 }]
      }
      @EndUserText.label: 'Training'
      _user_tools.training  as Training,
      
      _user_tools
}
