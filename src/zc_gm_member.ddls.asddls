@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Member - Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_GM_Member
  provider contract transactional_query
  as projection on ZI_GM_Member
{
  key MemberId,
      FirstName,
      LastName,
      FullName,
      Email,
      Phone,
      DateOfBirth,
      Gender,
      City,
      JoinDate
}
