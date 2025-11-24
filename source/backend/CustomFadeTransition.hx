package backend; // Matches your file structure

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import backend.Paths; 
import backend.MusicBeatSubstate; // Using MusicBeatSubstate as per your previous file

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
		// Camera setup to ensure transition covers everything
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		// Load your custom sprite from assets/shared/images/fade/s1fade
		// Note: 'fade/s1fade' assumes the folder structure is assets/shared/images/fade/s1fade.png
		transSprite = new FlxSprite();
		transSprite.frames = Paths.getSparrowAtlas('fade/s1fade'); 
		
		// Animation definitions based on your XML
		// "fade out" = Screen getting COVERED (Transition In / Entering a state)
		// "fade in"  = Screen REVEALING (Transition Out / Leaving a state)
		transSprite.animation.addByPrefix('close', 'fade in', 30, false);
		transSprite.animation.addByPrefix('open', 'fade out', 30, false);
		
		// Ensure it covers the screen and stays fixed
		transSprite.screenCenter();
		transSprite.scrollFactor.set();

		// Logic to play correct animation
		if(isTransIn) {
			// We are entering a new state (Screen goes dark)
			transSprite.animation.play('close');
			
			// Callback when animation finishes
			transSprite.animation.finishCallback = function(name:String) {
				close(); // Close triggers the finishCallback logic below
			};
		} else {
			// We are revealing the new state (Screen goes clear)
			transSprite.animation.play('open');
			
			// Callback when animation finishes
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