REPORT zdemo_adbc_04.

***Steps to use ADBC for DDL
*1. Establish a DB connection
*2. Instantiate the Statement Object
*3. Construct SQL Create Statement
*4. Execute the Query by calling execute_ddl method
*5. Close Database Connection

*1. Establish a DB connection
DATA(ref_sql_con) = NEW cl_sql_connection( ).

*2. Instantiate the Statement Object
IF ref_sql_con IS BOUND.
  DATA(ref_sql_stmt) = NEW cl_sql_statement( con_ref = ref_sql_con ).
ENDIF.

*3. Construct SQL Create Statement
DATA(lv_create_query) =    `CREATE TABLE ZSCUSTOM ( `
                        && `ID          NVARCHAR(8) PRIMARY KEY,`
                        && `NAME        NVARCHAR(25),`
                        && `CUSTTYPE    NVARCHAR(1),`
                        && `EMAIL       NVARCHAR(40) )`.

*4. Execute the Query by calling execute_ddl method
IF ref_sql_stmt IS BOUND.
  TRY.
      ref_sql_stmt->execute_ddl( statement = lv_create_query ).
    CATCH cx_sql_exception INTO DATA(lref_sql_error).
      DATA(lv_text) = lref_sql_error->get_text( ).
  ENDTRY.

*Inserting data into Created Table
*( '00000002','Andreas Klotz','P','Andreas.Klotz@sap.com' )
  DATA(lv_insert_query) =    `INSERT INTO ZSCUSTOM VALUES`
                          && `( '00000001','SAP AG','B','info@sap.de' )`.
  TRY.
      ref_sql_stmt->execute_update( statement = lv_insert_query ).
    CATCH cx_sql_exception INTO lref_sql_error.
      lv_text = lref_sql_error->get_text( ).
  ENDTRY.

*Reading the data from Database Table
  TRY.
      ref_sql_stmt->execute_query(
        EXPORTING
          statement  = 'SELECT * FROM ZSCUSTOM'
        RECEIVING
          result_set = DATA(ref_result_set)
      ).
    CATCH cx_sql_exception.
  ENDTRY.

  TYPES: BEGIN OF s_customer,
           id       TYPE c LENGTH 8,
           name     TYPE c LENGTH 25,
           custtype TYPE c LENGTH 1,
           email    TYPE c LENGTH 40,
         END OF s_customer.
  DATA gt_customer TYPE TABLE OF s_customer.
  TRY.
      ref_result_set->set_param_table( itab_ref = REF #( gt_customer ) ).
    CATCH cx_parameter_invalid.
  ENDTRY.
  TRY.
      ref_result_set->next_package( ).
    CATCH cx_sql_exception.
  ENDTRY.

*Closing Result Set
  ref_result_set->close( ).

ENDIF.

*5.Close Database Connection
IF ref_sql_con IS BOUND.
  TRY.
      ref_sql_con->close( ).
    CATCH cx_sql_exception.
  ENDTRY.
ENDIF.

*6. Display the results.
cl_demo_output=>display( data = gt_customer ).
