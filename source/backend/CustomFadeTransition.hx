package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import backend.Paths; 
import backend.MusicBeatSubstate;

class CustomFadeTransition extends MusicBeatSubstate
{
	public static var finishCallback:Void->Void;
	
	var isTransIn:Bool = false;
	var transSprite:FlxSprite;

	public function new(duration:Float, isTransIn:Bool)
	{
		this.isTransIn = isTransIn;
		super();
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		transSprite = new FlxSprite();
		transSprite.frames = Paths.getSparrowAtlas('fade/s1fade'); 

		transSprite.animation.addByPrefix('close', 'fade in', 30, false);
		transSprite.animation.addByPrefix('open', 'fade out', 30, false);

		transSprite.screenCenter();
		transSprite.scrollFactor.set();

		if(isTransIn) {)
			transSprite.animation.play('close');

			transSprite.animation.finishCallback = function(name:String) {
				close();
			};
		} else {
			transSprite.animation.play('open');

			transSprite.animation.finishCallback = function(name:String) {
				close();
			};
		}

		add(transSprite);
		super.create();
	}

	override function close():Void
	{
		super.close();

		if(finishCallback != null)
		{
			finishCallback();
			finishCallback = null;
		}
	}

	override function destroy()
	{
		if(finishCallback != null)
			finishCallback = null;
		}
		super.destroy();
}