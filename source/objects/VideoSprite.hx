// script by tyler :3 (this took me hours.)
// patched for safe thread disposal

package objects;

import flixel.addons.display.FlxPieDial;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

#if hxCodec
import hxcodec.flixel.FlxVideoSprite;
#end

class VideoSprite extends FlxSpriteGroup {
	#if VIDEOS_ALLOWED
	public var finishCallback:Void->Void = null;
	public var onSkip:Void->Void = null;

	final _timeToSkip:Float = 1;
	public var holdingTime:Float = 0;
	
	#if hxCodec
	public var videoSprite:FlxVideoSprite;
	#end
	
	public var skipSprite:FlxPieDial;
	public var cover:FlxSprite;
	public var canSkip(default, set):Bool = false;

	private var videoName:String;

	public var waiting:Bool = false;
	public var didPlay:Bool = false;

	private var _videoEnded:Bool = false; 
	private var _isDestroying:Bool = false;
	private var destroyTimer:FlxTimer;
	private static var _gcSafetyHook:VideoSprite;

	public function new(videoName:String, isWaiting:Bool, canSkip:Bool = false, shouldLoop:Bool = false) {
		super();

		this.videoName = videoName;
		scrollFactor.set();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		waiting = isWaiting;
		if(!waiting)
		{
			cover = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
			cover.scale.set(FlxG.width + 100, FlxG.height + 100);
			cover.screenCenter();
			cover.scrollFactor.set();
			add(cover);
		}

		// initialize sprites
		#if hxCodec
		videoSprite = new FlxVideoSprite();
		videoSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(videoSprite);
		#end
		
		if(canSkip) this.canSkip = true;

		// callbacks
		#if hxCodec
		if(!shouldLoop)
		{
			if (videoSprite.bitmap != null) {
				videoSprite.bitmap.onEndReached.add(function() {
					_videoEnded = true; 
				});
			} else {
				FlxG.log.error("Video bitmap is null! Crash prevented.");
			}
		}
		#end

		// start video and adjust resolution to screen size
		#if hxCodec
		var filepath:String = Paths.video(videoName);
		
		if (videoSprite.bitmap != null) {
			videoSprite.bitmap.onTextureSetup.add(function() {
				if (videoSprite != null && videoSprite.bitmap != null) {
					videoSprite.setGraphicSize(FlxG.width, FlxG.height);
					videoSprite.updateHitbox();
					videoSprite.screenCenter();
				}
			});
		}

		videoSprite.play(filepath, shouldLoop);
		#end
		_gcSafetyHook = this; // Lock into memory
	}

	var alreadyDestroyed:Bool = false;
	override function destroy()
	{
		if(alreadyDestroyed) return;
		alreadyDestroyed = true;

		// Cancel the timer if the state switches abruptly
		if (destroyTimer != null) {
			destroyTimer.cancel();
			destroyTimer = null;
		}

		#if hxCodec
		if(videoSprite != null)
		{
			if (videoSprite.bitmap != null) {
				// Wipe listeners so they don't fire into the void
				videoSprite.bitmap.onEndReached.removeAll();
				videoSprite.bitmap.onTextureSetup.removeAll();
				
				// CRITICAL FIX: We absolutely CANNOT manually call bitmap.stop() here. 
				// hxcodec's destroy() method does this safely. Calling it manually 
				// when the video has naturally ended causes a hard crash.
			}
			remove(videoSprite);
			videoSprite.destroy();
			videoSprite = null;
		}
		#end

		if(cover != null)
		{
			remove(cover);
			cover.destroy();
			cover = null;
		}

		// Prevent callbacks from firing during state switches
		finishCallback = null;
		onSkip = null;

		if(PlayState.instance != null)
			PlayState.instance.remove(this);

		super.destroy();
		_gcSafetyHook = null; 
	}

	override function update(elapsed:Float)
	{
		if (_isDestroying) return; // Ignore updates while cooling down

		// 1. Safely process natural video end
		if (_videoEnded) {
			_videoEnded = false;
			_isDestroying = true;
			
			var cb = finishCallback;
			finishCallback = null; 
			
			// Hide the video instantly for a seamless visual transition
			visible = false;

			if (cb != null) cb();
			
			// Give libVLC 0.5 seconds to fully clean up its background threads
			// before we wipe the Haxe object from memory.
			destroyTimer = new FlxTimer().start(0.5, function(_) {
				destroy();
			});
			return; 
		}

		// 2. Process hold-to-skip logic
		if(canSkip)
		{
			if(Controls.instance.pressed('accept'))
			{
				holdingTime = Math.max(0, Math.min(_timeToSkip, holdingTime + elapsed));
			}
			else if (holdingTime > 0)
			{
				holdingTime = Math.max(0, FlxMath.lerp(holdingTime, -0.1, FlxMath.bound(elapsed * 3, 0, 1)));
			}
			updateSkipAlpha();

			if(holdingTime >= _timeToSkip)
			{
				_isDestroying = true;
				
				var skipCb = onSkip;
				onSkip = null; 
				finishCallback = null; 
				
				trace('Skipped video');
				
				visible = false;

				// Immediately pause audio so it doesn't overlap with the intro music
				#if hxCodec
				if (videoSprite != null) videoSprite.pause();
				#end

				if(skipCb != null) skipCb();
				
				destroyTimer = new FlxTimer().start(0.5, function(_) {
					destroy();
				});
				return; 
			}
		}
		super.update(elapsed);
	}

	function set_canSkip(newValue:Bool)
	{
		canSkip = newValue;
		if(canSkip)
		{
			if(skipSprite == null)
			{
				skipSprite = new FlxPieDial(0, 0, 40, FlxColor.WHITE, 40, true, 24);
				skipSprite.replaceColor(FlxColor.BLACK, FlxColor.TRANSPARENT);
				skipSprite.x = FlxG.width - (skipSprite.width + 80);
				skipSprite.y = FlxG.height - (skipSprite.height + 72);
				skipSprite.amount = 0;
				add(skipSprite);
			}
		}
		else if(skipSprite != null)
		{
			remove(skipSprite);
			skipSprite.destroy();
			skipSprite = null;
		}
		return canSkip;
	}

	function updateSkipAlpha()
	{
		if(skipSprite == null) return;
		skipSprite.amount = Math.min(1, Math.max(0, (holdingTime / _timeToSkip) * 1.025));
		skipSprite.alpha = FlxMath.remapToRange(skipSprite.amount, 0.025, 1, 0, 1);
	}

	#if hxCodec
	public function resume() if(videoSprite != null) videoSprite.resume();
	public function pause() if(videoSprite != null) videoSprite.pause();
	public function stop() {
		if(videoSprite != null && videoSprite.bitmap != null) {
			_videoEnded = true;
		}
	}
	#else
	public function resume() {}
	public function pause() {}
	public function stop() {}
	#end

	#end
}