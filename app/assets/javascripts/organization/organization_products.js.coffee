OrganizationProducts = 

  init: ->
    @_initPhoto()

  _initPhoto: ->
    $(document).on 'change', '#product_image', ->
      if @files and @files[0]
        reader = new FileReader()
        reader.onprogress = (e) ->
          width = Math.round((e.loaded / e.total) * 100)
          $('#product_image_progress_bar').css 'width', width + '%'

        reader.onload = (e) ->
          $('#product-image').attr 'src', e.target.result

        reader.readAsDataURL @files[0]
    
window.OrganizationProducts = OrganizationProducts