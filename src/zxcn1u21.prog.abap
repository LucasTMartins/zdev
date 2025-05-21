*&---------------------------------------------------------------------*
*& Include          ZXCN1U21
*&---------------------------------------------------------------------*
CONSTANTS: lc_capex(2) TYPE c VALUE 'CP',
           lc_opex(2)  TYPE c VALUE 'OP',
           lc_tcode(5) TYPE c VALUE 'CJ20N'.

TYPES: BEGIN OF lts_pstab,
         prps   TYPE prps,
         pstabd TYPE pstabd,
       END OF lts_pstab.

DATA: ls_pstab             TYPE lts_pstab,
      lv_isSelectedElement TYPE c.

IF sy-tcode EQ lc_tcode. "CJ20N
  ga_prps-stufe = sap_prps_imp-stufe. "Campo de nível de hierarquia

  "------------------------------- Validando o tipo de projeto
  CLEAR: ga_prps-prart.
  IF sap_prps_imp-stufe GT '1'.  "Caso o nivel de hierarquia seja maior que 1, o tipo de projeto deve ser preenchido com Capex ou Opex
    ga_prps-prart = COND #(
      WHEN sap_prps_imp-imprf IS NOT INITIAL
      THEN lc_capex
      ELSE lc_opex
    ).

    "------------------------------- Preenchendo campos da tela
    CLEAR: ga_prps-zzjan, ga_prps-zzfev, ga_prps-zzmar,
           ga_prps-zzabr, ga_prps-zzmai, ga_prps-zzjun,
           ga_prps-zzjul, ga_prps-zzago, ga_prps-zzset,
           ga_prps-zzout, ga_prps-zznov, ga_prps-zzdez.
    ga_prps-zzjan = sap_prps_imp-zzjan.
    ga_prps-zzfev = sap_prps_imp-zzfev.
    ga_prps-zzmar = sap_prps_imp-zzmar.
    ga_prps-zzabr = sap_prps_imp-zzabr.
    ga_prps-zzmai = sap_prps_imp-zzmai.
    ga_prps-zzjun = sap_prps_imp-zzjun.
    ga_prps-zzjul = sap_prps_imp-zzjul.
    ga_prps-zzago = sap_prps_imp-zzago.
    ga_prps-zzset = sap_prps_imp-zzset.
    ga_prps-zzout = sap_prps_imp-zzout.
    ga_prps-zznov = sap_prps_imp-zznov.
    ga_prps-zzdez = sap_prps_imp-zzdez.
  ELSE.
    ASSIGN ('(SAPLCJDW)PSTAB[]') TO FIELD-SYMBOL(<lfs_pstab>).

    IF <lfs_pstab> IS ASSIGNED.
      CLEAR: ga_prps-zzjan, ga_prps-zzfev, ga_prps-zzmar,
             ga_prps-zzabr, ga_prps-zzmai, ga_prps-zzjun,
             ga_prps-zzjul, ga_prps-zzago, ga_prps-zzset,
             ga_prps-zzout, ga_prps-zznov, ga_prps-zzdez,
             ls_pstab, lv_isSelectedElement.
      LOOP AT <lfs_pstab> INTO ls_pstab.
        IF lv_isSelectedElement IS NOT INITIAL.
          IF ls_pstab-prps-stufe GT 1.
            ga_prps-zzjan += ls_pstab-prps-zzjan.
            ga_prps-zzfev += ls_pstab-prps-zzfev.
            ga_prps-zzmar += ls_pstab-prps-zzmar.
            ga_prps-zzabr += ls_pstab-prps-zzabr.
            ga_prps-zzmai += ls_pstab-prps-zzmai.
            ga_prps-zzjun += ls_pstab-prps-zzjun.
            ga_prps-zzjul += ls_pstab-prps-zzjul.
            ga_prps-zzago += ls_pstab-prps-zzago.
            ga_prps-zzset += ls_pstab-prps-zzset.
            ga_prps-zzout += ls_pstab-prps-zzout.
            ga_prps-zznov += ls_pstab-prps-zznov.
            ga_prps-zzdez += ls_pstab-prps-zzdez.
          ELSEIF ls_pstab-prps-stufe EQ 1.
            EXIT.
          ENDIF.
        ENDIF.

        IF ls_pstab-prps-pspnr EQ sap_prps_imp-pspnr.
          lv_isSelectedElement = abap_true.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
