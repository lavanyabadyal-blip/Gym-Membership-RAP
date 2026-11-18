@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Membership Subscription - Interface View'
@Metadata.allowExtensions: true
define root view entity ZI_GM_Subscription
  as select from zgm_subscr
  association [0..1] to ZI_GM_Member   as _Member   on $projection.MemberId   = _Member.MemberId
  association [0..1] to ZI_GM_Plan     as _Plan     on $projection.PlanId     = _Plan.PlanId
  association [0..1] to ZI_GM_Trainer  as _Trainer  on $projection.TrainerId  = _Trainer.TrainerId
  association [0..1] to ZI_GM_Location as _Location on $projection.LocationId = _Location.LocationId
{
  key subscription_uuid      as SubscriptionUUID,
      subscription_no        as SubscriptionNo,
      member_id              as MemberId,
      plan_id                as PlanId,
      trainer_id             as TrainerId,
      location_id            as LocationId,
      start_date             as StartDate,
      end_date               as EndDate,
      @Semantics.amount.currencyCode: 'Currency'
      amount                 as Amount,
      currency               as Currency,
      status                 as Status,
      @Semantics.user.createdBy: true
      created_by             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by        as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,
      _Member,
      _Plan,
      _Trainer,
      _Location
}
