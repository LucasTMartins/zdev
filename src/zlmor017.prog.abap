*&---------------------------------------------------------------------*
*& Domain       : WM                                                   *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 31.08.2023                                           *
*& Description  : Criando classe zcl_bank_account_lmo                  *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor017.

" referenciando tipos dos objetos.
DATA: go_account1 TYPE REF TO zcl_bank_account_lmo,
      go_account2 TYPE REF TO zcl_bank_account_lmo.

" criando objetos conta1 e conta2
CREATE OBJECT go_account1.
CREATE OBJECT go_account2.

WRITE: / 'Depositing U$ 500 in account 1',
       / 'Depositing U$ 130 in account 2'.

" depositando nas contas
CALL METHOD go_account1->deposit EXPORTING amount = 500.
CALL METHOD go_account2->deposit EXPORTING amount = 130.

WRITE: / 'Withdrawing U$ 100 in account 1',
       / 'Withdrawing U$ 110 in account 2'.

" sacando das contas
CALL METHOD go_account1->withdraw EXPORTING amount = 100.
CALL METHOD go_account2->withdraw EXPORTING amount = 110.

WRITE: / 'Account 1 balance', go_account1->balance,
       / 'Account 2 balance', go_account2->balance.
