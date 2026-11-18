@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Member - Interface View'
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Member', typeNamePlural: 'Members',
                     title: { value: 'FullName' }, description: { value: 'MemberId' } } }
define root view entity ZI_GM_Member
  as select from zgm_member
{
      @UI.facet: [{ id: 'Member', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Member Details', position: 10 }]
      @UI: { lineItem: [{ position: 10 }], identification: [{ position: 10 }] }
      @ObjectModel.text.element: ['FullName']
  key member_id                                   as MemberId,
      @UI: { lineItem: [{ position: 20 }], identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
      first_name                                  as FirstName,
      @UI: { lineItem: [{ position: 30 }], identification: [{ position: 30 }] }
      last_name                                   as LastName,
      concat_with_space(first_name, last_name, 1) as FullName,
      @UI: { lineItem: [{ position: 40 }], identification: [{ position: 40 }] }
      email                                       as Email,
      @UI: { identification: [{ position: 50 }] }
      phone                                       as Phone,
      @UI: { identification: [{ position: 60 }] }
      date_of_birth                               as DateOfBirth,
      @UI: { identification: [{ position: 70 }] }
      gender                                      as Gender,
      @UI: { lineItem: [{ position: 50 }], identification: [{ position: 80 }] }
      city                                        as City,
      @UI: { identification: [{ position: 90 }] }
      join_date                                   as JoinDate
}
