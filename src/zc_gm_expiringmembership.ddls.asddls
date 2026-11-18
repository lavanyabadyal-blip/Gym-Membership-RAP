@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expiring / Overdue Memberships'
@Metadata.allowExtensions: true
@UI.headerInfo: { typeName: 'Expiring Membership', typeNamePlural: 'Expiring Memberships' }
define view entity ZC_GM_ExpiringMembership
  as select from zgm_subscr as sub
  inner join   zgm_member  as mem on mem.member_id = sub.member_id
  inner join   zgm_plan    as pln on pln.plan_id   = sub.plan_id
{
      @UI.hidden: true
  key sub.subscription_uuid                                   as SubscriptionUUID,
      @UI.lineItem: [{ position: 10, label: 'Membership No' }]
      sub.subscription_no                                     as SubscriptionNo,
      @UI.lineItem: [{ position: 30, label: 'Member' }]
      concat_with_space(mem.first_name, mem.last_name, 1)     as MemberName,
      @UI.lineItem: [{ position: 40, label: 'Plan' }]
      pln.plan_name                                           as PlanName,
      @UI.lineItem: [{ position: 50, label: 'End Date' }]
      sub.end_date                                            as EndDate,
      @UI.lineItem: [{ position: 60, label: 'Days Left' }]
      dats_days_between( $session.system_date, sub.end_date ) as DaysLeft,
      @UI.lineItem: [{ position: 70, label: 'Status', criticality: 'ExpiryCriticality' }]
      case
        when sub.end_date <  $session.system_date then 'OVERDUE'
        when dats_days_between( $session.system_date, sub.end_date ) <= 30 then 'EXPIRING SOON'
        else 'OK'
      end                                                     as ExpiryStatus,
      // 1 = red (overdue), 2 = yellow (expiring soon), 3 = green (ok)
      case
        when sub.end_date <  $session.system_date then 1
        when dats_days_between( $session.system_date, sub.end_date ) <= 30 then 2
        else 3
      end                                                     as ExpiryCriticality
}
where sub.end_date < dats_add_days( $session.system_date, 30, 'NULL' )
