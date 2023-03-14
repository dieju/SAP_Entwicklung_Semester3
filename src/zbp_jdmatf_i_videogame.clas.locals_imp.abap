CLASS lhc_zjdmatf_i_rental DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Rental RESULT result.

    METHODS determineProcessNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineProcessNumber.

    METHODS determineStartDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineStartDate.

    METHODS determineStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineStatus.

    METHODS return_videogame FOR MODIFY
      IMPORTING keys FOR ACTION Rental~return_videogame.

ENDCLASS.

CLASS lhc_zjdmatf_i_rental IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD return_videogame.

    "Deklarationen
    DATA rentals TYPE TABLE FOR READ RESULT ZJDMATF_I_Rental.
    "DATA: item_id TYPE zjdmatf_item_id.

    "Lesen der Daten
    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
      BY \_Videogame
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(videogames)

      FIELDS ( StartDate ReturnDate RentalCharge )
*      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT rentals.
*      RESULT DATA(bookings).

    "Sequentielle Verarbeitung der Buchungsdaten
    "Bei Validierungen: Fehlerfälle abfangen und Fehlermeldungen erzeugen
    "Bei Ermittlungen: Daten ermitteln und Daten zurückschreiben
    "Bei Actions: sowohl als auch
    LOOP AT videogames INTO DATA(videogame).

      IF videogame-status = 'A'.
        DATA item_id TYPE c Length 8.
        item_id = videogame-ItemId.

        DATA(message) = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>videogame_already_returned
          "item_id = videogame-ItemID
          ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( videogame ) TO failed-videogame.
        CONTINUE.
      ENDIF.

*      booking-Status = 'X'.

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = videogame-%tky Status = 'A' ) ).

      "item_id = videogame-ItemID. " ?

      message = NEW zcm_jdmatf_videogame(
        severity = if_abap_behv_message=>severity-success
        textid   = zcm_jdmatf_videogame=>game_successfully_returned
        "item_id = videogame-ItemID
        ).

      APPEND message TO reported-%other.

      DATA(rental) = rentals[ 1 ].

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( ReturnDate )
        WITH VALUE #( ( %tky = rental-%tky ReturnDate =  sy-datum ) ).

      " ------

      READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        BY \_Videogame
        FIELDS ( GameSystem )
        WITH CORRESPONDING #( keys )
        RESULT DATA(videogames1).

      LOOP AT videogames1 INTO DATA(videogame1).

        DATA SystemPrice TYPE p DECIMALS 2.
        "Konstanten
        CONSTANTS LowestPrice TYPE p DECIMALS 2 Value '0.30'.
        CONSTANTS MiddlePrice TYPE p DECIMALS 2 Value '0.50'.
        CONSTANTS HighestPrice TYPE p DECIMALS 2 Value '1.00'.

            case videogame1-GameSystem.
              "Playstation
              when 'PSP'. SystemPrice = LowestPrice.
              when 'PSX'. SystemPrice = LowestPrice.
              when 'PS2'. SystemPrice = LowestPrice.
              when 'PS3'. SystemPrice = LowestPrice.
              when 'PS4'. SystemPrice = MiddlePrice.
              when 'PS5'. SystemPrice = HighestPrice.
              "XBOX
              when 'X360'. SystemPrice = LowestPrice.
              when 'XONE'. SystemPrice = MiddlePrice.
              when 'XBSX'. SystemPrice = HighestPrice.
              "Nintendo
              when 'GB'. SystemPrice = LowestPrice.
              when 'GBA'. SystemPrice = LowestPrice.
              when 'NES'. SystemPrice = LowestPrice.
              when 'SNES'. SystemPrice = LowestPrice.
              when 'WII'. SystemPrice = LowestPrice.
              when 'DS'. SystemPrice = LowestPrice.
              when 'TDS'. SystemPrice = MiddlePrice.
              when 'NS'. SystemPrice = HighestPrice.
              "Computer
              when 'PC'. SystemPrice = HighestPrice.
              when others. " evtl. Fehlermeldung
            endcase.

        MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( RentalCharge )
        " +2 protects against fraud - it is not possible to lend a videogame for one day without paying
        WITH VALUE #( ( %tky = rental-%tky RentalCharge = systemPrice * ( sy-datum - Rental-StartDate ) + 2 ) ). " Anstatt aktuellem Datum hier ReturnDate nehmen? Wurde oben ja schon mit Wert befüllt

      ENDLOOP.

        MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( CukyField )
        WITH VALUE #( ( %tky = rental-%tky CukyField =  'EUR' ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD determineprocessnumber.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
     FIELDS ( ProcessNumber )
     WITH CORRESPONDING #( keys )
     RESULT DATA(rentals).

    LOOP AT rentals INTO DATA(rental).

      SELECT SINGLE FROM ZJDMATFRental
        FIELDS MAX( Process_Number ) AS max_process_number
        INTO @DATA(max_process_number).

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( ProcessNumber )
        WITH VALUE #( ( %tky = rental-%tky ProcessNumber = max_process_number + 1 ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD determinestartdate.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
     FIELDS ( StartDate )
     WITH CORRESPONDING #( keys )
     RESULT DATA(rentals).

    LOOP AT rentals INTO DATA(rental).

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( StartDate )
        WITH VALUE #( ( %tky = rental-%tky StartDate = sy-datum ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD determinestatus.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
     BY \_Videogame
     FIELDS ( Status )
     WITH CORRESPONDING #( keys )
     RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = videogame-%tky Status = 'L' ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZJDMATF_I_Videogame DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Videogame RESULT result. " Alias Videogame verwendet (hat Daniel nicht)
    METHODS determineitemid FOR DETERMINE ON SAVE
      IMPORTING keys FOR videogame~determineitemid.

ENDCLASS.

CLASS lhc_ZJDMATF_I_Videogame IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineitemid.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
     FIELDS ( ItemId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

      SELECT SINGLE FROM ZJDMATFVideogame
        FIELDS MAX( Item_Id ) AS max_item_id
        INTO @DATA(max_item_id).

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( ItemId )
        WITH VALUE #( ( %tky = videogame-%tky ItemId = max_item_id + 1 ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
