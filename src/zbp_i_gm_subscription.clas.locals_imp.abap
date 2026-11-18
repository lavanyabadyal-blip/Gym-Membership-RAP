CLASS lhc_Subscription DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Subscription
      RESULT result.

    METHODS calculateEndDateAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Subscription~calculateEndDateAmount.

    METHODS setSubscriptionNo FOR DETERMINE ON SAVE
      IMPORTING keys FOR Subscription~setSubscriptionNo.

    METHODS setStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Subscription~setStatus.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Subscription~validateDates.

    METHODS validateMembership FOR VALIDATE ON SAVE
      IMPORTING keys FOR Subscription~validateMembership.

    METHODS validateNoOverlap FOR VALIDATE ON SAVE
      IMPORTING keys FOR Subscription~validateNoOverlap.
ENDCLASS.


CLASS lhc_Subscription IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD calculateEndDateAmount.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( StartDate PlanId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    DATA update_tab TYPE TABLE FOR UPDATE zi_gm_subscription.

    LOOP AT subscriptions INTO DATA(sub).
      SELECT SINGLE duration_months, price, currency
        FROM zgm_plan
        WHERE plan_id = @sub-PlanId
        INTO @DATA(plan).

      DATA(end_date) = sub-StartDate.
      IF sub-StartDate IS NOT INITIAL AND plan-duration_months IS NOT INITIAL.
        DATA(months) = CONV i( plan-duration_months ).
        DATA(year)   = CONV i( sub-StartDate+0(4) ).
        DATA(month)  = CONV i( sub-StartDate+4(2) ).
        DATA(day)    = sub-StartDate+6(2).
        month = month + months.
        WHILE month > 12.
          month = month - 12.
          year  = year + 1.
        ENDWHILE.
        DATA(target) = |{ year WIDTH = 4 ALIGN = RIGHT PAD = '0' }{ month WIDTH = 2 ALIGN = RIGHT PAD = '0' }{ day }|.
        end_date = CONV d( target ) - 1.
      ENDIF.

      APPEND VALUE #( %tky             = sub-%tky
                      EndDate           = end_date
                      Amount            = plan-price
                      Currency          = plan-currency
                      %control-EndDate  = if_abap_behv=>mk-on
                      %control-Amount   = if_abap_behv=>mk-on
                      %control-Currency = if_abap_behv=>mk-on ) TO update_tab.
    ENDLOOP.

    MODIFY ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        UPDATE FIELDS ( EndDate Amount Currency )
        WITH update_tab
      REPORTED DATA(update_reported).
  ENDMETHOD.

  METHOD setSubscriptionNo.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( SubscriptionNo )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    DELETE subscriptions WHERE SubscriptionNo IS NOT INITIAL.
    CHECK subscriptions IS NOT INITIAL.

    SELECT MAX( subscription_no ) FROM zgm_subscr INTO @DATA(max_no).
    DATA(next) = CONV i( max_no+2 ).

    DATA update_tab TYPE TABLE FOR UPDATE zi_gm_subscription.
    LOOP AT subscriptions INTO DATA(sub).
      next += 1.
      APPEND VALUE #( %tky = sub-%tky
                      SubscriptionNo = |GM{ next WIDTH = 8 ALIGN = RIGHT PAD = '0' }|
                      %control-SubscriptionNo = if_abap_behv=>mk-on ) TO update_tab.
    ENDLOOP.

    MODIFY ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        UPDATE FIELDS ( SubscriptionNo )
        WITH update_tab
      REPORTED DATA(update_reported).
  ENDMETHOD.

  METHOD setStatus.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( EndDate Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    DATA update_tab TYPE TABLE FOR UPDATE zi_gm_subscription.
    LOOP AT subscriptions INTO DATA(sub).
      DATA(new_status) = COND string(
        WHEN sub-EndDate IS NOT INITIAL AND sub-EndDate < cl_abap_context_info=>get_system_date( )
        THEN 'EXPIRED' ELSE 'ACTIVE' ).

      APPEND VALUE #( %tky = sub-%tky
                      Status = new_status
                      %control-Status = if_abap_behv=>mk-on ) TO update_tab.
    ENDLOOP.

    MODIFY ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        UPDATE FIELDS ( Status )
        WITH update_tab
      REPORTED DATA(update_reported).
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( StartDate EndDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT subscriptions INTO DATA(sub).
      IF sub-StartDate IS INITIAL.
        APPEND VALUE #( %tky = sub-%tky ) TO failed-subscription.
        APPEND VALUE #( %tky = sub-%tky
                        %state_area = 'VALIDATE_DATES'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Start date must be entered' )
                        %element-StartDate = if_abap_behv=>mk-on )
               TO reported-subscription.
      ELSEIF sub-StartDate < today.
        APPEND VALUE #( %tky = sub-%tky ) TO failed-subscription.
        APPEND VALUE #( %tky = sub-%tky
                        %state_area = 'VALIDATE_DATES'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Start date must not be in the past' )
                        %element-StartDate = if_abap_behv=>mk-on )
               TO reported-subscription.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateMembership.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( MemberId PlanId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    LOOP AT subscriptions INTO DATA(sub).
      SELECT SINGLE @abap_true FROM zgm_member
        WHERE member_id = @sub-MemberId INTO @DATA(member_ok).
      IF member_ok = abap_false.
        APPEND VALUE #( %tky = sub-%tky ) TO failed-subscription.
        APPEND VALUE #( %tky = sub-%tky
                        %state_area = 'VALIDATE_MEMBERSHIP'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Member { sub-MemberId } does not exist| )
                        %element-MemberId = if_abap_behv=>mk-on )
               TO reported-subscription.
      ENDIF.

      SELECT SINGLE @abap_true FROM zgm_plan
        WHERE plan_id = @sub-PlanId INTO @DATA(plan_ok).
      IF plan_ok = abap_false.
        APPEND VALUE #( %tky = sub-%tky ) TO failed-subscription.
        APPEND VALUE #( %tky = sub-%tky
                        %state_area = 'VALIDATE_MEMBERSHIP'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Plan { sub-PlanId } does not exist| )
                        %element-PlanId = if_abap_behv=>mk-on )
               TO reported-subscription.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateNoOverlap.
    READ ENTITIES OF zi_gm_subscription IN LOCAL MODE
      ENTITY Subscription
        FIELDS ( MemberId StartDate EndDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(subscriptions).

    LOOP AT subscriptions INTO DATA(sub).
      SELECT SINGLE @abap_true
        FROM zgm_subscr
        WHERE member_id         = @sub-MemberId
          AND subscription_uuid <> @sub-SubscriptionUUID
          AND start_date       <= @sub-EndDate
          AND end_date         >= @sub-StartDate
        INTO @DATA(overlap).

      IF overlap = abap_true.
        APPEND VALUE #( %tky = sub-%tky ) TO failed-subscription.
        APPEND VALUE #( %tky = sub-%tky
                        %state_area = 'VALIDATE_OVERLAP'
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Member { sub-MemberId } already has an active membership in this period| )
                        %element-StartDate = if_abap_behv=>mk-on
                        %element-EndDate   = if_abap_behv=>mk-on )
               TO reported-subscription.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
