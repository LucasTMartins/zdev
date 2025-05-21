@EndUserText.label: 'CDS com Table Function'
define table function zcds_lmo_007
  with parameters
    @Environment.systemField: #CLIENT
    client : abap.clnt
returns
{
  key client    : abap.clnt;
  key carrid    : s_carrid;
  key connid    : s_conn_id;
      carrname  : s_carrname;
      currcode  : s_currcode;
      url       : s_url;
      countryfr : land1;
      airpfrom  : s_fromairp;
      countryto : land1;
      cityfrom  : s_from_cit;
      cityto    : s_to_city;
}
implemented by method
  zcl_lmo_amdp_001=>get_flights;
