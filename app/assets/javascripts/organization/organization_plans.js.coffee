OrganizationPlans = 

  init: ->
    @_initBulletpoints()
    @_initIconPickers()
    @_initProductSelect()

  _initBulletpoints: ->
    $(document).on 'cocoon:after-insert', ->
      OrganizationPlans._check_to_hide_or_show_add_link()

    $(document).on 'cocoon:after-remove', ->
      OrganizationPlans._check_to_hide_or_show_add_link()

    OrganizationPlans._check_to_hide_or_show_add_link()

  _initIconPickers: ->
    $('.iconpicker').iconpicker {}

    $(document).on 'cocoon:after-insert', (e, insertedItem) ->
      $('.iconpicker').iconpicker {}

    $(document).on 'change', '.iconpicker', (e) ->
      $(this).parents('.iconpicker-wrap').find('.bulletpoint-icon').val(e.icon)

  _initProductSelect: ->
    $(document).on 'change', '#plan_product_id', (e) ->
      e.preventDefault()
      product_id = $(this).val()
      
      if product_id isnt ''
        $.ajax
          url: "/organization/products/#{product_id}"
          dataType: 'json'
          success: (response) ->
            $('#plan_prepend_code').text("#{response.prepend_code}_")
      else
        $('#plan_prepend_code').text('')

  _check_to_hide_or_show_add_link: ->
    if $('#bulletpoints .nested-fields').length is 6
      $('#bulletpoints .links a').hide()
    else
      $('#bulletpoints .links a').show()
    
window.OrganizationPlans = OrganizationPlans
