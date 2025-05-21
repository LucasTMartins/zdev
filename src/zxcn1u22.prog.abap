*&---------------------------------------------------------------------*
*& Include          ZXCN1U22
*&---------------------------------------------------------------------*

CONSTANTS: lc_tcode(5)         TYPE c VALUE 'CJ20N',
           lc_save(4)          TYPE c VALUE 'SAVE',
           lc_save_message(40) TYPE c VALUE 'Não é possível salvar o Elemento PEP pai'.

"------------------------------- Evitando que o Elemento PEP pai seja salvo
IF ga_prps-stufe EQ '1' AND sy-ucomm EQ lc_save.
  MESSAGE e398(00) WITH lc_save_message space space space.
ENDIF.

IF sy-tcode EQ lc_tcode. "CJ20N
  "------------------------------- Atualizando campos da estrutura
  cnci_prps_exp-zzjan       = ga_prps-zzjan.
  cnci_prps_exp-zzfev       = ga_prps-zzfev.
  cnci_prps_exp-zzmar       = ga_prps-zzmar.
  cnci_prps_exp-zzabr       = ga_prps-zzabr.
  cnci_prps_exp-zzmai       = ga_prps-zzmai.
  cnci_prps_exp-zzjun       = ga_prps-zzjun.
  cnci_prps_exp-zzjul       = ga_prps-zzjul.
  cnci_prps_exp-zzago       = ga_prps-zzago.
  cnci_prps_exp-zzset       = ga_prps-zzset.
  cnci_prps_exp-zzout       = ga_prps-zzout.
  cnci_prps_exp-zznov       = ga_prps-zznov.
  cnci_prps_exp-zzdez       = ga_prps-zzdez.
*  cnci_prps_exp-zzprart     = ga_prps-prart.
  cnci_prps_exp-zztotal_ano = ga_prps-zzjan + ga_prps-zzfev + ga_prps-zzmar +
                            ga_prps-zzabr + ga_prps-zzmai + ga_prps-zzjun +
                            ga_prps-zzjul + ga_prps-zzago + ga_prps-zzset +
                            ga_prps-zzout + ga_prps-zznov + ga_prps-zzdez.
ENDIF.
