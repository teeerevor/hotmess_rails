class VoteView extends Backbone.View
  class: 'vote'

  events:
    'click .vote-close' : 'close'

  render: ->
    $('body').append @template({songs: @get_top_ten()})
    @

  template: (model) ->
    tp = Handlebars.compile $('#vote-template').html()
    tp(model)

  get_top_ten: ->
    _.map shortList.first(10), (song) ->
      song.toJSON()
    

window.Hotmess.Views.VoteView = VoteView
