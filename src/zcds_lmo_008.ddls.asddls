@AbapCatalog.sqlViewAppendName: 'ZCDSV_LMO_008'
@EndUserText.label: 'CDS extension'
extend view zcds_lmo_003 with zcds_lmo_008
{
  _scarr_to_spfli.cityfrom,
  _scarr_to_spfli.cityto
}
