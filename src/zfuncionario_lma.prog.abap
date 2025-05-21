*&---------------------------------------------------------------------*
*& Report ZFUNCIONARIO_LMA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfuncionario_lma.

TABLES: zfuncionario_lma.

DATA: BEGIN OF t_zfuncionario_lma OCCURS 0,
  matricula LIKE zfuncionario_lma-matricula,
  nome LIKE zfuncionario_lma-nome,
  datanascimento LIKE zfuncionario_lma-datanascimento,
  rg LIKE zfuncionario_lma-rg,
  cpf LIKE zfuncionario_lma-cpf,
END OF t_zfuncionario_lma.

SELECTION-SCREEN BEGIN OF BLOCK b1001 WITH FRAME.
  PARAMETERS: p_matri LIKE zfuncionario_lma-matricula OBLIGATORY,
    p_nome LIKE zfuncionario_lma-nome OBLIGATORY,
    p_datna LIKE zfuncionario_lma-datanascimento OBLIGATORY,
    p_rg LIKE zfuncionario_lma-rg OBLIGATORY,
    p_cpf LIKE zfuncionario_lma-cpf OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1001.

* aprendendo work area
t_zfuncionario_lma-matricula = p_matri.
t_zfuncionario_lma-nome = p_nome.
t_zfuncionario_lma-datanascimento = p_datna.
t_zfuncionario_lma-rg = p_rg.
t_zfuncionario_lma-cpf = p_cpf.

* append do workarea para a tabela interna.
APPEND zfuncionario_lma to t_zfuncionario_lma.

MOVE: t_zfuncionario_lma-matricula TO zfuncionario_lma-matricula,
      t_zfuncionario_lma-nome TO zfuncionario_lma-nome,
      t_zfuncionario_lma-datanascimento TO zfuncionario_lma-datanascimento,
      t_zfuncionario_lma-rg TO zfuncionario_lma-rg,
      t_zfuncionario_lma-cpf TO zfuncionario_lma-cpf.

INSERT zfuncionario_lma.

IF sy-subrc = '0'.
    COMMIT WORK.
    MESSAGE i368(00) WITH 'Dados atualizados com sucesso.'.
ELSE.
    ROLLBACK WORK.
    MESSAGE i368(00) WITH 'Ocorreu um erro ao atualizar a tabela.'.
ENDIF.

CLEAR: t_zfuncionario_lma, t_zfuncionario_lma[].

    SELECT matricula nome datanascimento rg cpf
      FROM zfuncionario_lma
      INTO TABLE t_zfuncionario_lma.

LOOP AT t_zfuncionario_lma.

WRITE: / '|', t_zfuncionario_lma-matricula,
        '|', t_zfuncionario_lma-nome,
        '|', t_zfuncionario_lma-datanascimento,
        '|', t_zfuncionario_lma-rg,
        '|', t_zfuncionario_lma-cpf.
        ULINE.
ENDLOOP.
