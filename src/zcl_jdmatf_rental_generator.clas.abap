CLASS zcl_jdmatf_rental_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JDMATF_RENTAL_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.   " Main-Methode implementieren, sodass Klasse ausführbar wird

  "Datenobjekte deklarieren
  DATA customer Type zjdmatfcustomer.
  DATA customers TYPE TABLE OF zjdmatfcustomer.

  DATA videogame TYPE zjdmatfvideogame.
  DATA videogames TYPE TABLE OF zjdmatfvideogame.

  DATA rental TYPE zjdmatfrental.
  DATA rentals TYPE TABLE OF zjdmatfrental.

  "Alle Daten der Datenbanktabellen löschen

  "lieber mal auskommentiert -> wird diese Klasse ausgeführt sind sonst alle über die Oberfläche eingefügten Datensätze weg!
    "DELETE FROM zjdmatfcustomer.
    "out->write( |deleteted customer: {  sy-dbcnt }| ).
    "DELETE FROM zjdmatfvideogame.
    "out->write( |deleteted videgame: {  sy-dbcnt }| ).
    "DELETE FROM zjdmatfrental.
    "out->write( |deleteted rental: {  sy-dbcnt }| ).

  "Interne Tabellen befüllen
    "Struktur befüllen (1) -> customer and videogame
  customer-client = sy-mandt.
  customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  customer-customer_id = '00000001'.
  customer-name = 'Anna Bolika'.
  customer-entry_date = '20230119'.
  APPEND customer TO customers.

  videogame-client = sy-mandt.
  videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  videogame-item_id = '00000001'.
  videogame-genre = 'JUMP N Runs'.
  videogame-title = 'Ratchet & Clank'.
  videogame-game_system = 'PS4'.
  videogame-publishing_year = '2016'.
  "videogame-average_rating = '4'.
  videogame-status = 'l'. " = lent / andere Möglichkeit: a = available
  APPEND videogame TO videogames.

  "Unterstruktur befüllen (1-2)
  rental-client = sy-mandt.
  rental-rental_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  rental-videogame_uuid = videogame-videogame_uuid. " Fremdschlüssel
  rental-customer_uuid = customer-customer_uuid. " Fremdschlüssel
  rental-process_number = '00000001'.
  rental-start_date = '20230109'.
  rental-return_date = '20230113'.
  rental-rental_charge = '25'. " 5 Tage * 5€ (fester Wert Bsp.)
  rental-cuky_field = 'EUR'.
  APPEND rental TO rentals.

  "Interne Tabellen befüllen
    "Struktur befüllen (1) -> customer and videogame
  customer-client = sy-mandt.
  customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  customer-customer_id = '00000002'.
  customer-name = 'Rainer Zufall'.
  customer-entry_date = '20230125'.
  APPEND customer TO customers.

  videogame-client = sy-mandt.
  videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  videogame-item_id = '00000002'.
  videogame-genre = 'SPORTS'.
  videogame-title = 'FIFA 23'.
  videogame-game_system = 'PS5'.
  videogame-publishing_year = '2022'.
  "videogame-average_rating = '1'.
  videogame-status = 'l'. " = lent / andere Möglichkeit: a = available
  APPEND videogame TO videogames.

  "Unterstruktur befüllen (1-2)
  rental-client = sy-mandt.
  rental-rental_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  rental-videogame_uuid = videogame-videogame_uuid. " Fremdschlüssel
  rental-customer_uuid = customer-customer_uuid. " Fremdschlüssel
  rental-process_number = '00000002'.
  rental-start_date = '20230125'.
  rental-return_date = '20230128'.
  rental-rental_charge = '20'.
  rental-cuky_field = 'EUR'.
  APPEND rental TO rentals.

  "Interne Tabellen befüllen
    "Struktur befüllen (1) -> customer and videogame
  customer-client = sy-mandt.
  customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  customer-customer_id = '00000003'.
  customer-name = 'Ernst Haft'.
  customer-entry_date = '20230124'.
  APPEND customer TO customers.

  videogame-client = sy-mandt.
  videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  videogame-item_id = '00000003'.
  videogame-genre = 'Sports'.
  videogame-title = 'Fifa 22'.
  videogame-game_system = 'PS4'.
  videogame-publishing_year = '2021'.
  "videogame-average_rating = '1'.
  videogame-status = 'a'. " = lent / andere Möglichkeit: a = available
  APPEND videogame TO videogames.

  "Unterstruktur befüllen (1-2)
  rental-client = sy-mandt.
  rental-rental_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  rental-videogame_uuid = videogame-videogame_uuid. " Fremdschlüssel
  rental-customer_uuid = customer-customer_uuid. " Fremdschlüssel
  rental-process_number = '00000003'.
  rental-start_date = '20230125'.
  rental-return_date = '20230128'.
  rental-rental_charge = '20'. " 4 Tage * 5€ (fester Wert Bsp.)
  rental-cuky_field = 'EUR'.
  APPEND rental TO rentals.

  "Interne Tabellen befüllen
    "Struktur befüllen (1) -> customer and videogame
  "Unterstruktur befüllen (1-2)
  rental-client = sy-mandt.
  rental-rental_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  rental-videogame_uuid = videogame-videogame_uuid. " Fremdschlüssel
  rental-customer_uuid = customer-customer_uuid. " Fremdschlüssel
  rental-process_number = '00000004'.
  rental-start_date = '20230129'.
  rental-return_date = '20230130'.
  rental-rental_charge = '10'. " 2 Tage * 5€ (fester Wert Bsp.)
  rental-cuky_field = 'EUR'.
  APPEND rental TO rentals.


   "Interne Tabellen in die Datenbanktabellen einfügen
   INSERT zjdmatfcustomer FROM TABLE @customers.
   out->write( |inserted customers: {  sy-dbcnt }| ).
   INSERT zjdmatfvideogame FROM TABLE @videogames.
   out->write( |inserted videogames: {  sy-dbcnt }| ).
   INSERT zjdmatfrental FROM TABLE @rentals.
   out->write( |inserted rental: {  sy-dbcnt }| ).


  ENDMETHOD.
ENDCLASS.
