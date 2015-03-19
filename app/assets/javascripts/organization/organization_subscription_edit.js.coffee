OrganizationSubscriptionEdit =

  init: ->
    @_initPlanSelect()
    $('#subscription_plan_id').change()

  _initPlanSelect: ->
    $(document).on 'change', '#subscription_plan_id', (e) -> 
      local_pick_up = $(this).find(':selected').data('plan-type') == 'local_pick_up'
      location_select = $('#subscription_location_id')
      location_label = $('.location-label')
      if local_pick_up
        location_select.attr('disabled', false).
          attr('required', 'required').show()
          location_label.show()
      else
        location_select.attr('disabled', true).
          attr('required', 'false').hide()
        location_label.hide()

window.OrganizationSubscriptionEdit = OrganizationSubscriptionEdit