SubscriptionCreator = 

  init: (public_key) ->
    @_initCardValidation()
    @_initDatePicker()
    @_initRecurly(public_key)
    @_initSameAsShipping()

  _initCardValidation: ->
    $('#user_subscription_creator_phone_number').formance('format_phone_number')
    $('#user_subscription_creator_member_number').formance('format_number')
    $('#number').formance('format_credit_card_number')

  _initDatePicker: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initRecurly: (public_key) ->
    recurly.configure public_key

    $(document).on 'submit', '.new_subscription_creator', (e) ->
      e.preventDefault()
      form = this
      
      recurly.token form, (err, token) ->
        if err
          sweetAlert('Oops...', err.message, 'error');
        else
          form.submit()

  _initSameAsShipping: ->
    $(document).on 'change', '#same_as_shipping', (e) ->
      e.preventDefault()

      $('#address1').val($('#subscription_wizard_street_address').val())
      $('#address2').val($('#subscription_wizard_street_address_2').val())
      $('#city').val($('#subscription_wizard_city').val())
      $('#state').val($('#subscription_wizard_state_code').val())
      $('#postal_code').val($('#subscription_wizard_zip').val())

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