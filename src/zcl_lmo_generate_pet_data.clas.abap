CLASS zcl_lmo_generate_pet_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lmo_generate_pet_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA itab TYPE TABLE OF zlmot_pettipopet.

    "preenchendo valores da tablea (itab)
    itab = VALUE #(
        ( id = 1 descricao = 'Cachorro' )
        ( id = 2 descricao = 'Gato' )
        ( id = 3 descricao = 'Peixe' )
     ).

     "deletando entradas existentes no banco de dados
     DELETE from zlmot_pettipopet.

     "inserindo as novas entradas
     INSERT zlmot_pettipopet FROM TABLE @itab.

     "mostrando resultado através do console
     out->write( |{ sy-dbcnt } entradas inseridas com sucesso!| ).
  ENDMETHOD.
ENDCLASS.
