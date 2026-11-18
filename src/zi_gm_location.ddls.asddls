@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Location - Interface View'
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Location', typeNamePlural: 'Locations',
                     title: { value: 'LocationName' }, description: { value: 'LocationId' } } }
define view entity ZI_GM_Location
  as select from zgm_location
{
      @UI.facet: [{ id: 'Location', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Location Details', position: 10 }]
      @UI: { lineItem: [{ position: 10 }], identification: [{ position: 10 }] }
      @ObjectModel.text.element: ['LocationName']
  key location_id   as LocationId,
      @UI: { lineItem: [{ position: 20 }], identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
      location_name as LocationName,
      @UI: { lineItem: [{ position: 30 }], identification: [{ position: 30 }] }
      city          as City,
      @UI: { lineItem: [{ position: 40 }], identification: [{ position: 40 }] }
      address       as Address,
      @UI: { lineItem: [{ position: 50 }], identification: [{ position: 50 }] }
      capacity      as Capacity
}
