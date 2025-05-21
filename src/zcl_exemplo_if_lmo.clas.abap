class ZCL_EXEMPLO_IF_LMO definition
  public
  final
  create public .

public section.

  interfaces ZIF_MAT_DETAILS_LMO .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EXEMPLO_IF_LMO IMPLEMENTATION.


  method ZIF_MAT_DETAILS_LMO~GET_MATERIAL_DESCRIPTIONS.
    SELECT  *
      from  makt
      into  ex_makt
      WHERE matnr = im_matnr
      and   spras = 'E'.
    ENDSELECT.
  endmethod.


  method ZIF_MAT_DETAILS_LMO~GET_MATERIAL_DETAILS.
    select SINGLE *
      FROM  mara
      into  ex_mara
      WHERE matnr = im_matnr.
  endmethod.
ENDCLASS.
