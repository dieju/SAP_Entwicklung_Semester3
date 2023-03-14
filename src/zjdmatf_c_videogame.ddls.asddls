@EndUserText.label: 'Projection View: Videogame'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZJDMATF_C_Videogame
  provider contract transactional_query
  as projection on ZJDMATF_I_Videogame
{
  key VideogameUuid,
      ItemId,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_GENREVH', element: 'Genre' } }]
      Genre,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      Title,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_SYSTEMVH', element: 'GameSystem' } }]
      GameSystem,
      PublishingYear,
      //AverageRating,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZJDMATF_I_STATUSVH', element: 'Status' } }]
      Status,
      AverageRatingCalculated,
      Url,
      
      /* Transient Data */
      StatusCriticality,
      
      
      /* Associations */
      _Rentals : redirected to composition child ZJDMATF_C_Rental
}
