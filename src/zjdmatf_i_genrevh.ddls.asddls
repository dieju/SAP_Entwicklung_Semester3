@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Genre'

define view entity ZJDMATF_I_GENREVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJDMATF_GENRE' )
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
  key language,
      @EndUserText: { label: 'Genre', quickInfo: 'Genre' }
      @ObjectModel.text.element: ['GenreText']
      value_low as Genre,
      @EndUserText: { label: 'Genre Text', quickInfo: 'Genre Text' }
      text      as GenreText
}
