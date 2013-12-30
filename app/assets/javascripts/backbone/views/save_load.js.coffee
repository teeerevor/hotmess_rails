delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

class SaveLoadView extends Backbone.View
  id: 'save_load'

  events:
    'click .email_display'  : 'open'
    'click .load' : 'load'
    'click .save' : 'save'
    'click .send' : 'send'
    'hover .close_form_button' : 'hover_close_button'
    'click .close_form_button' : 'close'

  render: ->
    $(@el).html @template({})
    @

  template: (model) ->
    tp = Handlebars.compile $('#saveload-template').html()
    tp(model)

  open: ->
    self = @
    $('header').addClass('open')
    $('#email').focus()
    $('#email').on 'keyup', ->
      delay (->
        self.form().removeClass('valid invalid blank')
        self.showInlineValidation()
      ), 1000
    track('click', 'open_save_load')

  close: ->
    $('#email').off('keyup')
    $('header').removeClass('open')
    @email_input().attr('value', '') unless @validateEmail @email()
    @form().removeClass('invalid blank')
    track('click', 'close_save_load')


  hover_close_button: ->
    $('.close_form_button').toggleClass('highlight')

  form: ->
    @.$('form')

  email_input: ->
    @.$('#email')

  email: ->
    @email_input().val()


  load: (e) ->
    e.preventDefault()
    self = @
    @doIfEmailIsValid( ->
      track('click', 'load_playlist')
      self.setEmailDisplay()
      window.shortList.loadList self.email()
      self.close()
    , self)

  save: (e) ->
    e.preventDefault()
    self = @
    @doIfEmailIsValid( ->
      track('click', 'save_playlist')
      self.setEmailDisplay()
      window.shortList.saveList self.email()
      self.close()
    , self)

  send: (e)->
    e.preventDefault()
    self = @
    @doIfEmailIsValid( ->
      track('click', 'send_playlist')
      self.setEmailDisplay()
      window.shortList.saveAndSend self.email()
      self.close()
    , self)

  setEmailDisplay: ->
    @.$('.current_email').text(@email()).show()
    window.user = @email()
    @.$('.list_label').hide()

  setEmailFromUrlLoad: (email) ->
    @email_input().attr('value', email)
    @setEmailDisplay()

  validateEmail: (email) ->
    emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return emailRegex.test(email)

  showInlineValidation: ->
    if @email().length > 0
      if @validateEmail @email()
        @form().addClass('valid')
      else
        @form().addClass('invalid')
    else
      @form().addClass('blank')

  doIfEmailIsValid: (callback, self) ->
    if self.validateEmail self.email()
      callback()
    else
      self.showInvalidEmailMsg()

  showInvalidEmailMsg: ->
    @showErrorMessage('That dosen\'t look right, please check the email address you entered.')

  showErrorMessage: (msg) ->
    alert(msg)

  resetToBlank: ->
    @.$('.current_email').hide()
    @.$('.list_label').show()


  updateUrl: ->
    window.history.pushState("object or string", "Load hottest100.io short list", "/#{@email()}")

window.Hotmess.Views.SaveLoadView = SaveLoadView
