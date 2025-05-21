*----------------------------------------------------------------------*
***INCLUDE ZXCN1O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0700 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0700 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  CONSTANTS: lc_zzjan(13) TYPE c VALUE 'GA_PRPS-ZZJAN',
             lc_zzfev(13) TYPE c VALUE 'GA_PRPS-ZZFEV',
             lc_zzmar(13) TYPE c VALUE 'GA_PRPS-ZZMAR',
             lc_zzabr(13) TYPE c VALUE 'GA_PRPS-ZZABR',
             lc_zzmai(13) TYPE c VALUE 'GA_PRPS-ZZMAI',
             lc_zzjun(13) TYPE c VALUE 'GA_PRPS-ZZJUN',
             lc_zzjul(13) TYPE c VALUE 'GA_PRPS-ZZJUL',
             lc_zzago(13) TYPE c VALUE 'GA_PRPS-ZZAGO',
             lc_zzset(13) TYPE c VALUE 'GA_PRPS-ZZSET',
             lc_zzout(13) TYPE c VALUE 'GA_PRPS-ZZOUT',
             lc_zznov(13) TYPE c VALUE 'GA_PRPS-ZZNOV',
             lc_zzdez(13) TYPE c VALUE 'GA_PRPS-ZZDEZ'.

  IF ga_prps-stufe EQ '1'.  "Caso seja o primeiro nivel de hierarquia, os campos virão bloqueados
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN lc_zzjan OR lc_zzfev OR lc_zzmar OR
             lc_zzabr OR lc_zzmai OR lc_zzjun OR
             lc_zzjul OR lc_zzago OR lc_zzset OR
             lc_zzout OR lc_zznov OR lc_zzdez.
          screen-input = '0'.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDMODULE.
