@EndUserText.label: 'Consume Ferramentas'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zcds_lmo_019
  as projection on zcds_lmo_018
{
  key Toolsid,
      Toolname,
      Lastchangedat
}
