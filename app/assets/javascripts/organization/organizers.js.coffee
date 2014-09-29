Organizers = 

  init: ->
    @_initRemoveOrganizer()
    @_initInviteOrganizerModal()
    @_initSuperAdminToggle()

  _initRemoveOrganizer: ->
    $(document).on 'click', '.remove-organizer', (e) ->
      e.preventDefault()
      $row = $(@).parent().parent()
  
      if confirm('Are you sure you want to delete this administrator')
        organizer_id = $(this).data('organizer-id')
        
        $.ajax
          url: '/organization/organizers/' + organizer_id
          method: 'DELETE'

          success: (response) ->
            $row.remove()
          error: (response) ->
            console.log('Error deleting organizer')

  _initInviteOrganizerModal: ->
    $('#invite_organizer_modal').modal({show: false});

  _initSuperAdminToggle: ->
    $(document).on 'click', '.super-admin-toggle', (e) ->
      organizer_id = $(this).data('organizer-id')

      $.ajax
        url: '/organization/organizers/' + organizer_id + '/super_admin_toggle'
        method: 'PUT'
        success: (response) ->
          console.log('success')
        error: (response) ->
          console.log('error')


window.Organizers = Organizers