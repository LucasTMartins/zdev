*----------------------------------------------------------------------*
***INCLUDE MZLMO005_USER_COMMAND_0100I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  TYPES: BEGIN OF gty_ekpo,
           ebeln TYPE ekpo-ebeln, "Nº do documento de compras
           aedat TYPE ekpo-aedat, "Data de modificação do item de documento de compra
           matnr TYPE ekpo-matnr, "Nº do material
           txz01 TYPE ekpo-txz01, "Texto breve
           bukrs TYPE ekpo-bukrs, "Empresa
           werks TYPE ekpo-werks, "Centro
         END OF gty_ekpo.

  DATA: gt_ekpo TYPE gty_ekpo.

  CONSTANTS: lc_buscardados TYPE string VALUE 'BUSCARDADOS',
             lc_kbbuscdado  TYPE string VALUE 'KBBUSCDADO',
             lc_limpar      TYPE string VALUE 'LIMPAR',
             lc_kblimpar    TYPE string VALUE 'KBLIMPAR',
             lc_back        TYPE string VALUE 'BACK',
             lc_exit        TYPE string VALUE 'EXIT',
             lc_cancel      TYPE string VALUE 'CANCEL'
             .

  CASE sy-ucomm.
    WHEN lc_buscardados OR lc_kbbuscdado.
      "verificando se o campo necessário não está vazio
      IF gt_ekpo-ebeln IS INITIAL.
        MESSAGE i398(00) WITH TEXT-001.
      ENDIF.

      "recebendo dados requisitados pelo documento de compras
      SELECT SINGLE ebeln aedat matnr txz01 bukrs werks
        FROM ekpo
        INTO CORRESPONDING FIELDS OF gt_ekpo
        WHERE ebeln = gt_ekpo-ebeln.

      IF sy-subrc <> 0 AND gt_ekpo-ebeln IS NOT INITIAL.
        MESSAGE i398(00) WITH TEXT-003.
      ENDIF.

    WHEN lc_limpar OR lc_kblimpar.
      "limpando tabela
      CLEAR gt_ekpo.
    WHEN lc_back OR lc_exit OR lc_cancel.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
