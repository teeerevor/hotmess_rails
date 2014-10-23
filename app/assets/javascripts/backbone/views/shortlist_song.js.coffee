class window.Hotmess.Views.ShortListSongView extends Backbone.View
  className: 'shortlist-song'

  events:
    'click .move_to_pos'       : 'move_to_top'
    'click .remove'            : 'remove_from_short_list'
    'click .song_header'       : 'openSongInList'

  initialize: ->
    @model.bind 'reset', @render, @

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

  move_to_top: (event) ->
    event.stopImmediatePropagation()
    $(@el).detach()
    shortList.remove @model
    shortList.add_to_shortlist @model, {at: 0}
    track('click', 'move_to_top')

  remove_from_short_list: (event) ->
    event.stopImmediatePropagation()
    track('click', 'remove_from_short_list')
    model = @model
    $(@el).removeClass('added-song')
    $(@el).addClass('removed-song')
    delay 400, ->
      $(@el).detach()
      shortList.remove model

  openSongInList: ->
    songListView.toggleSong(@model)

  template: (model)->
    tp = Handlebars.compile($('#shortlist-song-template').html())
    tp(model)
