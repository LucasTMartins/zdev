@AbapCatalog.sqlViewName: 'ZCDS_LMOV_VHG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Nível Geral'
define view zcdslmo_vh_geral
  as select distinct from dd07t
{
      @UI.hidden: true
  key domname    as Domname,
      @UI.hidden: true
  key ddlanguage as Ddlanguage,
      @UI.hidden: true
  key as4local   as As4local,
      @UI.hidden: true
  key valpos     as Valpos,
      @UI.hidden: true
  key as4vers    as As4vers,
      ddtext     as Ddtext,
      @UI.hidden: true
      domval_ld  as DomvalLd,
      @UI.hidden: true
      domval_hd  as DomvalHd,
      @UI.hidden: true
      domvalue_l as DomvalueL
}
where
      as4local   = 'A'
  and ddlanguage = 'P'
  and domname    = 'ZD_NIVEL_GERAL_LMO'
