@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Membership Subscription - Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_GM_Subscription
  provider contract transactional_query
  as projection on ZI_GM_Subscription
{
  key SubscriptionUUID,
      SubscriptionNo,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GM_Member', element: 'MemberId' } }]
      @ObjectModel.text.element: ['MemberName']
      @UI.textArrangement: #TEXT_FIRST
      @Search.defaultSearchElement: true
      MemberId,
      _Member.FullName as MemberName,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GM_Plan', element: 'PlanId' } }]
      @ObjectModel.text.element: ['PlanName']
      @UI.textArrangement: #TEXT_FIRST
      PlanId,
      _Plan.PlanName as PlanName,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GM_Trainer', element: 'TrainerId' } }]
      @ObjectModel.text.element: ['TrainerName']
      @UI.textArrangement: #TEXT_FIRST
      TrainerId,
      _Trainer.TrainerName as TrainerName,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GM_Location', element: 'LocationId' } }]
      @ObjectModel.text.element: ['LocationName']
      @UI.textArrangement: #TEXT_FIRST
      LocationId,
      _Location.LocationName as LocationName,

      StartDate,
      EndDate,
      @Semantics.amount.currencyCode: 'Currency'
      Amount,
      Currency,
      Status,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Member,
      _Plan,
      _Trainer,
      _Location
}
