OrganizationReport =

  # Public Methods
  init: ->
    @_initDatePickers()
    @_initSearchFilters()
    @_initCsvDownload()

  search: (page = 1) ->
    $('#dashboard').addClass 'searching'

    $.ajax
      type: 'GET'
      dataType: 'script'
      data: $('#filter_form').serialize()
      success: (response) ->
      error: (error) ->
      complete: ->
        $('#dashboard').removeClass 'searching'

  # Private Methods

  _initDatePickers: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})

  _initSearchFilters: ->
    $(document).on 'change', '#plan_id, #start_date, #end_date', (e) ->
      OrganizationReport.search()
  
  _initCsvDownload: ->
    $('#download_csv').on 'click', (e) ->
      e.preventDefault()
      window.location = "#{window.location.origin}/#{window.location.pathname}.csv?#{$('#filter_form').serialize()}"

window.OrganizationReport = OrganizationReport
