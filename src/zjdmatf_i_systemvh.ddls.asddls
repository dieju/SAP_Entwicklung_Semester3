@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: System'
define view entity ZJDMATF_I_SYSTEMVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJDMATF_GAME_SYSTEM' )
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
  key language,
      @EndUserText: { label: 'Game System', quickInfo: 'Game System' }
      @ObjectModel.text.element: ['GameSystem']
      value_low as GameSystem,
      @EndUserText: { label: 'Game System Text', quickInfo: 'Game System Text' }
      text      as GameSystemText
}
