window.App = {
  sections: ['intro', 'compatibility', 'wild']

  progressBar: null

  init: ->
    self = @

    @progressBar = $("#progress_bar")
    @progressBar.removeClass("transition").addClass("error").addClass("transition")
    $(".ui-progress .ui-label", @progressBar).hide()
    $(".ui-progress", @progressBar).css "width", "7%"

    $(".ui-progress", @progressBar).animateProgress 35, ->
      self.load_backbone()
      $("#progress_bar").removeClass("error").addClass "warning"

      $("#progress_bar .ui-progress").animateProgress 60, ->
        console.log 'fetch'
        #songsList.fetch({dataType: 'json', success: self.showApp})
        self.showApp()
        console.log 'done fetch'

  #may use this later
  finishAndShowLaunchBtn: ->
    $("#progress_bar").removeClass "warning"
    $("#progress_bar .ui-progress").animateProgress 100, ->
      $('.launch_btn').removeClass('hidden')
      $('.ui-progress-bar').hide()


  showApp: ->
    console.log 'showApp'
    $("#progress_bar").removeClass "warning"
    $("#progress_bar .ui-progress").animateProgress 100, ->
      $('#app').removeClass('hidden')
      $('.list_index').removeClass('hidden')
      $('#loading').hide()
    #self.setupWaypoints()

  load_backbone: ->
    #year and email are set in the app layout
    window.songsList = new Hotmess.Collections.Songs(gon.songs,{year: urlYear})
    window.songListView = new Hotmess.Views.SongsListView({collection: songsList})
    $('#song_list').append(songListView.render().el)

    window.saveLoadView = new Hotmess.Views.SaveLoadView({})
    $('#header').append(saveLoadView.render().el)

    window.hottestPlayer = new Hotmess.Views.PlayerView({})
    $('#header').append(hottestPlayer.render().el)

    #load these last - will break url email to saveload push otherwise
    window.shortList = new Hotmess.Collections.ShortList([],{year: urlYear, email: urlEmail})
    window.shortListView = new Hotmess.Views.ShortListView({collection: shortList})
    $('#short_list').append(shortListView.render().el)

  fadeIn: (section) ->
    $("section.#{section}").fadeIn 'slow'

  fadeInNextSection: ->
    @fadeIn(@sections.shift()) if @sections.length > 0

  setupWaypoints: ->
    $.waypoints.settings.scrollThrottle = 30
    $("#short_list").waypoint (event, direction) ->
      $(this).toggleClass "sticky", direction is "down"
      event.stopPropagation()
}

$ ->
  App.init()
