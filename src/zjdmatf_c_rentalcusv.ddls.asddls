@EndUserText.label: 'Projection View: Rental'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZJDMATF_C_RENTALCUSV
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
      _Videogame.Title,
      _Videogame.GameSystem,
      _Videogame.Url,
     
      /* Transient Data */
      //ReturnDateCriticality,
      CustomerName
      
      /* Associations */
      //_Videogame : redirected to parent ZJDMATF_C_Videogame
}
