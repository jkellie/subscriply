Dashboard =

  # Public Methods
  init: ->
    @_initDatePickers()
    @_initSearchFilters()

  search: (page = 1) ->
    data = @_formValues(page)
    $('#dashboard').addClass 'searching'

    $.ajax
      type: 'GET'
      dataType: 'script'
      url: '/organization'
      data: data
      success: (response) ->
      error: (error) ->
      complete: ->
        $('#dashboard').removeClass 'searching'

  # Private Methods

  _initDatePickers: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initSearchFilters: ->
    $(document).on 'change', '#plan_id, #start_date, #end_date', (e) ->
      Dashboard.search()

  _formValues: (page) ->
    data = {}

    data['plan_id'] = $('#plan_id').val().toLowerCase() if $('#plan_id').val()
    data['start_date'] = $('#start_date').val().toLowerCase()
    data['end_date'] = $('#end_date').val().toLowerCase()
    data

window.Dashboard = Dashboard
