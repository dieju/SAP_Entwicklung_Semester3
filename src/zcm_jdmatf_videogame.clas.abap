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
      BEGIN OF game_successfully_returned,
        msgid TYPE symsgid VALUE 'ZJDMATF_VIDEOGAME',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF game_successfully_returned.

    " erledigt: TODO: Define Attributs
    DATA videogame_id TYPE zjdmatf_item_id.
    DATA customer_id TYPE zjdmatf_customer_id.

    "Constructor
    METHODS constructor
      IMPORTING
        severity    TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid      LIKE if_t100_message=>t100key DEFAULT if_t100_message=>default_textid
        previous    LIKE previous OPTIONAL
        travel_id   TYPE /dmo/travel_id OPTIONAL
        customer_id TYPE /dmo/customer_id OPTIONAL. "TODO: Add Parameters

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcm_jdmatf_videogame IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    if_t100_message~t100key = textid.
    me->if_abap_behv_message~m_severity = severity.

    " erledigt TODO: Set Attributs
    me->videogame_id = travel_id.
    me->customer_id = customer_id.
  ENDMETHOD.
ENDCLASS.
