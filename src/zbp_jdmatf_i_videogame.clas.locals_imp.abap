CLASS lhc_zjdmatf_i_rental DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Rental RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Rental RESULT result.

    METHODS determineProcessNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineProcessNumber.

    METHODS determineStartDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineStartDate.

    METHODS determineStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR rental~determineStatus.

    METHODS return_videogame FOR MODIFY
      IMPORTING keys FOR ACTION Rental~return_videogame.
    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR Rental~validateRating.
    METHODS determineRating FOR DETERMINE ON SAVE
      IMPORTING keys FOR Rental~determineRating.

ENDCLASS.

CLASS lhc_zjdmatf_i_rental IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
       FIELDS ( RentalStatus )
       WITH CORRESPONDING #( keys )
       RESULT DATA(rentals).

    result = VALUE #( FOR rental IN rentals
                  ( %tky                  = rental-%tky
                    %delete               = COND #( WHEN rental-RentalStatus = 'A'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )
                  ) ).
  ENDMETHOD.

  METHOD return_videogame.

    "Deklarationen
    DATA rentals TYPE TABLE FOR READ RESULT ZJDMATF_I_Rental.

    "Lesen der Daten
    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
      BY \_Videogame
      FIELDS ( Status ItemId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(videogames)

      FIELDS ( StartDate ReturnDate RentalCharge RentalStatus ProcessNumber )
      WITH CORRESPONDING #( keys )
      RESULT rentals.

    LOOP AT videogames INTO DATA(videogame).

     DATA(rental) = rentals[ 1 ].

      " Fehler ausgeben, wenn der Status des Videogames available ist:
      IF videogame-status = 'A'.

        DATA(message) = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>videogame_already_returned
          item_id = videogame-ItemId
          ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( videogame ) TO failed-videogame.
        CONTINUE.
      ENDIF.

      " Fehler ausgeben, wenn der gewählte Verleihvorgang bereits beendet ist
      IF rental-rentalstatus = 'F'.

          message = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>rental_already_finished
          process_number = rental-ProcessNumber
          ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( videogame ) TO failed-videogame.
        CONTINUE.
      ENDIF.

      " Videogame Status auf available setzen, falls keine der oberen Fehlermöglichkeiten zutrifft -> Videospiel wurde erfolgreich zurückgegeben
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = videogame-%tky Status = 'A' ) ).

      " Erfolgsmeldung ausgeben
      message = NEW zcm_jdmatf_videogame(
        severity = if_abap_behv_message=>severity-success
        textid   = zcm_jdmatf_videogame=>game_successfully_returned
        item_id = videogame-ItemID
        ).

      APPEND message TO reported-%other.

      " Read-Only Felder befüllen:

      " Return-Date automatisch auf heutigen Tag setzen
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( ReturnDate )
        WITH VALUE #( ( %tky = rental-%tky ReturnDate =  sy-datum ) ).

      " Preis des Verleihvorgangs je nach System festlegen
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
              when others.
            endcase.

        MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( RentalCharge )
        " 2€ Startgebühr zuzüglich Leihgebühr pro Tag je nach System (siehe oben)
        WITH VALUE #( ( %tky = rental-%tky RentalCharge = systemPrice * ( sy-datum - Rental-StartDate ) + 2 ) ).

      ENDLOOP.

        " EUR in das Währungsfeld eintragen
        MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( CukyField )
        WITH VALUE #( ( %tky = rental-%tky CukyField =  'EUR' ) ).

    ENDLOOP.

      " Rental Status auf abgeschlossen setzen
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( RentalStatus )
        WITH VALUE #( ( %tky = rental-%tky RentalStatus =  'F' ) ).

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

      " Festlegen der ersten ID in der Datenbank -> erste ID dadurch 30000001
      if max_process_number = 0.
        max_process_number = 30000000.
      endif.

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

      " StartDate auf heutigen Tag setzen
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

      " Validierung: Wenn das Videogame bereits ausgeliehen ist, soll das das Ausleihen nicht mehr möglich sein
      IF videogame-Status = 'L'.
        DATA(message) = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>bad_rental_request ).

        APPEND message TO reported-%other.
        CONTINUE.
      ENDIF.

      " Nach dem Erstellen eines Verleihvorgangs Status auf ausgeliehen setzen
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = videogame-%tky Status = 'L' ) ).

    ENDLOOP.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
     FIELDS ( RentalStatus )
     WITH CORRESPONDING #( keys )
     RESULT DATA(rentals).

    LOOP AT rentals INTO DATA(rental).

      " Rental Status auf aktiv setzen, nachdem ein neuer Verleihvorgang angelegt wurde
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( RentalStatus )
        WITH VALUE #( ( %tky = rental-%tky RentalStatus = 'A' ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validateRating.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
      FIELDS ( Rating )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentals).

    LOOP AT rentals INTO DATA(rental).

      "Nur Felder aus der Wertehilfe erlauben
      IF ( rental-Rating <> 'X' ) AND ( rental-Rating < '1' OR rental-Rating > '5' ) .
        DATA(message) = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>invalid_rating
          rating = rental-Rating ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( rental ) TO failed-rental.
        CONTINUE.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD determineRating.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Rental
     FIELDS ( Rating )
     WITH CORRESPONDING #( keys )
     RESULT DATA(rentals).

    LOOP AT rentals INTO DATA(rental).

     "Rating beim Anlegen eines Verleihvorgangs immer auf X (not rated) setzen -> nur nachträglich kann ein anderes Rating gesetzt werden
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Rental
        UPDATE FIELDS ( Rating )
        WITH VALUE #( ( %tky = rental-%tky Rating = 'X' ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

