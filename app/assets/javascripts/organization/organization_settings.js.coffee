OrganizationSettings = 

  init: ->
    @_initLogo()
    @_initAddLocation()
    @_initDeleteLocation()

  _initLogo: ->
    $(document).on "change", "#organization_logo", ->
      if @files and @files[0]
        reader = new FileReader()
        reader.onprogress = (e) ->
          width = Math.round((e.loaded / e.total) * 100)
          $("#organization_logo_progress_bar").css "width", width + "%"

        reader.onload = (e) ->
          $("#organization-logo").attr "src", e.target.result

        reader.readAsDataURL @files[0]

  _initAddLocation: ->
    $(document).on 'click', '#add_location_button', ->
      $.ajax
        url: '/organization/locations'
        method: 'POST'
        data:
          location:
            name: $('#location_name').val()
            street_address: $('#location_street_address').val()
            street_address_2: $('#location_street_address_2').val()
            city: $('#location_city').val()
            state: $('#location_state').val()
            zip: $('#location_zip').val()

        success: ->
        error: (response) ->
          $('#add_location .error_notification').text(JSON.parse(response.responseText).error).removeClass 'hidden'
        complete: ->

  _initDeleteLocation: ->
    $(document).on 'click', '.delete-location', (e) ->
      e.preventDefault()
      location_id = $(this).data('location-id')
    
      $.ajax
        url: "/organization/locations/#{location_id}"
        method: 'DELETE'
        success: ->
        error: (response) ->

window.OrganizationSettings = OrganizationSettings
