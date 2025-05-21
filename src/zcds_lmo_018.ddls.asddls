@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Ferramentas'
define root view entity zcds_lmo_018
  as select from zlmot018
{
  key toolsid       as Toolsid,
      toolname      as Toolname,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchangedat as Lastchangedat
}
