// written by tyler :3

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import backend.Paths;
import backend.MusicBeatState;
import flixel.addons.display.FlxBackdrop;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class SoundTestState extends MusicBeatState
{
	var musicList:Array<String> = [];
	var soundList:Array<String> = [];

	var curSelected:Int = 0; 
	var pcmValue:Int = 0;
	var daValue:Int = 0;

	var pcmText:FlxText;
	var daText:FlxText;
	var headerText:FlxText;
	var background:FlxSprite;
	var checkerboard:FlxBackdrop;

	// --- Character Sprites ---
	var tinySonic:FlxSprite;
	var tinyBreezie:FlxSprite;

	override function create()
	{
		// Gallery Music
		FlxG.sound.playMusic(Paths.getSharedPath('music/gallery.ogg'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.7);

		generateLists();

		// Background
		if(Paths.fileExists('images/menus/soundtest_bg.png', IMAGE)) {
			background = new FlxSprite().loadGraphic(Paths.image('menus/soundtest_bg'));
		} else {
			background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000088);
		}
		background.screenCenter();
        background.scrollFactor.set();
		add(background);

		checkerboard = new FlxBackdrop(Paths.image('newmainmenu/checkems'));
		checkerboard.velocity.set(50, 50);
		checkerboard.alpha = 0.4; 
		checkerboard.scrollFactor.set();
		checkerboard.scale.set(3, 3); 
		add(checkerboard);

		tinyBreezie = new FlxSprite(50, 250); 
		tinyBreezie.frames = Paths.getSparrowAtlas('soundtestmenu/tinybreezie');
		tinyBreezie.animation.addByPrefix('idle', 'tiny breezie', 24, true);
		tinyBreezie.animation.play('idle');
		tinyBreezie.setGraphicSize(Std.int(tinyBreezie.width * 0.8));
		tinyBreezie.updateHitbox();
		tinyBreezie.antialiasing = ClientPrefs.data.antialiasing;
		add(tinyBreezie);

		tinySonic = new FlxSprite(FlxG.width - 400, 250); 
		tinySonic.frames = Paths.getSparrowAtlas('soundtestmenu/tinysonic');
		tinySonic.animation.addByPrefix('idle', 'tiny sonic', 24, true);
		tinySonic.animation.play('idle');
		tinySonic.setGraphicSize(Std.int(tinySonic.width * 0.8));
		tinySonic.updateHitbox();
		tinySonic.antialiasing = ClientPrefs.data.antialiasing;
		add(tinySonic);

		headerText = new FlxText(0, 100, FlxG.width, "SOUND TEST", 64);
		headerText.setFormat(Paths.font("bluespeed.ttf"), 64, FlxColor.YELLOW, CENTER);
		headerText.borderSize = 4;
		add(headerText);

		pcmText = new FlxText(0, 300, FlxG.width, "PCM  NO . 00", 48);
		pcmText.setFormat(Paths.font("cdfont.ttf"), 48, FlxColor.WHITE, CENTER);
        pcmText.borderSize = 3;
		add(pcmText);

		daText = new FlxText(0, 450, FlxG.width, "DA   NO . 00", 48);
		daText.setFormat(Paths.font("cdfont.ttf"), 48, FlxColor.WHITE, CENTER);
        daText.borderSize = 3;
		add(daText);

        var helpText = new FlxText(0, FlxG.height - 50, FlxG.width, "ARROWS: Select/Change | ENTER: Play | ESC: Exit", 24);
        helpText.setFormat(Paths.font("cdfont.ttf"), 24, FlxColor.WHITE, CENTER);
        add(helpText);

		changeSelection(0);
        updateText();

		super.create();
	}

	function generateLists()
	{
		#if sys
		var songsPath = "assets/songs/";
		if (FileSystem.exists(songsPath)) {
			for (folder in FileSystem.readDirectory(songsPath)) {
				if (FileSystem.isDirectory(songsPath + folder) && FileSystem.exists(songsPath + folder + "/Inst.ogg")) {
					musicList.push(folder);
				}
			}
		}
		
		var musicPath = "assets/shared/music/";
		if (FileSystem.exists(musicPath)) {
			for (file in FileSystem.readDirectory(musicPath)) {
				if (file.endsWith(".ogg")) {
					musicList.push(file.replace(".ogg", ""));
				}
			}
		}

		var soundPath = "assets/shared/sounds/";
		if (FileSystem.exists(soundPath)) {
			for (file in FileSystem.readDirectory(soundPath)) {
				if (file.endsWith(".ogg")) {
					soundList.push(file.replace(".ogg", ""));
				}
			}
		}
		
		var soundPathBase = "assets/sounds/";
		if (FileSystem.exists(soundPathBase)) {
			for (file in FileSystem.readDirectory(soundPathBase)) {
				if (file.endsWith(".ogg")) {
					var name = file.replace(".ogg", "");
					if(!soundList.contains(name)) soundList.push(name);
				}
			}
		}
		#else
		musicList = ["Test", "Bopeebo"];
		soundList = ["scrollMenu", "confirmMenu"];
		#end

		musicList.sort(function(a, b) return Reflect.compare(a.toLowerCase(), b.toLowerCase()));
		soundList.sort(function(a, b) return Reflect.compare(a.toLowerCase(), b.toLowerCase()));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.UI_UP_P || controls.UI_DOWN_P)
		{
			changeSelection(controls.UI_UP_P ? -1 : 1);
            FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if (controls.UI_LEFT_P)
		{
			changeNumber(-1);
            FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_RIGHT_P)
		{
			changeNumber(1);
            FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if (controls.ACCEPT)
		{
            playAudio();
		}
	}

	function changeSelection(change:Int)
	{
		curSelected += change;
		if (curSelected < 0) curSelected = 1;
		if (curSelected > 1) curSelected = 0;

		if (curSelected == 0)
		{
			pcmText.color = FlxColor.YELLOW;
            pcmText.alpha = 1;
			daText.color = FlxColor.WHITE;
            daText.alpha = 0.6;
		}
		else
		{
			pcmText.color = FlxColor.WHITE;
            pcmText.alpha = 0.6;
			daText.color = FlxColor.YELLOW;
            daText.alpha = 1;
		}
	}

	function changeNumber(change:Int)
	{
		if (curSelected == 0)
		{
			if(soundList.length == 0) return;
			pcmValue += change;
			if (pcmValue > soundList.length - 1) pcmValue = 0;
			if (pcmValue < 0) pcmValue = soundList.length - 1;
		}
		else
		{
			if(musicList.length == 0) return;
			daValue += change;
			if (daValue > musicList.length - 1) daValue = 0;
			if (daValue < 0) daValue = musicList.length - 1;
		}

        updateText();
	}

    function updateText()
    {
        var pcmString:String = (pcmValue < 10) ? "0" + pcmValue : "" + pcmValue;
        var daString:String = (daValue < 10) ? "0" + daValue : "" + daValue;

        pcmText.text = "PCM  NO . " + pcmString;
        daText.text =  "DA   NO . " + daString;
    }

    function playAudio()
    {
        if(pcmValue == 12 && daValue == 25)
        {
            FlxG.sound.play(Paths.sound('secret')); 
            return; 
        }

        if (curSelected == 0)
        {
			if(soundList.length == 0) return;
            var soundName = soundList[pcmValue];
			
            try {
				FlxG.sound.play(Paths.sound(soundName));
			} catch(e:Dynamic) {
				trace("Could not play sound: " + soundName);
			}
        }
        else
        {
			if(musicList.length == 0) return;
            var songName = musicList[daValue];
            
			try {
				if (FileSystem.exists("assets/songs/" + songName.toLowerCase() + "/Inst.ogg")) {
					FlxG.sound.playMusic(Paths.inst(songName), 1);
				}
				else {
					FlxG.sound.playMusic(Paths.getSharedPath("music/" + songName + ".ogg"), 1);
				}
			} catch(e:Dynamic) {
				trace("Error playing audio: " + songName);
			}
        }
    }
}