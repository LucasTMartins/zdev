*&---------------------------------------------------------------------*
*& <Nome do cliente> # <Nome do Projeto> *
*&---------------------------------------------------------------------*
*& Domain : *
*& Program type : Report *
*& Author Name : Lucas Martins de Oliveira *
*& Date : 10.08.2023 *
*& Description : Exercicio 1- Comandos e Reports*
*&---------------------------------------------------------------------*
*& Modifications *
*&---------------------------------------------------------------------*
*& Author Name : *
*& Date : *
*& Request : *
*& Description : *
*&---------------------------------------------------------------------*
REPORT zlmor007 NO STANDARD PAGE HEADING MESSAGE-ID 00.

TABLES: zfuncionario_lma.

TYPES: BEGIN OF ty_tab,
         mandt          TYPE zfuncionario_lma-mandt,
         matricula      TYPE zfuncionario_lma-matricula,
         nome           TYPE zfuncionario_lma-nome,
         datanascimento TYPE zfuncionario_lma-datanascimento,
         rg             TYPE zfuncionario_lma-rg,
         cpf            TYPE zfuncionario_lma-cpf,
       END OF ty_tab.

DATA: gs_mat TYPE ty_tab,
      gt_mat TYPE STANDARD TABLE OF ty_tab.

SELECT-OPTIONS: s_mat FOR zfuncionario_lma-matricula OBLIGATORY.

INITIALIZATION.
  s_mat-low = '1'.
  s_mat-high = '5000'.
  APPEND s_mat.

AT SELECTION-SCREEN.
  IF s_mat-low EQ ' '.
    MESSAGE i398(00) WITH 'Material não encontrado'.
  ELSEIF s_mat-high EQ ' '.
    MESSAGE i398(00) WITH 'Material não encontrado'.
  ENDIF.

TOP-OF-PAGE.
  WRITE: / 'Dados de funcionários' COLOR 7.
  ULINE.
  WRITE: / 'Matricula' COLOR 2,
    25 'Nome' COLOR 3,
    45 'Data de nascimento' COLOR 4,
    65 'RG' COLOR 5,
    85 'CPF' COLOR 6.
  ULINE.

END-OF-PAGE.

START-OF-SELECTION.

  SELECT * FROM zfuncionario_lma
  INTO TABLE gt_mat WHERE matricula IN s_mat.

  SORT gt_mat BY matricula.

  LOOP AT gt_mat INTO gs_mat.
    WRITE: / gs_mat-matricula,
    26 gs_mat-nome,
    46 gs_mat-datanascimento,
    66 gs_mat-rg,
    86 gs_mat-cpf.
  ENDLOOP.

END-OF-SELECTION.
  ULINE.
  SKIP.
