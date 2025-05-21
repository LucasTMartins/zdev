@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Usuário e Ferramentas'
define view entity zcds_lmo_015
  as select from zlmot017
  association to parent zcds_lmo_014 as _user on $projection.Userid = _user.Userid
{
  key userid        as Userid,
  key toolsid       as Toolsid,
      toolname      as Toolname,
      knowledge     as Knowledge,
      interest      as Interest,
      training      as Training,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchangedat as Lastchangedat,
      _user // Make association public
}
