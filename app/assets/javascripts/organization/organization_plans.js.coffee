OrganizationPlans = 

  init: ->
    @_initIconPickers()
    @_initProductSelect()

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
    
window.OrganizationPlans = OrganizationPlans
