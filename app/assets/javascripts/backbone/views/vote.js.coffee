class VoteView extends Backbone.View
  className: 'vote'

  events:
    'click .vote-close' : 'close_vote'

  render: ->
    top_ten = @get_top_ten()
    $(@el).html @template({songs: top_ten})
    @zero_songs_in_shortlist() if top_ten.length == 0
    @

  template: (model) ->
    tp = Handlebars.compile $('#vote-template').html()
    tp(model)

  get_top_ten: ->
    _.map shortList.first(10), (song) ->
      song.toJSON()

  close_vote: ->
    console.log 'close fucker'
    $(@el).remove()
    window.voteView = ''

  zero_songs_in_shortlist: ->
    @$('.has-votes').hide()
    @$('.no-votes').show()

window.Hotmess.Views.VoteView = VoteView
