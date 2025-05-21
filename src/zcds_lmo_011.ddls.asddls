@AbapCatalog.sqlViewName: 'ZCDSV_LMO_011'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS para association entre EKKO e EKPO'
define view zcds_lmo_011
  as select from ekko
  association [*] to ekpo as _ekko_to_ekpo on $projection.Ebeln = _ekko_to_ekpo.ebeln
{
  key ebeln as Ebeln,
      ekorg as Ekorg,
      lifnr as Lifnr,
      _ekko_to_ekpo // Make association public
}
