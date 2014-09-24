OrganizationSettings = 

  init: ->
    @_initLogo()
    @_initAddLocation()
    @_initEditLocation()
    @_initDeleteLocation()

  _initLogo: ->
    $(document).on 'change', '#organization_logo', ->
      if @files and @files[0]
        reader = new FileReader()
        reader.onprogress = (e) ->
          width = Math.round((e.loaded / e.total) * 100)
          $('#organization_logo_progress_bar').css 'width', width + '%'

        reader.onload = (e) ->
          $('#organization-logo').attr 'src', e.target.result

        reader.readAsDataURL @files[0]

  _initAddLocation: ->
    $(document).on 'click', '#add_location_button', ->
      $.ajax
        url: '/organization/locations'
        method: 'POST'
        data:
          location:
            name: $('#add_location #location_name').val()
            street_address: $('#add_location #location_street_address').val()
            street_address_2: $('#add_location #location_street_address_2').val()
            city: $('#add_location #location_city').val()
            state: $('#add_location #location_state').val()
            zip: $('#add_location #location_zip').val()

        success: ->
        error: (response) ->
          $('#add_location .error_notification').text(JSON.parse(response.responseText).error).removeClass 'hidden'
        complete: ->

  _initEditLocation: ->
    $(document).on 'click', '.edit-location', (e) ->
      $('#edit_location .error_notification').hide()
      e.preventDefault()
      location_id = $(this).data('location-id')
      
      $.ajax
        url: "/organization/locations/#{location_id}"
        dataType: 'JSON'
        success: (response) ->
          $('#edit_location').modal('show')
          $('#edit_location #edit_location_button').data('location-id', location_id)
          $('#edit_location #location_name').val(response.name)
          $('#edit_location #location_street_address').val(response.street_address)
          $('#edit_location #location_street_address_2').val(response.street_address_2)
          $('#edit_location #location_city').val(response.city)
          $('#edit_location #location_state').val(response.state)
          $('#edit_location #location_zip').val(response.zip)
        error: (response) ->
        complete: ->

    $(document).on 'click', '#edit_location_button', (e) ->
      e.preventDefault()
      location_id = $(this).data('location-id')

      $.ajax
        url: "/organization/locations/#{location_id}"
        method: 'PUT'
        data:
          location:
            name: $('#edit_location #location_name').val()
            street_address: $('#edit_location #location_street_address').val()
            street_address_2: $('#edit_location #location_street_address_2').val()
            city: $('#edit_location #location_city').val()
            state: $('#edit_location #location_state').val()
            zip: $('#edit_location #location_zip').val()
        success: (response) ->
        error: (response) ->
          $('#edit_location .error_notification').text(JSON.parse(response.responseText).error).removeClass 'hidden'
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
