extends AudioStreamPlayer

var playback : AudioStreamPlaybackPolyphonic

func play_sound(_stream:AudioStream) -> void :
	if !playing :
		play()
		
	playback = get_stream_playback()
	
	if playback :
		playback.play_stream(_stream)
	
