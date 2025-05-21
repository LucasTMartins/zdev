*&---------------------------------------------------------------------*
*& Report ZLMOR003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlmor003.

DATA: GV_text TYPE string,
    GV_text2 TYPE string,
    GV_textlen TYPE i,
    GV_textlen2 TYPE i,
    GV_textshift LIKE GV_text,
    GV_aux TYPE match_result,
    GV_part1 LIKE GV_text,
    GV_part2 LIKE GV_text,
    GV_data TYPE d.

FIELD-SYMBOLS <GFS_time>.

GV_text = 'Olá mundo!'.

WRITE: / GV_text.

GV_textlen = strlen( GV_text ).

WRITE: / 'Tamanho do texto usando STRLEN:',
    GV_textlen.

GV_textlen2 = numofchar( GV_text ).

WRITE: / 'Tamanho do texto usando NUMOFCHAR:',
    GV_textlen2,
    / '----------------------------------'.

GV_text = 'Olá'.
GV_text2 = 'mundo!'.

WRITE: / 'Text sem CONCATENATE: ',  GV_text,
    / 'Text2 sem CONCATENATE: ',  GV_text2.

CONCATENATE GV_text GV_text2 INTO GV_text SEPARATED BY space.

WRITE: / 'Text com CONCATENATE: ', GV_text.


REPLACE ALL OCCURRENCES OF 'mundo' IN GV_text WITH 'Lucas'.

WRITE: / 'Text modificado com REPLACE: ', GV_text,
    / '----------------------------------'.

GV_textshift = GV_text.
SHIFT GV_textshift BY 6 PLACES LEFT.
WRITE: / 'Text com SHIFT a esquerda: ', GV_textshift.

GV_textshift = GV_text.
SHIFT GV_textshift BY 6 PLACES RIGHT.
WRITE: / 'Text com SHIFT a direita: ', GV_textshift.

GV_textshift = GV_text.
SHIFT GV_textshift BY 6 PLACES CIRCULAR.
WRITE: / 'Text com SHIFT CIRCULAR: ', GV_textshift,
    / '----------------------------------'.

FIND FIRST OCCURRENCE OF 'Lucas' IN GV_text RESULTS GV_aux.
WRITE: / 'Posição da palavra Lucas em text: ', GV_aux-offset USING EDIT MASK'___'.

GV_text2 = GV_text.
TRANSLATE GV_text2 TO UPPER CASE.
WRITE: / 'Texto modificado com TRANSLATE para UPPER CASE: ', GV_text2.

GV_text2 = GV_text.
TRANSLATE GV_text2 TO LOWER CASE.
WRITE: / 'Texto modificado com TRANSLATE para LOWER CASE: ', GV_text2.

GV_text2 = GV_text.
CONDENSE GV_text2 NO-GAPS.
WRITE: / 'Texto modificado com CONDENSE e NO-GAPS: ', GV_text2,
    / '----------------------------------'.

SPLIT GV_text AT space INTO GV_part1 GV_part2.
WRITE: / 'Texto sem modificações: ', GV_text,
    / 'Primeira parte do texto: ', GV_part1,
    / 'Segunda parte do texto: ', GV_part2,
    / '----------------------------------'.

CONCATENATE sy-datum(6) space space INTO GV_data.

WRITE: / GV_data.

OVERLAY GV_data WITH '      01'.

WRITE: / GV_data DD/MM/YYYY,
    / '----------------------------------'.

ASSIGN sy-uzeit TO <GFS_time>.
WRITE: / <GFS_time>.
