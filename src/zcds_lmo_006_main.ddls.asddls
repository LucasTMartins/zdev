@AbapCatalog.sqlViewName: 'ZCDSV_LMO_006_M'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source para zcds_lmo_006'
define view zcds_lmo_006_main
  as select from zlmot015
  association [0..1] to zcds_lmo_006_main as _manager on $projection.ManagerId = _manager.EmpId
{
  key emp_id      as EmpId,
      emp_name    as EmpName,
      manager_id  as ManagerId,
      cost_center as CostCenter,
      _manager
}
