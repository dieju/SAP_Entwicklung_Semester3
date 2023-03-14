@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: CRating'
define view entity ZJDMATF_I_CRatingVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJDMATF_RENTAL_RATING')
{
    @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
  key language,
      @EndUserText: { label: 'Rating', quickInfo: 'Rating' }
      @ObjectModel.text.element: ['RatingText']
      value_low as Rating,
      @EndUserText: { label: 'Rating Text', quickInfo: 'Rating Text' }
      text      as RatingText
}
