OrganizationSubscription = 

  init: (public_key) ->
    @_initDatePicker()
    @_initPlan()
    @_initProduct()

  _initDatePicker: ->
    $('.datepicker').datepicker()

  _initPlan: ->
    $(document).on 'change', '.subscription-plan-id', (e) ->
      OrganizationSubscription._toggleLocationId()

  _initProduct: ->
    $(document).on 'change', '.subscription-product-id', (e) ->
      product_id = $(this).val()
      $('.subscription-plan-id option').remove()
      $('.subscription-plan-id').attr('disabled', 'disabled')

      if product_id isnt ''
        $.ajax
          url: "/organization/plans?product_id=#{product_id}"
          dataType: 'JSON'
          success: (plans) ->
            $.each plans, (i, plan) ->
              $(".subscription-plan-id").append $("<option/>",
                value: plan.id
                text: plan.name
                'data-local-pick-up': (plan.plan_type == 'local_pick_up')
              )

            $('.subscription-plan-id').attr('disabled', plans.length is 0)
          error: (response) ->
          complete: ->
            OrganizationSubscription._toggleLocationId()

  _toggleLocationId: ->
    if $('.subscription-plan-id').find(':selected').data('local-pick-up') is true
      $('.subscription-location-id').attr('disabled', false)
      $('.subscription-location-id').siblings('label').text('* Location')
      $('.subscription-location-id').attr('required', 'required')
    else
      $('.subscription-location-id').attr('disabled', true)
      $('.subscription-location-id option').first().attr('selected', 'selected')
      $('.subscription-location-id').siblings('label').text('Location')
      $('.subscription-location-id').attr('required', false)

window.OrganizationSubscription = OrganizationSubscription