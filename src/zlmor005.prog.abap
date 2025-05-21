*&---------------------------------------------------------------------*
*& <Nome do cliente> # <Nome do Projeto> *
*&---------------------------------------------------------------------*
*& Domain : *
*& Program type : Report *
*& Author Name : Lucas Martins de Oliveira *
*& Date : 10.08.2023 *
*& Description : Testando tabelas internas *
*&---------------------------------------------------------------------*
*& Modifications *
*&---------------------------------------------------------------------*
*& Author Name : *
*& Date : *
*& Request : *
*& Description : *
*&---------------------------------------------------------------------*
REPORT zlmor005 NO STANDARD PAGE HEADING MESSAGE-ID 00.


*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: IT_t005t TYPE STANDARD TABLE OF t005t WITH HEADER LINE.


* Passando os registros dos locais com a mesma linguagem do SY de t005t em it_t005t
SELECT * FROM t005t INTO TABLE it_t005t[] WHERE t005t~mandt EQ sy-mandt
                    AND t005t~spras EQ sy-langu
                    ORDER BY t005t~landx50.

* Escrevendo na tela os nomes dos lugares filtrados
*LOOP AT it_t005t.
*  WRITE: / it_t005t-land1, it_t005t-landx50.
*ENDLOOP.

* Filtrando somente os locais que começam com a letra A
LOOP AT it_t005t WHERE landx50(1) EQ 'A'.
  WRITE: / it_t005t-land1, it_t005t-landx50.
ENDLOOP.
