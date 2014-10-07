OrganizationSubscriptionCreator = 

  init: ->
    @_initSteps()

  _initSteps: ->
    $steps = $(".form-wizard .step")
    $buttons = $steps.find("[data-step]")
    $tabs = $(".header .steps .step")
    active_step = 0
    
    $buttons.click (e) ->
      e.preventDefault()
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


window.OrganizationSubscriptionCreator = OrganizationSubscriptionCreator