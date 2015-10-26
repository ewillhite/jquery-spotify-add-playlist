# namespace jQuery
(($) ->

	g_username = ''
	g_access_token = ''

	getUsername = (callback) ->
    # console.log 'getUsername'
    url = 'https://api.spotify.com/v1/me'
    $.ajax url,
      dataType: 'json'
      headers: 'Authorization': 'Bearer ' + g_access_token
      success: (r) ->
        # console.log 'got username response', r
        callback r.id
      error: (r) ->
        callback null

  createPlaylist = (username, name, callback) ->
    # console.log 'createPlaylist', username, name
    url = 'https://api.spotify.com/v1/users/' + username + '/playlists'
    $.ajax url,
      type: 'GET'
      dataType: 'json'
      async: false
      headers:
        'Authorization': 'Bearer ' + g_access_token
        'Content-Type': 'application/json'
      success: (r) ->
        # loop to see existence of playlist
        i = 0
        spotify_id = ''
        while i < r.items.length
          # If playlist exists
          if r.items[i].name == name
            # set spotify_id to be the id of the existing playlist
            spotify_id = r.items[i].id
          i++
        # if spotify_id is empty (playlist doesn't exist)
        if spotify_id.length == 0
          $('#creating h1').text('Creating Playlist')
          # create the playlist
          $.ajax url,
            method: 'POST'
            data: JSON.stringify(
              'name': name
              'public': false)
            dataType: 'json'
            headers:
              'Authorization': 'Bearer ' + g_access_token
              'Content-Type': 'application/json'
            success: (r) ->
              # console.log 'create playlist response', r
              callback r.id
            error: (r) ->
              callback null
        # Playlist exists, so set playlist ID to that one
        else
          $('#creating h1').text('Found Playlist')
          callback spotify_id



  addTracksToPlaylist = (username, playlist, tracks, callback) ->
    # console.log 'addTracksToPlaylist', username, playlist, tracks
    url = 'https://api.spotify.com/v1/users/' + username + '/playlists/' + playlist + '/tracks' + '?uris=spotify%3Atrack%'+tracks;
    $.ajax url,
      method: 'POST'
      dataType: 'text'
      headers:
        'Authorization': 'Bearer ' + g_access_token
        'Content-Type': 'application/json'
      success: (r) ->
        # console.log 'add track response', r
        callback r.id
      error: (r) ->
        callback null

	doit = ->
		# parse hash
		hash = location.hash.replace(/#/g, '')
		all = hash.split('&')
		args = {}
		# console.log 'all', all
		all.forEach (keyvalue) ->
      idx = keyvalue.indexOf('=')
      key = keyvalue.substring(0, idx)
      val = keyvalue.substring(idx + 1)
      args[key] = val
    g_name = localStorage.getItem('spotifyplaylist-name')
    g_tracks = JSON.parse(localStorage.getItem('spotifyplaylist-tracks'))
    # console.log 'got args', args
    if typeof args['access_token'] != 'undefined'
      # got access token
      # console.log 'got access token', args['access_token']
      g_access_token = args['access_token']
    getUsername (username) ->
      # console.log 'got username', username
      createPlaylist username, g_name, (playlist) ->
        # console.log 'created playlist', playlist
        addTracksToPlaylist username, playlist, g_tracks, ->
          # console.log 'tracks added.'
          $('#playlistlink').attr 'href', 'spotify:user:' + username + ':playlist:' + playlist
          $('#creating').hide()
          $('#done').show()

	if $('.spotify-callback').length
  	doit()

	spotifyLogin = (g_tracks, client_id, redirect_uri, g_name) ->
    url = 'https://accounts.spotify.com/authorize?client_id=' + client_id + '&response_type=token' + '&scope=playlist-read-private%20playlist-modify%20playlist-modify-private' + '&redirect_uri=' + encodeURIComponent(redirect_uri)
    # remove old tracks if stored
    localStorage.removeItem('spotifyplaylist-tracks')
    # add track
    localStorage.setItem('spotifyplaylist-tracks', JSON.stringify(g_tracks))
    # add playlist
    localStorage.setItem 'spotifyplaylist-name', g_name
    w = window.open(url, 'asdf', 'WIDTH=400,HEIGHT=500')

	$.fn.spotify_add_to_playlist = (options) ->
		settings = $.extend({
		  playlist_name: '',
		  client_id: '',
		  track:''
	  }, options)
	  @each ->
	  	g_name = settings.playlist_name
	  	client_id = settings.client_id
	  	g_tracks = settings.track
	  	if location.hostname == "localhost"
	  		redirect_uri = window.location.href + 'spotify-callback.html'
	  	else
	  		redirect_uri = window.location.href + 'spotify-callback'
	  	spotifyLogin(g_tracks, client_id, redirect_uri, g_name)
	  	return

  	this

) jQuery
