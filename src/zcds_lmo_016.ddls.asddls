@EndUserText.label: 'Consume Usuários'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zcds_lmo_016
  as projection on zcds_lmo_014
{
  key Userid,
      Email,
      Fullname,
      Isnew,
      Lastchangedat,
      /* Associations */
      _user_tools: redirected to composition child zcds_lmo_017
}
