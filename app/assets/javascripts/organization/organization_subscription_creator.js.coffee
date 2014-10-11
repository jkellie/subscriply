OrganizationSubscriptionCreator = 

  init: (public_key) ->
    @_initCardValidation()
    @_initDatePicker()
    @_initPlan()
    @_initProduct()
    @_initRecurly(public_key)
    @_initSteps()
    @_updatePreview()

  _initCardValidation: ->
    $('#subscription_creator_phone_number').formance('format_phone_number')
    $('#subscription_creator_member_number').formance('format_number')
    $('#number').formance('format_credit_card_number')

  _initDatePicker: ->
    $('.datepicker').datepicker()

  _initPlan: ->
    $(document).on 'change', '#subscription_creator_plan_id', (e) ->
      OrganizationSubscriptionCreator._toggleLocationId()

  _initProduct: ->
    $(document).on 'change', '#subscription_creator_product_id', (e) ->
      product_id = $(this).val()
      $('#subscription_creator_plan_id option').remove()
      $('#subscription_creator_plan_id').attr('disabled', 'disabled')

      if product_id isnt ''
        $.ajax
          url: "/organization/plans?product_id=#{product_id}"
          dataType: 'JSON'
          success: (plans) ->
            $.each plans, (i, plan) ->
              $("#subscription_creator_plan_id").append $("<option/>",
                value: plan.id
                text: plan.name
                'data-local-pick-up': (plan.plan_type == 'local_pick_up')
              )

            $('#subscription_creator_plan_id').attr('disabled', plans.length is 0)
          error: (response) ->
          complete: ->
            OrganizationSubscriptionCreator._toggleLocationId()

  _initRecurly: (public_key) ->
    recurly.configure public_key

    $(document).on 'submit', '.new_subscription_creator', (e) ->
      debugger
      e.preventDefault()
      form = this
      
      recurly.token form, (err, token) ->
        if err
          console.log "test"
          alert('failed')
        else
          debugger
          form.submit()

  _initSteps: ->
    $steps = $(".form-wizard .step")
    $buttons = $steps.find("[data-step]")
    $tabs = $(".header .steps .step")
    active_step = 0

    $('#subscription_creator_sales_rep_id').select2()
    
    $buttons.click (e) ->
      has_back = $(e.target).hasClass('back') or $(e.target).parent().hasClass('back')
      has_next = $(e.target).hasClass('next') or $(e.target).parent().hasClass('next')

      if has_back or (has_next and OrganizationSubscriptionCreator._validateStep())
        e.preventDefault()
        OrganizationSubscriptionCreator._updatePreview()
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

  _toggleLocationId: ->
    if $('#subscription_creator_plan_id').find(':selected').data('local-pick-up') is true
      $('#subscription_creator_location_id').attr('disabled', false)
      $('.subscription_creator_location_id label').text('* Location')
      $('#subscription_creator_location_id').attr('required', 'required')
    else
      $('#subscription_creator_location_id').attr('disabled', true)
      $('#subscription_creator_location_id option').first().attr('selected', 'selected')
      $('.subscription_creator_location_id label').text('Location')
      $('#subscription_creator_location_id').attr('required', false)

  _updatePreview: ->
    $('.finish dd').text('')

    if $('#subscription_creator_sales_rep_id').val()
      $('.finish .sales-rep').text($('#subscription_creator_sales_rep_id option:selected').text())
    else
      $('.finish .sales-rep').text('none')

    $('.finish .member-number').text($('#subscription_creator_member_number').val())
    $('.finish .name').text("#{$('#subscription_creator_first_name').val()} #{$('#subscription_creator_last_name').val()}")
    $('.finish .phone').text($('#subscription_creator_phone_number').val()).formance('format_phone_number')
    $('.finish .email').text($('#subscription_creator_email').val())
    $('.finish .shipping-address').html(OrganizationSubscriptionCreator._shippingAddress())
    $('.finish .start-date').text($('#subscription_creator_start_date').val())
    $('.finish .product').text($('#subscription_creator_product_id option:selected').text())
    $('.finish .plan').text($('#subscription_creator_plan_id option:selected').text())

    if $('#subscription_creator_location_id').val()
      $('.finish .location').text($('#subscription_creator_location_id option:selected').text())
    else
      $('.finish .location').text('n/a')

    $('.finish .card-name').text("#{$('#first_name').val()} #{$('#last_name').val()}")
    last_four = $('#number').val().substr($('#number').val().length - 5)
    $('.finish .card-number').text("**** #{last_four}")
    $('.finish .expiration').text("#{$('#month option:selected').text()} #{$('#year option:selected').text()}")
    $('.finish .cvv').text($('#cvv').val())
    $('.finish .billing-address').html(OrganizationSubscriptionCreator._billingAddress())

  _shippingAddress: ->
    address = "#{$('#subscription_creator_street_address').val()}<br/>"
    address += "#{$('#subscription_creator_street_address_2').val()}<br/>" if $('#subscription_creator_street_address_2').val()
    address += "#{$('#subscription_creator_city').val()}, #{$('#subscription_creator_state_code').val()} #{$('#subscription_creator_zip').val()}"
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

window.OrganizationSubscriptionCreator = OrganizationSubscriptionCreator