# jQuery Spotify Add to Playlist Plugin
Simple plugin to allow a user to add a track to a Spotify playlist. If the playlist doesn't exist, it gets created and if it already exists, the song just gets added to it.

See demo here: http://ewillhite.github.io/jquery-spotify-add-playlist/

## Usage

1. Install dependencies (jQuery)
2. Create a Spotify application here: https://developer.spotify.com/
3. Add a redirect uri to your Spotify app that is [yourwebsite.com]/spotify-callback
4. Invoke the plugin:

```
// Click function just used as an example
$('button').click(function(e) {
	// Set Track ID
	var track = $(this).data('track');
	$(this).spotify_add_to_playlist({
		// Playlist Name - can be whatever you like
		playlist_name:'Test 2',
		// Client ID from your Spotify application in step 2
		client_id:'ddc0558e4e404d179079f7cc33f0c6a9',
		// Track Spotify ID
		track: track
	});
	e.preventDefault();
});
```

Credits: This plugin based on development done for [Essential Worship](http://essentialworship.com/) at [Centresource](http://centresource.com).

Note: this plugin is heavily based on the good work of https://github.com/possan/playlistcreator-example
