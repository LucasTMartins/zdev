*&---------------------------------------------------------------------*
*& Report ZLMOR002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLMOR002.

TYPES: BEGIN OF LINE,
    FIELD1 TYPE C LENGTH 255,
    FIELD2 TYPE C LENGTH 45,
    END OF LINE,
    BEGIN OF WEEKDAY,
    FIELD1 TYPE C LENGTH 10,
    END OF WEEKDAY.

DATA: BEGIN OF MY_RECORD,
    FIELD1 TYPE LINE,
    FIELD2 TYPE N LENGTH 30,
    END OF MY_RECORD,
    whatstheday TYPE WEEKDAY.

MY_RECORD-FIELD1 = 'Texto testando váriavel com novo tipo'.

MY_RECORD-FIELD2 = '1234567890'.

WRITE: / '------------------------',
    / MY_RECORD-FIELD1,
    / MY_RECORD-FIELD2.

MY_RECORD = 'Segundo teste sobre os fields'.

WRITE: / '------------------------',
    / MY_RECORD,
    / MY_RECORD-FIELD1,
    / MY_RECORD-FIELD2.

MY_RECORD-FIELD1 = 'Terceiro teste'.
MY_RECORD-FIELD2 = '0987654321'.

WRITE:  / '------------------------',
    / MY_RECORD,
    / MY_RECORD-FIELD1,
    / MY_RECORD-FIELD2.

whatstheday = 'Segunda'.

WRITE: / '------------------------',
    / whatstheday.

whatstheday = 'Terça'.

WRITE: / '------------------------',
    / whatstheday.
