@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Usuário'
define root view entity zcds_lmo_014
  as select from zlmot016
  composition [0..*] of zcds_lmo_015 as _user_tools
{
  key userid        as Userid,
      email         as Email,
      fullname      as Fullname,
      isnew         as Isnew,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchangedat as Lastchangedat,
      _user_tools // Make association public
}
