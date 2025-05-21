class ZCL_ZLMOCD_STUDENT_CHDO definition
  public
  create public .

public section.

  interfaces IF_CHDO_ENHANCEMENTS .

  types:
     BEGIN OF TY_ZLMOT022 .
      INCLUDE TYPE ZLMOT022.
      INCLUDE TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_ICDIND.
 TYPES END OF TY_ZLMOT022 .
  types:
    TT_ZLMOT022 TYPE STANDARD TABLE OF TY_ZLMOT022 .

  class-data OBJECTCLASS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTCL read-only value 'ZLMOCD_STUDENT' ##NO_TEXT.

  class-methods WRITE
    importing
      !OBJECTID type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTV
      !TCODE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDTCODE
      !UTIME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUZEIT
      !UDATE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDDATUM
      !USERNAME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUSERNAME
      !PLANNED_CHANGE_NUMBER type IF_CHDO_OBJECT_TOOLS_REL=>TY_PLANCHNGNR default SPACE
      !OBJECT_CHANGE_INDICATOR type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default 'U'
      !PLANNED_OR_REAL_CHANGES type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !NO_CHANGE_POINTERS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !XZLMOT022 type TT_ZLMOT022 optional
      !YZLMOT022 type TT_ZLMOT022 optional
      !UPD_ZLMOT022 type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default SPACE
    exporting
      value(CHANGENUMBER) type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR
    raising
      CX_CHDO_WRITE_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZLMOCD_STUDENT_CHDO IMPLEMENTATION.


  method WRITE.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZLMOCD_STUDENT
*"         never change it manually, please!        :10/01/2024
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA: l_upd        TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    CALL METHOD cl_chdo_write_tools=>changedocument_open
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        planned_change_number   = planned_change_number
        planned_or_real_changes = planned_or_real_changes.

    IF ( YZLMOT022 IS INITIAL ) AND
       ( XZLMOT022 IS INITIAL ).
      l_upd  = space.
    ELSE.
      l_upd = UPD_ZLMOT022.
    ENDIF.

    IF l_upd NE space.
      CALL METHOD CL_CHDO_WRITE_TOOLS=>changedocument_multiple_case
        EXPORTING
          tablename              = 'ZLMOT022'
          change_indicator       = UPD_ZLMOT022
          docu_delete            = 'X'
          docu_insert            = 'X'
          docu_delete_if         = ''
          docu_insert_if         = ''
          table_old              = YZLMOT022
          table_new              = XZLMOT022
                  .
    ENDIF.

    CALL METHOD cl_chdo_write_tools=>changedocument_close
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        date_of_change          = udate
        time_of_change          = utime
        tcode                   = tcode
        username                = username
        object_change_indicator = object_change_indicator
        no_change_pointers      = no_change_pointers
      IMPORTING
        changenumber            = changenumber.


*"  Code snippets to be used with COPY+PASTE
*"  uncomment the needed parts
*"  change names if needed

*"  Start of default parameter part
* DATA: objectid                TYPE cdhdr-objectid,
*       tcode                   TYPE cdhdr-tcode,
*       planned_change_number   TYPE cdhdr-planchngnr,
*       utime                   TYPE cdhdr-utime,
*       udate                   TYPE cdhdr-udate,
*       username                TYPE cdhdr-username,
*       cdoc_planned_or_real    TYPE cdhdr-change_ind,
*       cdoc_upd_object         TYPE cdhdr-change_ind VALUE 'U',
*       cdoc_no_change_pointers TYPE cdhdr-change_ind.
* DATA: cdchangenumber          TYPE cdhdr-changenr.
*"  End of default parameter part

*" Begin of dynamic DATA part for class ZCL_ZLMOCD_STUDENT_CHDO
*"   table with the NEW content of: ZLMOT022
* DATA XZLMOT022 TYPE ZCL_ZLMOCD_STUDENT_CHDO=>TT_ZLMOT022.
*"   table with the OLD content of: ZLMOT022
* DATA YZLMOT022 TYPE ZCL_ZLMOCD_STUDENT_CHDO=>TT_ZLMOT022.
*"   change indicator for table: ZLMOT022
* DATA UPD_ZLMOT022 TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH.

*"     Change Number of Document
* DATA CHANGENUMBER TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR.

*" End of dynamic DATA part for class ZCL_ZLMOCD_STUDENT_CHDO


*"  Begin of method call part
*"  define needed DATA for error handling
* DATA err_ref TYPE REF TO cx_chdo_write_error.
* DATA err_action TYPE string.

*    TRY.
*        CALL METHOD ZCL_ZLMOCD_STUDENT_CHDO=>write
*          EXPORTING
*            objectid                = objectid
*            tcode                   = tcode
*            utime                   = utime
*            udate                   = udate
*            username                = username
*            planned_change_number   = planned_change_number
*            object_change_indicator = cdoc_upd_object
*            planned_or_real_changes = cdoc_planned_or_real
*            no_change_pointers      = cdoc_no_change_pointers
*"  End of default method call part

*" Begin of dynamic part for method call
*"   table with the NEW content of: ZLMOT022
*   XZLMOT022 = XZLMOT022
*"   table with the OLD content of: ZLMOT022
*   YZLMOT022 = YZLMOT022
*"   change indicator for table: ZLMOT022
*   UPD_ZLMOT022 = UPD_ZLMOT022

*"     Change Number of Document
*           IMPORTING
*             changenumber            = cdchangenumber.
*      CATCH cx_chdo_write_error INTO err_ref.
*"        MESSAGE err_ref TYPE 'A'.
*"   error information could be determined with default GET_TEXT, GET_LONGTEXT, GET_SOURCE_POSITION methds

*    ENDTRY.
*" End of dynamic part for method call
  endmethod.
ENDCLASS.
