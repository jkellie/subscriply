SS = 
  # Delay between firing events when typing into location and search fields
  typewatch: (->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
  )()

window.SS = SS