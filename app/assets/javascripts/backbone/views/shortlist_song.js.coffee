class window.Hotmess.Views.ShortListSongView extends Backbone.View
  className: 'shortlist-song'

  events:
    'click .move_to_pos'  : 'moveToTop'
    'click .remove'       : 'removeFromShortlist'
    'click .song_tab'     : 'openSongInList'

  initialize: ->
    @model.bind 'reset', @render, @

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

  moveToTop: ->
    $(@el).detach()
    shortList.remove @model
    shortList.add @model, {at: 0}
    track('click', 'move_to_top')

  removeFromShortlist: (event) ->
    self = @
    model = @model
    track('click', 'remove_from_short_list')
    $(@el).removeClass('added-song')
    $(@el).addClass('removed-song')
    delay 400, ->
      model.destroy()

  openSongInList: ->
    songListView.toggleSong(@model)

  template: (model)->
    Handlebars.registerHelper 'song_name_trim', (str)->
      if str and str.length > 37
        return str.substring(0,34) + '...'
      str

    tp = Handlebars.compile($('#shortlist-song-template').html())
    tp(model)
