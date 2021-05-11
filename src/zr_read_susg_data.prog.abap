********************************************************************************
* The MIT License (MIT)
*
* Copyright (c) 2021
*
* Simple Program to read SUSG Data from CDS-View SUSG_I_DATA with IDA ALV
********************************************************************************
REPORT ZR_READ_SUSG_DATA.

DATA lv_roottype TYPE susg_i_data-roottype.
DATA lv_rootname TYPE susg_i_data-rootname.
DATA lv_progname TYPE susg_i_data-progname.
DATA lv_obj_type TYPE susg_i_data-obj_type.
DATA lv_obj_name TYPE susg_i_data-obj_name.
DATA lv_sub_type TYPE susg_i_data-sub_type.
DATA lv_sub_name TYPE susg_i_data-sub_name.
DATA lv_class_name TYPE susg_i_data-classname.
DATA lv_counter TYPE susg_i_data-counter.
DATA lv_last_used TYPE susg_i_data-last_used.

SELECT-OPTIONS: so_roott FOR lv_roottype.
SELECT-OPTIONS: so_rootn FOR lv_rootname.
SELECT-OPTIONS: so_progn FOR lv_progname.
SELECT-OPTIONS: so_obj_t FOR lv_obj_type.
SELECT-OPTIONS: so_obj_n FOR lv_obj_name.
SELECT-OPTIONS: so_sub_t FOR lv_sub_type.
SELECT-OPTIONS: so_sub_n FOR lv_sub_name.
SELECT-OPTIONS: so_clasn FOR lv_class_name.
SELECT-OPTIONS: so_count FOR lv_counter.
SELECT-OPTIONS: so_laszu FOR lv_last_used.
PARAMETERS p_max_r TYPE i DEFAULT 500.

TRY.
    DATA(lo_salv_ida) = cl_salv_gui_table_ida=>create_for_cds_view( CONV #( 'SUSG_I_DATA' ) ).

    lo_salv_ida->field_catalog( )->get_all_fields( IMPORTING ets_field_names = DATA(lt_field_names) ).
    DELETE lt_field_names WHERE table_line EQ 'USGID'.
    lo_salv_ida->field_catalog( )->set_available_fields( its_field_names = lt_field_names ).


    DATA(lo_ranges) = NEW cl_salv_range_tab_collector( ).
    lo_ranges->add_ranges_for_name( iv_name = 'ROOTTYPE' it_ranges = so_roott[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'ROOTNAME' it_ranges = so_rootn[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'PROGNAME' it_ranges = so_progn[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'OBJ_TYPE' it_ranges = so_obj_t[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'OBJ_NAME' it_ranges = so_obj_n[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'SUB_TYPE' it_ranges = so_sub_t[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'SUB_NAME' it_ranges = so_sub_n[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'CLASS_NAME' it_ranges = so_clasn[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'COUNTER' it_ranges = so_count[] ).
    lo_ranges->add_ranges_for_name( iv_name = 'LAST_USED' it_ranges = so_laszu[] ).
    lo_ranges->get_collected_ranges(
      IMPORTING
        et_named_ranges = DATA(lt_named_ranges)
    ).

    lo_salv_ida->set_select_options(
      EXPORTING
        it_ranges    = lt_named_ranges
    ).

    lo_salv_ida->field_catalog( )->display_options( )->set_formatting( iv_field_name        = 'ROOTTYPE'
                                                                       iv_presentation_mode = if_salv_gui_types_ida=>cs_presentation_mode-description ).

    lo_salv_ida->field_catalog( )->set_field_header_texts( iv_field_name        = 'COUNTER'
                                                           iv_header_text       = 'Calls'
                                                           iv_tooltip_text      = 'Number of Calls'
                                                           iv_tooltip_text_long = 'Number of Calls' ).

    lo_salv_ida->field_catalog( )->set_field_header_texts( iv_field_name        = 'LAST_USED'
                                                           iv_header_text       = 'Last used'
                                                           iv_tooltip_text      = 'Date where last used'
                                                           iv_tooltip_text_long = 'Date where last used' ).


    lo_salv_ida->display_options( )->set_empty_table_text( iv_empty_table_text = 'No Data' ).

    lo_salv_ida->field_catalog( )->enable_text_search( 'ROOTNAME' ).
    lo_salv_ida->field_catalog( )->enable_text_search( 'PROGNAME' ).
    lo_salv_ida->field_catalog( )->enable_text_search( 'OBJ_NAME' ).
    lo_salv_ida->field_catalog( )->enable_text_search( 'SUB_NAME' ).
    lo_salv_ida->field_catalog( )->enable_text_search( 'CLASSNAME' ).
    lo_salv_ida->standard_functions( )->set_text_search_active( abap_true ).

    IF cl_salv_gui_table_ida=>db_capabilities( )->is_max_rows_recommended( ).
      lo_salv_ida->set_maximum_number_of_rows( iv_number_of_rows = p_max_r ).
    ENDIF.

    lo_salv_ida->fullscreen( )->display( ).
  CATCH cx_root INTO DATA(lx_root).
    WRITE: / lx_root->get_text( ).
ENDTRY.
