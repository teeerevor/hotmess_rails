class window.Hotmess.Views.SongsListView extends Backbone.View
  tagName:    'ol'
  className:  'song_list'

  initialize: ->
    @collection.bind 'reset', @render, @

  render: ->
    $(@el).empty()
    container = document.createDocumentFragment()
    @updateTotal(@collection.length)
    for song in @collection.models
      songView = new Hotmess.Views.SongView({model: song})
      container.appendChild songView.render().el
    $(@el).append(container)
    @

  updateTotal: (song_count) ->
    h2 = $(@el).parent().find('h2')
    text = h2.text().split('-')[0]
    songs_text = ''

    if song_count > 0
      text = text + " - #{song_count} song#{ if song_count > 1 then 's' else ''}"

    h2.text(text)

class window.Hotmess.Views.ShortListView extends Hotmess.Views.SongsListView
  className:  'short_list'

  render: ->
    if @collection.length == 0
      @show_blank_state()
    else
      @hide_blank_state()

    super

  show_blank_state: ->
    $('.empty_list_blank_state').show()

  hide_blank_state: ->
    $('.empty_list_blank_state').hide()

  initialize: ->
    @collection.bind 'add', @render, @
    @collection.bind 'reset', @render, @
    @collection.bind 'remove', @render, @
