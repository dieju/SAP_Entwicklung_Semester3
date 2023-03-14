@EndUserText.label: 'Projection View: Customer'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZJDMATF_C_Customer
  provider contract transactional_query
  as projection on ZJDMATF_I_Customer
{
  key CustomerUuid,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      CustomerId,
      Name,
      EntryDate
}
