OrganizationUsers = 

  init: ->
    @_initDatePickers()
    @_initSearchFilters()
    

  search: (page = 1) ->
    data = @_formValues(page)
    $('#users').addClass 'searching'

    OrganizationUsers._updateDownloadCSVButton()

    $.ajax
      type: 'GET'
      dataType: 'script'
      url: '/organization/users'
      data: data
      success: (response) ->
      error: (error) ->
      complete: ->
        $('#users').removeClass 'searching'

  _initDatePickers: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initSearchFilters: ->
    $(document).on 'keyup', '#query', (e) ->
      SS.typewatch (->
        OrganizationUsers.search()
      ), 500

    $(document).on 'change', '#start_date, #end_date, #state', (e) ->
      OrganizationUsers.search()

  _updateDownloadCSVButton: ->
    url = "#{window.location.origin}/#{window.location.pathname}.csv?#{$.param(OrganizationUsers._formValues())}"
    $('#download_csv').attr('href', url)

  _formValues: (page) ->
    data = {}

    data['query'] = $('#query').val().toLowerCase() if $('#query').val()
    data['start_date'] = $('#start_date').val().toLowerCase()
    data['end_date'] = $('#end_date').val().toLowerCase()
    data['status'] = $('#state').val() if $('#state').val()
    data['page'] = page if page > 1
    data

window.OrganizationUsers = OrganizationUsers