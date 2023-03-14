@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Text: Customer'

define view entity ZJDMATF_I_CUSTOMERTEXT
  as select from zjdmatfcustomer
{
  key customer_uuid as CustomerUuid,
      customer_id   as CustomerId,
      name          as Name,
      entry_date    as EntryDate
}
