SubscriptionCreator = 

  init: (public_key) ->
    @_initCardValidation()
    @_initDatePicker()
    @_initPlan()
    @_initRecurly(public_key)

  _initCardValidation: ->
    $('#user_subscription_creator_phone_number').formance('format_phone_number')
    $('#user_subscription_creator_member_number').formance('format_number')
    $('#number').formance('format_credit_card_number')

  _initDatePicker: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initRecurly: (public_key) ->
    recurly.configure public_key

    $(document).on 'submit', '.new_user_subscription_creator', (e) ->
      e.preventDefault()
      form = this
      
      recurly.token form, (err, token) ->
        if err
          sweetAlert('Oops...', err.message, 'error');
        else
          form.submit()

  _initPlan: ->
    $(document).on 'change', '#user_subscription_creator_plan_id', (e) ->
      id = $(@).val()
      $.ajax
        url: "/user/plans/#{id}"
        format: 'JSON'
        method: 'GET'
        success: (response) ->
          if response.plan_type is 'shipped'
            $('#shipping-info').removeClass('hidden')
            $('#location-info').addClass('hidden')
            $('#shipping-info input').attr('required', true)
            $('#user_subscription_creator_street_address_2').attr('required', false)
            $('#location-info select').attr('required', false)
          else if response.plan_type is 'local_pick_up'
            $('#shipping-info').addClass('hidden')
            $('#location-info').removeClass('hidden')
            $('#shipping-info input').attr('required', false)
            $('#location-info select').attr('required', true)
        error: (response) ->

  _shippingAddress: ->
    address = "#{$('#subscription_wizard_street_address').val()}<br/>"
    address += "#{$('#subscription_wizard_street_address_2').val()}<br/>" if $('#subscription_wizard_street_address_2').val()
    address += "#{$('#subscription_wizard_city').val()}, #{$('#subscription_wizard_state_code').val()} #{$('#subscription_wizard_zip').val()}"
    address

  _billingAddress: ->
    address = "#{$('#address1').val()}<br/>"
    address += "#{$('#address2').val()}<br/>" if $('#address2').val()
    address += "#{$('#city').val()}, #{$('#state').val()} #{$('#postal_code').val()}"
    address

window.SubscriptionCreator = SubscriptionCreator