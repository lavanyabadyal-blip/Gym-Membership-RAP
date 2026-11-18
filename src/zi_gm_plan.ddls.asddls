@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Membership Plan - Interface View'
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Plan', typeNamePlural: 'Plans',
                     title: { value: 'PlanName' }, description: { value: 'PlanId' } } }
define view entity ZI_GM_Plan
  as select from zgm_plan
{
      @UI.facet: [{ id: 'Plan', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Plan Details', position: 10 }]
      @UI: { lineItem: [{ position: 10 }], identification: [{ position: 10 }] }
      @ObjectModel.text.element: ['PlanName']
  key plan_id                 as PlanId,
      @UI: { lineItem: [{ position: 20 }], identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
      plan_name               as PlanName,
      @UI: { lineItem: [{ position: 30 }], identification: [{ position: 30 }] }
      description             as Description,
      @UI: { lineItem: [{ position: 40 }], identification: [{ position: 40 }] }
      duration_months         as DurationMonths,
      @UI: { lineItem: [{ position: 50 }], identification: [{ position: 50 }] }
      @Semantics.amount.currencyCode: 'Currency'
      price                   as Price,
      currency                as Currency,
      @UI: { lineItem: [{ position: 60 }], identification: [{ position: 60 }] }
      access_level            as AccessLevel
}
