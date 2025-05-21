FUNCTION ZF_LMO_RETORNA_CLIENTES_001.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_UF) TYPE  REGIO
*"  EXPORTING
*"     REFERENCE(EX_MENSAGEM) TYPE  CHAR50
*"  TABLES
*"      ET_CLIENTES STRUCTURE  KNA1
*"----------------------------------------------------------------------

  select * from kna1
    into TABLE et_clientes
    WHERE regio = im_uf.

  IF sy-subrc ne '0'.
   ex_mensagem = text-001.
  ENDIF.





ENDFUNCTION.
