REPORT zdemo_alv_ida_04.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS on_double_click FOR EVENT double_click OF if_salv_gui_table_display_opt
      IMPORTING ev_field_name
                eo_row_data.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.
    DATA ls_airline TYPE scarr.

    IF ev_field_name EQ 'CARRID'.
      eo_row_data->get_row_data(
        IMPORTING
          es_row = ls_airline
      ).
      PERFORM flight_schedule_data_display USING ls_airline-carrid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

FORM flight_schedule_data_display USING lv_airline_code.

  DATA(lref_alv_ida) = cl_salv_gui_table_ida=>create( iv_table_name = 'SPFLI' ).

  IF lref_alv_ida IS BOUND.

****Apply condition
    DATA(lref_alv_ida_codn_factory) = lref_alv_ida->condition_factory( ).

    DATA(lref_alv_ida_codn) = lref_alv_ida_codn_factory->equals( name  = 'CARRID'
                                                                 value = lv_airline_code ).
    lref_alv_ida->set_select_options( io_condition = lref_alv_ida_codn ).
****
    DATA(lref_alv_ida_fullscreen) = lref_alv_ida->fullscreen( ).
  ENDIF.

  IF lref_alv_ida_fullscreen IS BOUND.
    lref_alv_ida_fullscreen->display( ).
  ENDIF.

ENDFORM.


START-OF-SELECTION.

*Get ALV Object
  DATA(ref_alv_ida) = cl_salv_gui_table_ida=>create( iv_table_name = 'SCARR' ).

  IF ref_alv_ida IS BOUND.
    PERFORM double_click_event_register.

*Get the fullscreen mode object
    DATA(ref_alv_ida_fullscreen) = ref_alv_ida->fullscreen( ).

  ENDIF.

*Display data on screen
  IF ref_alv_ida_fullscreen IS BOUND.
    ref_alv_ida_fullscreen->display( ).
  ENDIF.

FORM double_click_event_register.

*Get the reference of Display options interface
  DATA(lref_alv_ida_display_options) = ref_alv_ida->display_options( ).

*Enable Double click using display options
  IF lref_alv_ida_display_options IS BOUND.
    lref_alv_ida_display_options->enable_double_click( ).

*Register the event(double click) handler method
    DATA(lref_event_handler) = NEW lcl_event_handler( ).
    SET HANDLER lref_event_handler->on_double_click FOR ALL INSTANCES.
  ENDIF.

ENDFORM.
