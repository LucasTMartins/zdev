*&---------------------------------------------------------------------*
*& Include          ZLMOR028O01
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR  '0100'.


 PERFORM f_create_container.
 PERFORM f_disp_alv1.
 PERFORM f_disp_alv2.


ENDMODULE.
