REPORT zdemo_alv_ida_01.

*Steps to use ALV IDA
*SAP List Viewer(ALV) with Integrated Data Access(IDA)
*1. Get the ALV Object by passing DB Table Name or DDIC View(CREATE Method)
*2. Using the above ALV Object, get reference of full screen Mode(FULLSCREEN Method)
*3. Using the above full screen Mode object, display the content on UI(DISPLAY Method)

*1. Get the ALV Object by passing DB Table Name or DDIC View(CREATE Method)
DATA(ref_alv_ida) = cl_salv_gui_table_ida=>create( iv_table_name = 'SFLIGHT' )."We can pass Database View(Ex: SFLVIEW ) Also

*2. Using the above ALV Object, get reference of full screen Mode(FULLSCREEN Method)
IF ref_alv_ida IS BOUND.
  DATA(ref_alv_ida_fullscreen) = ref_alv_ida->fullscreen( ).
ENDIF.

*3. Using the above full screen Mode object, display the content on UI(DISPLAY Method)
IF ref_alv_ida_fullscreen IS BOUND.
  ref_alv_ida_fullscreen->display( ).
ENDIF.

*Display Data in Single Line
*cl_salv_gui_table_ida=>create( iv_table_name = 'SFLIGHT' )->fullscreen( )->display( ).
