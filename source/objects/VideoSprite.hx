// script by tyler :3 (this took me hours.)

package objects;

import flixel.addons.display.FlxPieDial;

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
			// FIX: Access signal via .bitmap
			videoSprite.bitmap.onEndReached.add(function() {
				if(alreadyDestroyed) return;
	
				trace('Video destroyed');
				if(cover != null)
				{
					remove(cover);
					cover.destroy();
				}
		
				PlayState.instance.remove(this);
				destroy();
				alreadyDestroyed = true;
			});
		}

		// hxCodec doesn't need onFormatSetup usually, we just play the video
		// we set the size immediately after play, or let it handle itself.
		// for safety, we just ensure it's centered.
		#end

		// start video and adjust resolution to screen size
		#if hxCodec
		var filepath:String = Paths.video(videoName);
		videoSprite.play(filepath, shouldLoop);
		
		// force strict sizing to screen
		videoSprite.setGraphicSize(FlxG.width, FlxG.height);
		videoSprite.updateHitbox();
		videoSprite.screenCenter();
		#end
	}

	var alreadyDestroyed:Bool = false;
	override function destroy()
	{
		if(alreadyDestroyed)
		{
			super.destroy();
			return;
		}

		trace('Video destroyed');
		if(cover != null)
		{
			remove(cover);
			cover.destroy();
		}

		if(finishCallback != null)
			finishCallback();
		onSkip = null;

		PlayState.instance.remove(this);
		super.destroy();
	}

	override function update(elapsed:Float)
	{
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
				if(onSkip != null) onSkip();
				finishCallback = null;
				
				#if hxCodec
				// this is taking so fucking long.. access signal via .bitmap to dispatch
				if(videoSprite != null && videoSprite.bitmap.onEndReached != null)
					videoSprite.bitmap.onEndReached.dispatch();
				#end
				
				PlayState.instance.remove(this);
				trace('Skipped video');
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
	#else
	public function resume() {}
	public function pause() {}
	#end

	#end
}