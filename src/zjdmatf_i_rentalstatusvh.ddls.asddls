@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Rental Status'
define view entity ZJDMATF_I_RENTALSTATUSVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJDMATF_RENTAL_STATUS' )
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
  key language,
      @EndUserText: { label: 'Rental Status', quickInfo: ' RentalStatus' }
      @ObjectModel.text.element: ['RentalStatusText']
      value_low as RentalStatus,
      @EndUserText: { label: 'Rental Status Text', quickInfo: 'Rental Status Text' }
      text      as RentalStatusText
}
