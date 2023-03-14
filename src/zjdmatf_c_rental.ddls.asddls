@EndUserText.label: 'Projection View: Rental'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZJDMATF_C_Rental
  as projection on ZJDMATF_I_Rental
{
  key RentalUuid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_CUSTOMERVH', element: 'CustomerUuid' } }]
      CustomerUuid,
      VideogameUuid,
      ProcessNumber,
      StartDate,
      ReturnDate,
      RentalCharge,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      CukyField,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_CRATINGVH', element: 'Rating' } }]
      Rating,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_RENTALSTATUSVH', element: 'RentalStatus' } }]
      RentalStatus,
      //_Videogame.ItemId,
      
      /* Transient Data */
      RentalStatusCriticality,
      CustomerName,
      
      /* Associations */
      _Videogame : redirected to parent ZJDMATF_C_Videogame
}
