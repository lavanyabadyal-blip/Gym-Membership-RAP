@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Trainer - Interface View'
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Trainer', typeNamePlural: 'Trainers',
                     title: { value: 'TrainerName' }, description: { value: 'TrainerId' } } }
define view entity ZI_GM_Trainer
  as select from zgm_trainer
{
      @UI.facet: [{ id: 'Trainer', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Trainer Details', position: 10 }]
      @UI: { lineItem: [{ position: 10 }], identification: [{ position: 10 }] }
      @ObjectModel.text.element: ['TrainerName']
  key trainer_id     as TrainerId,
      @UI: { lineItem: [{ position: 20 }], identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
      trainer_name   as TrainerName,
      @UI: { lineItem: [{ position: 30 }], identification: [{ position: 30 }] }
      specialization as Specialization,
      @UI: { lineItem: [{ position: 40 }], identification: [{ position: 40 }] }
      email          as Email,
      @UI: { identification: [{ position: 50 }] }
      phone          as Phone
}
