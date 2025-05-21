class ZCL_BANK_ACCOUNT_LMO definition
  public
  create public .

public section.

  data BALANCE type P read-only .

  methods DEPOSIT
    importing
      !AMOUNT type P .
  methods WITHDRAW
    importing
      !AMOUNT type P .
protected section.
private section.

  class-data ACCOUNT_TYPE type CHAR20 value 'Simple' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_BANK_ACCOUNT_LMO IMPLEMENTATION.


  method DEPOSIT.
    add amount to balance.
  endmethod.


  method WITHDRAW.
    SUBTRACT amount FROM balance.
  endmethod.
ENDCLASS.
