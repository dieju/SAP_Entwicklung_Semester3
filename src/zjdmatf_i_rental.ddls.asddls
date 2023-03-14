@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Rental'
define view entity ZJDMATF_I_Rental
  as select from zjdmatfrental
  association to parent ZJDMATF_I_Videogame as _Videogame on $projection.VideogameUuid = _Videogame.VideogameUuid 
  association [1..1] to ZJDMATF_I_CUSTOMERTEXT as _CustomerText on $projection.CustomerUuid = _CustomerText.CustomerUuid
{
  key rental_uuid    as RentalUuid,
      @ObjectModel.text.element: ['CustomerName']
      customer_uuid  as CustomerUuid,
      videogame_uuid as VideogameUuid,
      process_number as ProcessNumber,
      start_date     as StartDate,
      return_date    as ReturnDate,
      @Semantics.amount.currencyCode: 'CukyField'
      rental_charge  as RentalCharge,
      cuky_field     as CukyField,
      rating         as Rating,
      rental_status  as RentalStatus,
      
      /*Transient Data*/
      case when rental_status = 'A' then 3
           when rental_status = 'F' then 1
           else 0
      end                as RentalStatusCriticality,
      _CustomerText.Name as CustomerName,
      /* Associations */
      _Videogame
}
