OrganizationSubscriptionWizard = 

  init: (public_key) ->
    @_initCardValidation()
    @_initRecurly(public_key)
    @_initSameAsShipping()
    @_initSteps()
    @_updatePreview()

  _initCardValidation: ->
    $('#organization_subscription_wizard_phone_number').formance('format_phone_number')
    $('#organization_subscription_wizard_member_number').formance('format_number')
    $('#number').formance('format_credit_card_number')

  _initRecurly: (public_key) ->
    recurly.configure public_key

    $(document).on 'submit', '.new_organization_subscription_wizard', (e) ->
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

      $('#address1').val($('#organization_subscription_wizard_street_address').val())
      $('#address2').val($('#organization_subscription_wizard_street_address_2').val())
      $('#city').val($('#organization_subscription_wizard_city').val())
      $('#state').val($('#organization_subscription_wizard_state_code').val())
      $('#postal_code').val($('#organization_subscription_wizard_zip').val())

  _initSteps: ->
    $steps = $(".form-wizard .step")
    $buttons = $steps.find("[data-step]")
    $tabs = $(".header .steps .step")
    active_step = 0

    $('#organization_subscription_wizard_sales_rep_id').select2()
    
    $buttons.click (e) ->
      has_back = $(e.target).hasClass('back') or $(e.target).parent().hasClass('back')
      has_next = $(e.target).hasClass('next') or $(e.target).parent().hasClass('next')

      if has_back or (has_next and OrganizationSubscriptionWizard._validateStep())
        e.preventDefault()
        OrganizationSubscriptionWizard._updatePreview()
        step_index = $(this).data("step") - 1
        in_fade_class = (if (step_index > active_step) then "fadeInRightStep" else "fadeInLeftStep")
        out_fade_class = (if (in_fade_class is "fadeInRightStep") then "fadeOutLeftStep" else "fadeOutRightStep")
        $out_step = $steps.eq(active_step)
        $out_step.on(utils.animation_ends(), ->
          $out_step.removeClass "fadeInRightStep fadeInLeftStep fadeOutRightStep fadeOutLeftStep"
        ).addClass out_fade_class
        active_step = step_index
        $tabs.removeClass("active").filter(":lt(" + (active_step + 1) + ")").addClass "active"
        $steps.removeClass "active"
        $steps.eq(step_index).addClass "active animated " + in_fade_class

  _updatePreview: ->
    $('.finish dd').text('')

    if $('#organization_subscription_wizard_sales_rep_id').val()
      $('.finish .sales-rep').text($('#organization_subscription_wizard_sales_rep_id option:selected').text())
    else
      $('.finish .sales-rep').text('none')

    $('.finish .member-number').text($('#organization_subscription_wizard_member_number').val())
    $('.finish .name').text("#{$('#organization_subscription_wizard_first_name').val()} #{$('#organization_subscription_wizard_last_name').val()}")
    $('.finish .phone').text($('#organization_subscription_wizard_phone_number').val()).formance('format_phone_number')
    $('.finish .email').text($('#organization_subscription_wizard_email').val())
    
    if OrganizationSubscriptionWizard._showShippingAddress()
      $('.finish .shipping-address').html(OrganizationSubscriptionWizard._shippingAddress())

    $('.finish .start-date').text($('#organization_subscription_wizard_start_date').val())
    $('.finish .product').text($('#organization_subscription_wizard_product_id option:selected').text())
    $('.finish .plan').text($('#organization_subscription_wizard_plan_id option:selected').text())

    if $('#organization_subscription_wizard_location_id').val()
      $('.finish .location').text($('#organization_subscription_wizard_location_id option:selected').text())
    else
      $('.finish .location').text('n/a')

    $('.finish .card-name').text("#{$('#first_name').val()} #{$('#last_name').val()}")
    last_four = $('#number').val().substr($('#number').val().length - 5)
    $('.finish .card-number').text("**** #{last_four}")
    $('.finish .expiration').text("#{$('#month option:selected').text()} #{$('#year option:selected').text()}")
    $('.finish .cvv').text($('#cvv').val())

    if OrganizationSubscriptionWizard._showBillingAddress()
      $('.finish .billing-address').html(OrganizationSubscriptionWizard._billingAddress())

  _showShippingAddress: ->
    $('dd.shipping-address') 

  _showBillingAddress: ->
    $('dd.billing-address')

  _shippingAddress: ->
    address = "#{$('#organization_subscription_wizard_street_address').val()}<br/>"
    address += "#{$('#organization_subscription_wizard_street_address_2').val()}<br/>" if $('#organization_subscription_wizard_street_address_2').val()
    address += "#{$('#organization_subscription_wizard_city').val()}, #{$('#organization_subscription_wizard_state_code').val()} #{$('#organization_subscription_wizard_zip').val()}"
    address

  _billingAddress: ->
    address = "#{$('#address1').val()}<br/>"
    address += "#{$('#address2').val()}<br/>" if $('#address2').val()
    address += "#{$('#city').val()}, #{$('#state').val()} #{$('#postal_code').val()}"
    address

  _validateStep: ->
    valid = true
    $required_inputs = $('.step.active input[required], .step.active select[required]')
    
    $.each $required_inputs, (i, input) ->
      if $(input).val() is ''
        $(input).parent().addClass('field_with_errors')
        valid = false 
      else
        $(input).parent().removeClass('field_with_errors')

    valid

window.OrganizationSubscriptionWizard = OrganizationSubscriptionWizard