# namespace jQuery
(($) ->
  # Document.ready
  $ ->

    g_access_token = ''
    # playlist name
    g_name = 'Essential Worship'
    g_username = ''
    # Set g_tracks to be ID from Spotify player iframe
    g_tracks = [$('.field-type-spotifyfield iframe').attr('src').split("?uri=").pop()]
    client_id = '0f2b3341b0ca41ada07b9002c69adea0'
    redirect_uri = location.origin + '/spotify-callback'

    spotifyLogin = (callback) ->
      url = 'https://accounts.spotify.com/authorize?client_id=' + client_id + '&response_type=token' + '&scope=playlist-read-private%20playlist-modify%20playlist-modify-private' + '&redirect_uri=' + encodeURIComponent(redirect_uri)
      # remove old tracks if stored
      localStorage.removeItem('spotifyplaylist-tracks')
      # add track
      localStorage.setItem('spotifyplaylist-tracks', JSON.stringify(g_tracks))
      # add playlist
      localStorage.setItem 'spotifyplaylist-name', g_name
      w = window.open(url, 'asdf', 'WIDTH=400,HEIGHT=500')

    # Spotify Button
    $('<a id="spotify-add" href="" title="Add Song to an Essential Worship Spotify Playlist"><span>+</span>Add to Spotify</a>').appendTo('.group-song').click (e) ->
      spotifyLogin ->
      e.preventDefault()

    # Video Modal
    if $('header button.icon').css('margin-top') == '30px'
      $('.video > a').click ->
        window.location.hash = $(this).next().text().replace(/\s/g, '+');
        src = $(this).attr('href')
        src_vid = src.substring src.indexOf('=') + 1
        vid = 'https://www.youtube.com/embed/' + src_vid + '?autoplay=1'
        $('#songModal').modal 'show'
        $('#songModal iframe').attr('src', vid)
        $('.modal-body').fitVids()
        return false

    $('#songModal button').on 'click', ->
      window.location.hash = 'main-content'
      $('#songModal iframe').removeAttr 'src'

    if window.location.hash
      hash = window.location.hash.substr(1).replace('+', ' ');
      $('.vid-description:contains("' + hash + '")').prev().click()

    # Remove MP3 if Spotify Link is present - SHOULD BE MOVED TO PHP
    if $('.field-type-spotifyfield').length
      $('.field-type-spotifyfield + div').remove()

    # anonymous header link clicks
  	$('.not-logged-in .hero .btns a').click (e) ->
  		if !$('.modal-message').length
  			$('<p class="modal-message">You must be logged in to complete this action.</p>').prependTo('#myModal .modal-body')
  		$('#myModal').modal 'show'
  		e.preventDefault()

  	$('#myModal button').on 'click', ->
      $('.modal-message').remove()

) jQuery
