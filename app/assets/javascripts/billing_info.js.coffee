BillingInfo = 

  init: (public_key) ->
    @_initCardValidation()
    @_initRecurly(public_key)

  _initCardValidation: ->
    $('#number').formance('format_credit_card_number')

  _initRecurly: (public_key) ->
    recurly.configure public_key
    
    $(document).on 'submit', '.edit-billing-info', (e) ->
      e.preventDefault()
      form = this
      
      recurly.token form, (err, token) ->
        if err
          sweetAlert('Oops...', err.message, 'error');
        else
          form.submit()

window.BillingInfo = BillingInfo