  FUNCTION zf_lmo_convert_cpf_001.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CHAR80 OPTIONAL
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CHAR80
*"----------------------------------------------------------------------
    CHECK input IS NOT INITIAL.

    DATA: gv_cpf_out TYPE string, "cpf formatado para output
          gv_tam_cpf TYPE i. "tamanho do cpf

    gv_tam_cpf = strlen( input ). "variavel de tamanho do cpf recebendo valor

    DO gv_tam_cpf TIMES. "concatenando os valores do input na variavel de cpf
      SUBTRACT 1 FROM sy-index.
      CHECK input+sy-index(1) GE '0' AND input+sy-index(1) LE '9'.
      CONCATENATE gv_cpf_out input+sy-index(1) INTO gv_cpf_out.
    ENDDO.

    WHILE strlen( gv_cpf_out ) LT '11'. CONCATENATE '0' gv_cpf_out INTO gv_cpf_out. ENDWHILE. "preenchendo valores vazios da variavel com '0'

    CONCATENATE gv_cpf_out(3) '.' gv_cpf_out+3(3) '.' gv_cpf_out+6(3) '-' gv_cpf_out+9 INTO output. "inserindo o valor de cpf já com os pontos e traço na variavel output

    DATA lv_var TYPE char30.
    WRITE input USING EDIT MASK '___.___.___-__' TO lv_var.

  ENDFUNCTION.
