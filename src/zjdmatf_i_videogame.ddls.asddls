@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Videogame'
define root view entity ZJDMATF_I_Videogame
  as select from zjdmatfvideogame
  composition [0..*] of ZJDMATF_I_Rental as _Rentals
  association [1..1] to ZJDMATF_I_AverageRating as _AverageRating on $projection.VideogameUuid = _AverageRating.VideogameUuid
{
  key videogame_uuid  as VideogameUuid,
      item_id         as ItemId,
      genre           as Genre,
      title           as Title,
      game_system     as GameSystem,
      publishing_year as PublishingYear,
      //average_rating  as AverageRating,
      status          as Status,
      @EndUserText: { label: 'Image URL', quickInfo: 'Image URL' }
      @Semantics.imageUrl: true
      url             as Url,

      /* Transient Data */
      case status when 'A' then 3
                  when 'L' then 1
                  else 0
      end             as StatusCriticality,
      
      _AverageRating.AverageRatingCalculated as AverageRatingCalculated,
      

      /* Associations */
      _Rentals
}
