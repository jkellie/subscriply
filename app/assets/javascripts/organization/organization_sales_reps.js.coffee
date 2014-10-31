OrganizationSalesReps = 

  init: ->
    @_initDatePickers()
    @_initSearchFilters()
    
  search: (page = 1) ->
    data = @_formValues(page)
    $('#sales_reps').addClass 'searching'

    OrganizationSalesReps._updateDownloadCSVButton()

    $.ajax
      type: 'GET'
      dataType: 'script'
      url: '/organization/sales_reps'
      data: data
      success: (response) ->
      error: (error) ->
      complete: ->
        $('#sales_reps').removeClass 'searching'

  _initDatePickers: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initSearchFilters: ->
    $(document).on 'keyup', '#query', (e) ->
      SS.typewatch (->
        OrganizationSalesReps.search()
      ), 500

    $(document).on 'change', '#state, #contract, #w8_w9', (e) ->
      OrganizationSalesReps.search()

  _updateDownloadCSVButton: ->
    url = "#{window.location.origin}/#{window.location.pathname}.csv?#{$.param(OrganizationSalesReps._formValues())}"
    $('#download_csv').attr('href', url)

  _formValues: (page) ->
    data = {}

    data['query'] = $('#query').val().toLowerCase() if $('#query').val()
    data['status'] = $('#state').val() if $('#state').val()
    data['contract'] = $('#contract').val() if $('#contract').val()
    data['w8_w9'] = $('#w8_w9').val() if $('#w8_w9').val()
    data['page'] = page if page > 1
    data

window.OrganizationSalesReps = OrganizationSalesReps