package states;

#if VIDEOS_ALLOWED
import flixel.input.gamepad.FlxGamepad;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import objects.VideoSprite;
#end

class IntroState extends MusicBeatState
{
	#if VIDEOS_ALLOWED
	var videoPlaying:Bool = false;
	var video:VideoSprite;
	#end

	var canSkip:Bool = true;

	override public function create():Void
	{
		super.create();

		#if VIDEOS_ALLOWED
		startVideo('segasplash');
		#else
		transitionToTitle();
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if VIDEOS_ALLOWED
		if (canSkip && videoPlaying)
		{
			var pressedSkip:Bool = false;

			if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.SPACE)
				pressedSkip = true;

			#if mobile
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
					pressedSkip = true;
			}
			#end

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
			if (gamepad != null)
			{
				if (gamepad.justPressed.START || gamepad.justPressed.A || gamepad.justPressed.B)
					pressedSkip = true;
			}

			if (pressedSkip)
				skipVideo();
		}
		#end
	}

	#if VIDEOS_ALLOWED
	function startVideo(name:String)
	{
		var filepath:String = Paths.video(name);
		#if sys
		if(!sys.FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			trace('Video file not found at: ' + filepath);
			transitionToTitle();
			return;
		}

		videoPlaying = true;
		video = new VideoSprite(name, false, true, false);

		var onVideoDone = function() {
			if(videoPlaying) {
				videoPlaying = false;
				transitionToTitle();
			}
		};

		video.finishCallback = onVideoDone;
		video.onSkip = onVideoDone;

		add(video);
	}

	function skipVideo()
	{
		if (videoPlaying && video != null)
		{
			videoPlaying = false;
			canSkip = false;
			video.stop();
			transitionToTitle();
		}
	}
	#end

	function transitionToTitle()
	{
		// Set flashing to true to skip FlashingState when transitioning to TitleState
		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;
		
		// Also mark as leftState to further guarantee we skip FlashingState
		FlashingState.leftState = true;

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		MusicBeatState.switchState(new TitleState());
	}

	override public function destroy()
	{
		#if VIDEOS_ALLOWED
		if (video != null) {
			video.destroy();
			video = null;
		}
		#end
		super.destroy();
	}
}