class window.Hotmess.Models.Song extends Backbone.Model
  is_playable: ->
    not not @get('youtube_url')
