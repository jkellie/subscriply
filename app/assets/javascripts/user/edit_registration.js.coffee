EditRegistration = 

  init: ->
    @_initAvatar()

  _initAvatar: ->
    $(document).on 'change', '#user_avatar', ->
      if @files and @files[0]
        reader = new FileReader()
        reader.onprogress = (e) ->
          width = Math.round((e.loaded / e.total) * 100)
          $('#user_avatar_progress_bar').css 'width', width + '%'

        reader.onload = (e) ->
          $('.user-avatar').attr 'src', e.target.result

        reader.readAsDataURL @files[0]

window.EditRegistration = EditRegistration