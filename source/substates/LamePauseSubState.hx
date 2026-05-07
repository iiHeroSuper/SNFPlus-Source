package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import backend.MusicBeatSubstate;
import backend.Paths;

class LamePauseSubState extends MusicBeatSubstate
{
	var pauseMenuOverlay1:FlxSprite;
	var pauseMenuOverlay2:FlxSprite;
	var pauseMenuResume:FlxSprite;
	var pauseMenuRetry:FlxSprite;
	var pauseMenuExit:FlxSprite;
	var pauseMenuMute:FlxSprite;
	var pauseMenuHelp:FlxSprite;
	var pauseMenuPrompt:FlxSprite;
	var pauseMenuCheckmark:FlxSprite;
	var levels:FlxText;
	var subCam:flixel.FlxCamera;

	var pauseMenuActive:Bool = true;
	var helpEnter:Bool = false;
	var pauseSelection:Int = 1;
	
	var lastMouseX:Float = -1;
	var lastMouseY:Float = -1;
	
	public static var isMuted:Bool = false;
	
	var levelNumberMap:Map<String, String> = new Map<String, String>();

	var buttons:Array<FlxSprite>;
	var buttonCenters:Array<{x:Float, y:Float}> = [];

	public function new()
	{
		super();

		var rawData:String = Paths.getTextFromFile(Paths.json('levelNumbers'));
		if (rawData != null)
		{
			var levelNumbers:Dynamic = haxe.Json.parse(rawData);
			for (key in Reflect.fields(levelNumbers))
			{
				levelNumberMap.set(key, Reflect.field(levelNumbers, key));
			}
		}

		// Background overlays
		pauseMenuOverlay1 = new FlxSprite();
		pauseMenuOverlay1.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuOverlay1.animation.addByPrefix('overlay_2', 'overlay_2', 0, false);
		pauseMenuOverlay1.animation.play('overlay_2');
		pauseMenuOverlay1.scrollFactor.set();
		add(pauseMenuOverlay1);

		pauseMenuOverlay2 = new FlxSprite();
		pauseMenuOverlay2.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuOverlay2.animation.addByPrefix('overlay_1', 'overlay_1', 0, false);
		pauseMenuOverlay2.animation.play('overlay_1');
		pauseMenuOverlay2.scrollFactor.set();
		add(pauseMenuOverlay2);

		// Buttons
		pauseMenuResume = new FlxSprite(10, 10);
		pauseMenuResume.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuResume.animation.addByPrefix('button_resume', 'button_resume', 0, false);
		pauseMenuResume.animation.play('button_resume');
		add(pauseMenuResume);

		pauseMenuRetry = new FlxSprite(125, 215);
		pauseMenuRetry.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuRetry.animation.addByPrefix('button_retry', 'button_retry', 0, false);
		pauseMenuRetry.animation.play('button_retry');
		add(pauseMenuRetry);

		// Exit button
		pauseMenuExit = new FlxSprite(125, 385);
		pauseMenuExit.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuExit.animation.addByPrefix('button_exit', 'button_exit', 0, false);
		pauseMenuExit.animation.play('button_exit');
		add(pauseMenuExit);

		pauseMenuMute = new FlxSprite(90, 600);
		pauseMenuMute.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuMute.animation.addByPrefix('button_mute', 'button_mute', 0, false);
		pauseMenuMute.animation.addByPrefix('button_muted', 'button_muted', 0, false);
		pauseMenuMute.animation.play(isMuted ? 'button_muted' : 'button_mute');
		add(pauseMenuMute);

		pauseMenuHelp = new FlxSprite(190, 600);
		pauseMenuHelp.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuHelp.animation.addByPrefix('button_help', 'button_help', 0, false);
		pauseMenuHelp.animation.play('button_help');
		add(pauseMenuHelp);

		buttons = [pauseMenuResume, pauseMenuRetry, pauseMenuExit, pauseMenuMute, pauseMenuHelp];
		for (btn in buttons) {
			btn.scrollFactor.set();
			btn.antialiasing = ClientPrefs.data.antialiasing;
			btn.updateHitbox();
			
			// Calculate and store centers based on initial top-left positions
			buttonCenters.push({
				x: btn.x + btn.frameWidth / 2,
				y: btn.y + btn.frameHeight / 2
			});
		}

		// Help Prompt
		pauseMenuPrompt = new FlxSprite();
		pauseMenuPrompt.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuPrompt.animation.addByPrefix('prompt_help', 'prompt_help', 0, false);
		pauseMenuPrompt.animation.play('prompt_help');
		pauseMenuPrompt.scale.set(0.75, 0.75);
		pauseMenuPrompt.updateHitbox();
		pauseMenuPrompt.screenCenter();
		pauseMenuPrompt.scrollFactor.set();
		pauseMenuPrompt.alpha = 0;
		add(pauseMenuPrompt);

		pauseMenuCheckmark = new FlxSprite(775, 500);
		pauseMenuCheckmark.frames = Paths.getSparrowAtlas('3lamepausemenu');
		pauseMenuCheckmark.animation.addByPrefix('button_yuh_huh', 'button_yuh_huh', 0, false);
		pauseMenuCheckmark.animation.play('button_yuh_huh');
		pauseMenuCheckmark.scale.set(0.75, 0.75);
		pauseMenuCheckmark.updateHitbox();
		pauseMenuCheckmark.scrollFactor.set();
		pauseMenuCheckmark.alpha = 0;
		add(pauseMenuCheckmark);

		// Level text
		var songKey:String = Paths.formatToSongPath(PlayState.SONG.song);
		var levelNum:String = levelNumberMap.exists(songKey) ? levelNumberMap.get(songKey) : "W?-??";
		
		levels = new FlxText(-260, 25, 1000, levelNum, 50);
		levels.setFormat(Paths.font('angrybirds-regular.ttf'), 50, FlxColor.WHITE, CENTER);
		levels.antialiasing = false;
		levels.scrollFactor.set();
		add(levels);

		// Set cameras
		subCam = FlxG.cameras.list[FlxG.cameras.list.length - 1];
		pauseMenuOverlay1.cameras = [subCam];
		pauseMenuOverlay2.cameras = [subCam];
		pauseMenuResume.cameras = [subCam];
		pauseMenuRetry.cameras = [subCam];
		pauseMenuExit.cameras = [subCam];
		pauseMenuMute.cameras = [subCam];
		pauseMenuHelp.cameras = [subCam];
		pauseMenuPrompt.cameras = [subCam];
		pauseMenuCheckmark.cameras = [subCam];
		levels.cameras = [subCam];

		FlxG.mouse.load(Paths.image('ab_cursor').bitmap, 1, 25, 5);
		FlxG.mouse.visible = true;

		updateSelection();
		
		if (isMuted) muteAudio(true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (pauseMenuActive)
		{
			var buttons:Array<FlxSprite> = [pauseMenuResume, pauseMenuRetry, pauseMenuExit, pauseMenuMute, pauseMenuHelp];
			var mouseMoved:Bool = (FlxG.mouse.x != lastMouseX || FlxG.mouse.y != lastMouseY);

			for (i in 0...buttons.length)
			{
				if (FlxG.mouse.overlaps(buttons[i], subCam))
				{
					if (mouseMoved && pauseSelection != i + 1)
					{
						pauseSelection = i + 1;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						updateSelection();
					}
					
					if (FlxG.mouse.justPressed)
					{
						pauseSelection = i + 1;
						updateSelection();
						selectOption();
					}
					break;
				}
			}

			if (controls.UI_UP_P)
			{
				pauseSelection--;
				if (pauseSelection < 1) pauseSelection = 5;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				updateSelection();
			}
			if (controls.UI_DOWN_P)
			{
				pauseSelection++;
				if (pauseSelection > 5) pauseSelection = 1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				updateSelection();
			}

			if (controls.ACCEPT)
			{
				selectOption();
			}
		}
		else if (helpEnter)
		{
			if (controls.ACCEPT || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(pauseMenuCheckmark, subCam)))
			{
				hideHelp();
			}
		}

		lastMouseX = FlxG.mouse.x;
		lastMouseY = FlxG.mouse.y;
	}

