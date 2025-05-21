interface ZIF_MAT_DETAILS_LMO
  public .


  methods GET_MATERIAL_DETAILS
    importing
      !IM_MATNR type MARA-MATNR
    exporting
      !EX_MARA type MARA .
  methods GET_MATERIAL_DESCRIPTIONS
    importing
      !IM_MATNR type MARA-MATNR
    exporting
      !EX_MAKT type MAKT .
endinterface.
