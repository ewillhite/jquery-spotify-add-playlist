(function() {
  (function($) {
    var addTracksToPlaylist, client_id, createPlaylist, doit, g_access_token, g_name, g_tracks, g_username, getUsername, redirect_uri, spotifyLogin;
    g_name = 'My Special Playlist';
    client_id = 'ddc0558e4e404d179079f7cc33f0c6a9';
    redirect_uri = window.location.href + 'spotify-callback';
    console.log(redirect_uri);
    g_access_token = '';
    g_username = '';
    g_tracks = [];
    getUsername = function(callback) {
      var url;
      url = 'https://api.spotify.com/v1/me';
      return $.ajax(url, {
        dataType: 'json',
        headers: {
          'Authorization': 'Bearer ' + g_access_token
        },
        success: function(r) {
          return callback(r.id);
        },
        error: function(r) {
          return callback(null);
        }
      });
    };
    createPlaylist = function(username, name, callback) {
      var url;
      url = 'https://api.spotify.com/v1/users/' + username + '/playlists';
      return $.ajax(url, {
        type: 'GET',
        dataType: 'json',
        async: false,
        headers: {
          'Authorization': 'Bearer ' + g_access_token,
          'Content-Type': 'application/json'
        },
        success: function(r) {
          var i, spotify_id;
          i = 0;
          spotify_id = '';
          while (i < r.items.length) {
            if (r.items[i].name === g_name) {
              spotify_id = r.items[i].id;
            }
            i++;
          }
          if (spotify_id.length === 0) {
            $('#creating h1').text('Creating Playlist');
            return $.ajax(url, {
              method: 'POST',
              data: JSON.stringify({
                'name': name,
                'public': false
              }),
              dataType: 'json',
              headers: {
                'Authorization': 'Bearer ' + g_access_token,
                'Content-Type': 'application/json'
              },
              success: function(r) {
                return callback(r.id);
              },
              error: function(r) {
                return callback(null);
              }
            });
          } else {
            $('#creating h1').text('Found Playlist');
            return callback(spotify_id);
          }
        }
      });
    };
    addTracksToPlaylist = function(username, playlist, tracks, callback) {
      var url;
      url = 'https://api.spotify.com/v1/users/' + username + '/playlists/' + playlist + '/tracks';
      return $.ajax(url, {
        method: 'POST',
        data: JSON.stringify(tracks),
        dataType: 'text',
        headers: {
          'Authorization': 'Bearer ' + g_access_token,
          'Content-Type': 'application/json'
        },
        success: function(r) {
          return callback(r.id);
        },
        error: function(r) {
          return callback(null);
        }
      });
    };
    doit = function() {
      var all, args, hash;
      hash = location.hash.replace(/#/g, '');
      all = hash.split('&');
      args = {};
      all.forEach(function(keyvalue) {
        var idx, key, val;
        idx = keyvalue.indexOf('=');
        key = keyvalue.substring(0, idx);
        val = keyvalue.substring(idx + 1);
        return args[key] = val;
      });
      g_name = localStorage.getItem('spotifyplaylist-name');
      g_tracks = [];
      if (typeof args['access_token'] !== 'undefined') {
        g_access_token = args['access_token'];
      }
      return getUsername(function(username) {
        return createPlaylist(username, g_name, function(playlist) {
          return addTracksToPlaylist(username, playlist, g_tracks, function() {
            $('#playlistlink').attr('href', 'spotify:user:' + username + ':playlist:' + playlist);
            $('#creating').hide();
            return $('#done').show();
          });
        });
      });
    };
    spotifyLogin = function(callback, g_tracks) {
      var url, w;
      url = 'https://accounts.spotify.com/authorize?client_id=' + client_id + '&response_type=token' + '&scope=playlist-read-private%20playlist-modify%20playlist-modify-private' + '&redirect_uri=' + encodeURIComponent(redirect_uri);
      localStorage.removeItem('spotifyplaylist-tracks');
      localStorage.setItem('spotifyplaylist-tracks', JSON.stringify(g_tracks));
      localStorage.setItem('spotifyplaylist-name', g_name);
      return w = window.open(url, 'asdf', 'WIDTH=400,HEIGHT=500');
    };
    doit();
    return $('button').click(function(e) {
      g_tracks = $(this).data('track');
      spotifyLogin(g_tracks);
      return e.preventDefault();
    });
  })(jQuery);

}).call(this);
