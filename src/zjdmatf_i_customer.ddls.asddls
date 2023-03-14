@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Customer'
define root view entity ZJDMATF_I_Customer
  as select from zjdmatfcustomer
{
  key customer_uuid as CustomerUuid,
      customer_id   as CustomerId,
      name          as Name,
      entry_date    as EntryDate
}