	function selectOption()
	{
		switch (pauseSelection)
		{
			case 1: // Resume
				close();
			case 2: // Restart
				PauseSubState.restartSong(false);
			case 3: // Exit
				exitSong();
			case 4: // Mute
				isMuted = !isMuted;
				pauseMenuMute.animation.play(isMuted ? 'button_muted' : 'button_mute');
				muteAudio(isMuted);
			case 5: // Help
				showHelp();
		}
	}

	function updateSelection()
	{
		for (i in 0...buttons.length)
		{
			var isSelected:Bool = (pauseSelection == i + 1);
			var btn:FlxSprite = buttons[i];
			btn.alpha = isSelected ? 1.0 : 0.6;
			btn.scale.set(isSelected ? 1.0 : 0.85, isSelected ? 1.0 : 0.85);

			// Correct Hitbox + Visual Centering (No Jumping)
			btn.updateHitbox();
			btn.x = buttonCenters[i].x - btn.width / 2;
			btn.y = buttonCenters[i].y - btn.height / 2;
		}
	}

	function showHelp()
	{
		pauseMenuActive = false;
		pauseMenuPrompt.alpha = 1;
		pauseMenuCheckmark.alpha = 1;
		pauseMenuOverlay2.alpha = 0;
		pauseMenuResume.alpha = 0;
		pauseMenuRetry.alpha = 0;
		pauseMenuExit.alpha = 0;
		pauseMenuMute.alpha = 0;
		pauseMenuHelp.alpha = 0;
		levels.alpha = 0;

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			helpEnter = true;
		});
	}

	function hideHelp()
	{
		helpEnter = false;
		pauseMenuPrompt.alpha = 0;
		pauseMenuCheckmark.alpha = 0;
		pauseMenuOverlay2.alpha = 1;
		pauseMenuResume.alpha = 1;
		pauseMenuRetry.alpha = 1;
		pauseMenuExit.alpha = 1;
		pauseMenuMute.alpha = 1;
		pauseMenuHelp.alpha = 1;
		levels.alpha = 1;

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			pauseMenuActive = true;
		});
		updateSelection();
	}

	function muteAudio(mute:Bool)
	{
		FlxG.sound.music.volume = mute ? 0 : 1;
		if (PlayState.instance != null)
		{
			if (PlayState.instance.vocals != null) PlayState.instance.vocals.volume = mute ? 0 : 1;
			if (PlayState.instance.opponentVocals != null) PlayState.instance.opponentVocals.volume = mute ? 0 : 1;
		}
	}

	function exitSong()
	{
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;
		Mods.loadTopMod();
		if (PlayState.isStoryMode)
			MusicBeatState.switchState(new states.StoryMenuState());
		else
			MusicBeatState.switchState(new states.FreeplayState());

		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		PlayState.changedDifficulty = false;
		PlayState.chartingMode = false;
	}
	
	override function destroy()
	{
		if (levelNumberMap != null) levelNumberMap.clear();
		levelNumberMap = null;
		buttons = null;
		buttonCenters = null;

		FlxG.mouse.unload();
		FlxG.mouse.visible = false;
		super.destroy();
	}
}
