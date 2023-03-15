@EndUserText.label: 'Interface View: Average Rating'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZJDMATF_I_AverageRating
  as select from zjdmatfrental
{
  key videogame_uuid                                            as VideogameUuid,
      cast(round((sum( cast(rating as abap.int1) ) / count(*)),2) as abap.char( 4 )) as AverageRatingCalculated
      -- rundet auf zwei Nachkommastellen
} 
where
  rating <> 'X' --and rating <> ''
group by
  videogame_uuid
