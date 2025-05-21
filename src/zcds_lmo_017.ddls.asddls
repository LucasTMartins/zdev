@EndUserText.label: 'Consume Usuários e Ferramentas'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zcds_lmo_017
  as projection on zcds_lmo_015
{
  key Userid,
  key Toolsid,
      Toolname,
      Knowledge,
      Interest,
      Training,
      Lastchangedat,
      /* Associations */
      _user: redirected to parent zcds_lmo_016
}
