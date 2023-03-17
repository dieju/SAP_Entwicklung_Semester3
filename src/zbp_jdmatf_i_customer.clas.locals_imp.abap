CLASS lhc_ZJDMATF_I_Customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZJDMATF_I_Customer RESULT result.
    METHODS determinecustomerid FOR DETERMINE ON SAVE
      IMPORTING keys FOR zjdmatf_i_customer~determinecustomerid.

ENDCLASS.

CLASS lhc_ZJDMATF_I_Customer IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineCustomerId.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Customer
     FIELDS ( CustomerId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(customers).

   LOOP AT customers INTO DATA(customer).

      SELECT SINGLE FROM ZJDMATFCustomer
        FIELDS MAX( Customer_Id ) AS max_customer_id
        INTO @DATA(max_customer_id).

      " Festlegen der ersten ID in der Datenbank -> erste ID dadurch 50000001
      if max_customer_id = 0.
        max_customer_id = 50000000.
      endif.

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Customer
        UPDATE FIELDS ( CustomerId )
        WITH VALUE #( ( %tky = customer-%tky CustomerId = max_customer_id + 1 ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