" ----------------------------------------------------------------------------------

CLASS lhc_ZJDMATF_I_Videogame DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Videogame RESULT result. " Alias Videogame verwendet (hat Daniel nicht)
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Videogame RESULT result.
    METHODS determineitemid FOR DETERMINE ON SAVE
      IMPORTING keys FOR videogame~determineitemid.
    METHODS validatepublishingyear FOR VALIDATE ON SAVE
      IMPORTING keys FOR videogame~validatepublishingyear.
    METHODS validategenre FOR VALIDATE ON SAVE
      IMPORTING keys FOR videogame~validategenre.
    METHODS determinestatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR videogame~determinestatus.
    METHODS validategamesystem FOR VALIDATE ON SAVE
      IMPORTING keys FOR videogame~validategamesystem.

ENDCLASS.

CLASS lhc_ZJDMATF_I_Videogame IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(videogames).

    result = VALUE #( FOR videogame IN videogames
                  ( %tky                  = videogame-%tky
                    %delete               = COND #( WHEN videogame-Status = 'L'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )
                  ) ).

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

      " Festlegen der ersten ID in der Datenbank -> erste ID dadurch 10000001
      if max_item_id = 0.
        max_item_id = 10000000.
      endif.

      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( ItemId )
        WITH VALUE #( ( %tky = videogame-%tky ItemId = max_item_id + 1 ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validatePublishingYear.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
      FIELDS ( PublishingYear )
      WITH CORRESPONDING #( keys )
      RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

      " Nur Jahre zwischen 1960 und aktuellem Jahr sollen erlaubt sein
      IF videogame-PublishingYear < 1960 OR videogame-PublishingYear > sy-datum(4).
        DATA(message) = NEW zcm_jdmatf_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_jdmatf_videogame=>invalid_publishing_year
          publishing_year = videogame-PublishingYear ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( videogame ) TO failed-videogame.
        CONTINUE.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateGenre.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
      FIELDS ( Genre )
      WITH CORRESPONDING #( keys )
      RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

        " Nur Felder aus der Wertehilfe erlauben
        CASE videogame-Genre.
          WHEN 'Action' OR 'Adventure' OR 'Puzzle' OR 'Role Play' OR 'Simulation' OR 'Strategy' OR 'Sports' OR 'Racing'.
          WHEN OTHERS.
            DATA(message) = NEW zcm_jdmatf_videogame(
              severity = if_abap_behv_message=>severity-error
              textid   = zcm_jdmatf_videogame=>invalid_genre_on_create
              genre = videogame-Genre ).

            APPEND message TO reported-%other.
            APPEND CORRESPONDING #( videogame ) TO failed-videogame.

        ENDCASE.
            CONTINUE.
    ENDLOOP.

  ENDMETHOD.

  METHOD determineStatus.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
     FIELDS ( Status )
     WITH CORRESPONDING #( keys )
     RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

      " Beim Erstellen eiens Videogames den Status auf available setzen
      MODIFY ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = videogame-%tky Status = 'A' ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validateGameSystem.

    READ ENTITY IN LOCAL MODE ZJDMATF_I_Videogame
      FIELDS ( GameSystem )
      WITH CORRESPONDING #( keys )
      RESULT DATA(videogames).

    LOOP AT videogames INTO DATA(videogame).

        " Nur Felder aus der Wertehilfe erlauben
        CASE videogame-GameSystem.
          WHEN 'PS2' OR 'DS' OR 'GB' OR 'PS4' OR 'NS' OR 'PSX' OR 'WII' OR 'PS3' OR 'X360' OR 'GBA' OR 'PSP' OR 'TDS' OR 'NES' OR 'XONE' OR 'SNES' OR 'PS5' OR 'XBSX' OR 'PC'.
          WHEN OTHERS.
            DATA(message) = NEW zcm_jdmatf_videogame(
              severity = if_abap_behv_message=>severity-error
              textid   = zcm_jdmatf_videogame=>invalid_system_on_create
              game_system = videogame-GameSystem ).

            APPEND message TO reported-%other.
            APPEND CORRESPONDING #( videogame ) TO failed-videogame.

        ENDCASE.
            CONTINUE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
