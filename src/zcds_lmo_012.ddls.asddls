@AbapCatalog.sqlViewName: 'ZCDSV_LMO_012'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS para association LFA1 e outra CDS'
@OData.publish: true
define view zcds_lmo_012
  as select from lfa1
  association [*] to zcds_lmo_011 as _lfa1_to_zcds_lmo_011 on $projection.Lifnr = _lfa1_to_zcds_lmo_011.Lifnr
{
  key lifnr as Lifnr,
      name1 as Name1,
      land1 as Land1,
      _lfa1_to_zcds_lmo_011 // Make association public
} where lifnr like 'EWM%'
