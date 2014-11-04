Dashboard =

  # Public Methods
  init: ->
    @_initDatePickers()

  # Private Methods

  _initDatePickers: ->
    $('.datepicker').datepicker({dateFormat: 'M d, yy'})


window.Dashboard = Dashboard
