CLASS zcm_jdmatf_videogame DEFINITION
  PUBLIC
INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "Interfaces
    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.

    " glaub erledigt: TODO: Define Message Constants
    CONSTANTS:
      BEGIN OF videogame_already_returned,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME', " Nachrichten-Klasse angeben
        msgno TYPE symsgno VALUE '001', " Auswahl der Nachricht
        attr1 TYPE scx_attrname VALUE 'ITEM_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF videogame_already_returned.

      CONSTANTS:
      BEGIN OF rental_already_finished,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'PROCESS_NUMBER',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF rental_already_finished.

    CONSTANTS:
      BEGIN OF game_successfully_returned,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'ITEM_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF game_successfully_returned.

      CONSTANTS:
      BEGIN OF invalid_publishing_year,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'PUBLISHING_YEAR',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_publishing_year.

      CONSTANTS:
      BEGIN OF invalid_status_on_create,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_status_on_create.

      CONSTANTS:
      BEGIN OF invalid_genre_on_create,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'GENRE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_genre_on_create.

      CONSTANTS:
      BEGIN OF invalid_system_on_create,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'GAME_SYSTEM',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_system_on_create.

      CONSTANTS:
      BEGIN OF invalid_rating,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'RATING',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_rating.

      CONSTANTS:
      BEGIN OF bad_rental_request,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF bad_rental_request.

    " erledigt: TODO: Define Attributs
    DATA item_id TYPE zjdmatf_item_id.
    DATA publishing_year TYPE zjdmatf_publishing_year.
    DATA genre TYPE zjdmatf_genre.
    DATA game_system TYPE zjdmatf_game_system.
    DATA rating TYPE zjdmatf_rating.
    DATA process_number TYPE zjdmatf_process_number.

    "Constructor
    METHODS constructor
      IMPORTING
        severity    TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid      LIKE if_t100_message=>t100key DEFAULT if_t100_message=>default_textid
        previous    LIKE previous OPTIONAL
        item_id   TYPE zjdmatf_item_id OPTIONAL
        publishing_year TYPE zjdmatf_publishing_year OPTIONAL
        genre TYPE zjdmatf_genre OPTIONAL
        game_system TYPE zjdmatf_game_system OPTIONAL
        rating TYPE zjdmatf_rating OPTIONAL
        process_number TYPE zjdmatf_process_number OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcm_jdmatf_videogame IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    if_t100_message~t100key = textid.
    me->if_abap_behv_message~m_severity = severity.

    " erledigt TODO: Set Attributs
    me->item_id = item_id.
    me->publishing_year = publishing_year.
    me->genre = genre.
    me->game_system = game_system.
    me->rating = rating.
    me->process_number = process_number.
  ENDMETHOD.
ENDCLASS.
