CLASS zcl_gm_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_gm_data_generator IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    " clear existing demo data
    DELETE FROM zgm_subscr.
    DELETE FROM zgm_member.
    DELETE FROM zgm_plan.
    DELETE FROM zgm_trainer.
    DELETE FROM zgm_location.

    " ---- members ----
    INSERT zgm_member FROM TABLE @( VALUE #(
      ( member_id = 'M0001' first_name = 'Lavanya'  last_name = 'Badyal' email = 'lavanya.badyal@mail.com'  phone = '+49 151 111' gender = 'F' city = 'Mannheim'     join_date = '20250115' date_of_birth = '20010225' )
      ( member_id = 'M0002' first_name = 'Sudanshu' last_name = 'Sindhu' email = 'sudanshu.sindhu@mail.com'  phone = '+49 151 222' gender = 'M' city = 'Heidelberg'    join_date = '20250201' date_of_birth = '19900712' )
      ( member_id = 'M0003' first_name = 'Clara'    last_name = 'Schulz' email = 'clara.schulz@mail.com'    phone = '+49 151 333' gender = 'F' city = 'Heidelberg'    join_date = '20250310' date_of_birth = '19981101' )
      ( member_id = 'M0004' first_name = 'David'    last_name = 'Wagner' email = 'david.wagner@mail.com'    phone = '+49 151 444' gender = 'M' city = 'Ludwigshafen' join_date = '20250405' date_of_birth = '19870528' )
    ) ).

    " ---- plans ----
    INSERT zgm_plan FROM TABLE @( VALUE #( currency = 'EUR'
      ( plan_id = 'P01' plan_name = 'Basic Monthly'   description = 'Gym access only'                duration_months = 1  price = '29.90'  access_level = 'BASIC' )
      ( plan_id = 'P02' plan_name = 'Premium Quarter' description = 'Gym + classes'                  duration_months = 3  price = '79.00'  access_level = 'PREMIUM' )
      ( plan_id = 'P03' plan_name = 'VIP Annual'      description = 'All access + personal trainer' duration_months = 12 price = '499.00' access_level = 'VIP' )
    ) ).

    " ---- trainers ----
    INSERT zgm_trainer FROM TABLE @( VALUE #(
      ( trainer_id = 'T01' trainer_name = 'Marco Rossi'  specialization = 'Strength' email = 'marco@gym.com' phone = '+49 160 100' )
      ( trainer_id = 'T02' trainer_name = 'Lena Fischer' specialization = 'Yoga'     email = 'lena@gym.com'  phone = '+49 160 200' )
      ( trainer_id = 'T03' trainer_name = 'Omar Haddad'  specialization = 'Cardio'   email = 'omar@gym.com'  phone = '+49 160 300' )
    ) ).

    " ---- locations ----
    INSERT zgm_location FROM TABLE @( VALUE #(
      ( location_id = 'L01' location_name = 'Downtown Studio' city = 'Heidelberg' address = 'Hauptstr. 1'  capacity = 150 )
      ( location_id = 'L02' location_name = 'Riverside Club'  city = 'Mannheim'   address = 'Rheinstr. 22' capacity = 220 )
    ) ).

    " ---- subscriptions ----
    " Mix of expired, expiring-soon and long-running. Periods per member do not overlap.
    " status is DERIVED from end_date below, so the app and the report never disagree.
    DATA subs TYPE STANDARD TABLE OF zgm_subscr.
    subs = VALUE #( currency = 'EUR'
      ( subscription_no = 'GM00000001' member_id = 'M0001' plan_id = 'P03' trainer_id = 'T02' location_id = 'L01' start_date = '20250101' end_date = '20251231' amount = '499.00' )
      ( subscription_no = 'GM00000002' member_id = 'M0001' plan_id = 'P01' trainer_id = 'T01' location_id = 'L01' start_date = '20261110' end_date = '20261209' amount = '29.90' )
      ( subscription_no = 'GM00000003' member_id = 'M0002' plan_id = 'P02' trainer_id = 'T03' location_id = 'L02' start_date = '20250601' end_date = '20250831' amount = '79.00' )
      ( subscription_no = 'GM00000004' member_id = 'M0002' plan_id = 'P03' trainer_id = 'T01' location_id = 'L02' start_date = '20260201' end_date = '20270131' amount = '499.00' )
      ( subscription_no = 'GM00000005' member_id = 'M0003' plan_id = 'P01' trainer_id = 'T02' location_id = 'L01' start_date = '20260801' end_date = '20260831' amount = '29.90' )
      ( subscription_no = 'GM00000006' member_id = 'M0003' plan_id = 'P02' trainer_id = 'T03' location_id = 'L01' start_date = '20261101' end_date = '20270131' amount = '79.00' )
      ( subscription_no = 'GM00000007' member_id = 'M0004' plan_id = 'P01' trainer_id = 'T01' location_id = 'L02' start_date = '20260901' end_date = '20260930' amount = '29.90' )
      ( subscription_no = 'GM00000008' member_id = 'M0004' plan_id = 'P01' trainer_id = 'T02' location_id = 'L02' start_date = '20261115' end_date = '20261214' amount = '29.90' )
    ).

    LOOP AT subs ASSIGNING FIELD-SYMBOL(<s>).
      <s>-subscription_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      <s>-status            = COND #( WHEN <s>-end_date < today THEN 'EXPIRED' ELSE 'ACTIVE' ).
    ENDLOOP.

    INSERT zgm_subscr FROM TABLE @subs.

    COMMIT WORK.

    out->write( |Gym demo data created: 4 members, 3 plans, 3 trainers, 2 locations, { lines( subs ) } subscriptions.| ).

  ENDMETHOD.
ENDCLASS.

