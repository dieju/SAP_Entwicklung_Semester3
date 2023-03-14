@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Customer'

define view entity ZJDMATF_I_CUSTOMERVH
  as select from zjdmatfcustomer
{
      @ObjectModel.text.element: ['Name']
  key customer_uuid as CustomerUuid,
      customer_id   as CustomerId,
      name          as Name,
      entry_date    as EntryDate
}
