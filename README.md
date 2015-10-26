# jQuery Spotify Add to Playlist Plugin
Simple plugin to allow a user to add a track to a Spotify playlist. If the playlist doesn't exist, it gets created and if it already exists, the song just gets added to it.

Demo: http://ewillhite.github.io/jquery-spotify-add-playlist/

## Usage

1. Install using bower or make sure you install dependency (jQuery >=1.4)
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
		playlist_name:'My Funky Playlist',
		// Client ID from your Spotify application in step 2
		client_id:'',
		// Track Spotify ID
		track: track
	});
	e.preventDefault();
});
```

## Credits

This plugin based on development done for [Essential Worship](http://essentialworship.com/) at [Centresource](http://centresource.com). It was also inspired heavily by the good work of https://github.com/possan/playlistcreator-example
