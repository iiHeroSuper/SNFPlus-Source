package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import backend.Paths; 
using StringTools;

class GalleryState extends MusicBeatState
{
	// file name, title, desc, type (0 = image, 1 = video, 2 = sound effect, 3 = music)
	var galleryList:Array<Array<Dynamic>> = [
        ["Sanic", "Pre-V1 Sonic", "The first drawing of SNF Sonic ever!! (December 31st 2020)", 0],
		["VID_20210103_200945", "SNF Pre-V1 Footage 1", "Oldest SNF video to ever exist (Jan 3rd 2021)", 1],
		["VID_20210104_151342", "SNF Pre-V1 Footage 2", "(Jan 4th 2021)", 1],
		["VID_20210104_151418", "SNF Pre-V1 Footage 3", "Sans Week Showcase (Part 1, Jan 4th 2021)", 1],
		["VID_20210104_151701", "SNF Pre-V1 Footage 4", "Sans Week Showcase (Part 2, Jan 4th 2021)", 1],
		["VID_20210104_152812", "SNF Pre-V1 Footage 5", "Sans Week Showcase (Part 3, Jan 4th 2021)", 1],
		["audioexample", "Audio Example", "Press enter to play a sound effect.", 2],
		["musicexample", "Audio Example 2", "Press enter to play a song.", 3]
	];
	var disableInput:Bool = true;
    var curSelected:Int = 0;
	var pageNo:Int;
	var img:FlxSprite;
	var daSound:FlxSound;
	var titleG:FlxText;
	var descG:FlxText;
	var instDisplay:FlxText;
	var colorBG:FlxSprite;
	var graphic:FlxSprite;

	override function create(){
		// --- PLAY GALLERY MUSIC (FROM SHARED FOLDER) ---
		// Looks for: assets/shared/music/gallery.ogg
		FlxG.sound.playMusic(Paths.getSharedPath('music/gallery.ogg'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.7); 
		
		pageNo = curSelected + 1;

		var fontPath:String = "assets/fonts/lol.ttf";
		colorBG = new FlxSprite().makeGraphic(1300, 800, FlxColor.fromRGB(FlxG.random.int(0, 225), FlxG.random.int(0, 225), FlxG.random.int(0, 225)));
		colorBG.antialiasing = false;
		colorBG.screenCenter();
		add(colorBG);
		var daBG = new FlxBackdrop("assets/shared/images/gallery/squares.png", XY, 0, 0);
		daBG.updateHitbox();
		daBG.scrollFactor.set(0, 0);
		daBG.alpha = 0.3;
		daBG.setGraphicSize(Std.int(daBG.width * FlxG.random.float(0.5, 1)));
		daBG.screenCenter();
		daBG.velocity.set(FlxG.random.int(-50, 50), FlxG.random.int(-50, 50));
		daBG.antialiasing = false;
		add(daBG);

		loadfirstThing();

		titleG = new FlxText(0, 0, 900, galleryList[curSelected][1]);
		titleG.setFormat(fontPath, 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		titleG.screenCenter();
		titleG.alpha = 0;
		titleG.y -= 290;
		add(titleG);
		descG = new FlxText(0, 0, 900, galleryList[curSelected][2]);
		descG.setFormat(fontPath, 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		descG.screenCenter();
		descG.alpha = 0;
		descG.y += 290;
		add(descG);

		instDisplay = new FlxText(0, 0, 0, "Q/E - Zoom In/Out\nWASD - Move Image\nX - Toggle Text\n" + pageNo + " / " + galleryList.length);
		instDisplay.setFormat(fontPath, 35, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		instDisplay.screenCenter();
		instDisplay.alpha = 0;
		instDisplay.x -= 460;
		add(instDisplay);
		FlxTween.tween(titleG, {y: titleG.y + 10, alpha: 1}, 0.8, {ease: FlxEase.sineOut});
		FlxTween.tween(descG, {y: descG.y - 10, alpha: 1}, 0.8, {ease: FlxEase.sineOut});
		FlxTween.tween(instDisplay, {x: instDisplay.x + 10, alpha: 1}, 0.8, {ease: FlxEase.sineOut, onComplete:function(twn:FlxTween){disableInput = false;}});
		changeItem(0);
		super.create();
	}

	override function update(elapsed:Float){
		if (!disableInput){
			if (FlxG.keys.justPressed.X){
				if (instDisplay.alpha == 1){
					instDisplay.alpha = 0;
					descG.alpha = 0;
					titleG.alpha = 0;
				}else{
					instDisplay.alpha = 1;
					descG.alpha = 1;
					titleG.alpha = 1;
				}
			}

			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE){
				if (daSound != null) daSound.stop();
				
				// --- RESTORE MENU MUSIC ---
				// Assumes freakyMenu.ogg is in assets/music/
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				
				MusicBeatState.switchState(new MainMenuState());
			}

			if (FlxG.keys.justPressed.LEFT) changeItem(-1);
			if (FlxG.keys.justPressed.RIGHT) changeItem(1);
			if (galleryList[curSelected][3] == 0){
				if (FlxG.keys.justPressed.Q) img.scale.set(img.scale.x + 0.2, img.scale.y + 0.2);
				if (FlxG.keys.justPressed.E) img.scale.set(img.scale.x - 0.2, img.scale.y - 0.2);
				if (FlxG.keys.justPressed.W) img.y += 20;
				if (FlxG.keys.justPressed.A) img.x += 20;
				if (FlxG.keys.justPressed.S) img.y -= 20;	
				if (FlxG.keys.justPressed.D) img.x -= 20;
			}

			if (FlxG.keys.justPressed.ENTER){
				if (galleryList[curSelected][3] == 1){
					// Video logic
				}else if (galleryList[curSelected][3] == 2){
					var filepath:String = "assets/shared/sounds/gallery/" + galleryList[curSelected][0] + ".ogg";
					playDaSound(filepath);
				}else if (galleryList[curSelected][3] == 3){
					var filepath:String = "assets/shared/music/gallery/" + galleryList[curSelected][0] + ".ogg";
					playDaSound(filepath);
				}
			}
		}
		super.update(elapsed);
	}

	public function playDaSound(path:String){
		FlxG.sound.music.pause();
		if (daSound != null) daSound.stop();
		daSound = new FlxSound();
		daSound.loadEmbedded(path, false, true);
		daSound.onComplete = function():Void{FlxG.sound.music.resume();}
		daSound.play(true, 0);
	}

	public function changeItem(change:Int){
		curSelected += change;
		if (daSound != null) daSound.stop();
		
		// Resume gallery music if we were playing a sound effect/music snippet
		if(FlxG.sound.music.volume < 0.1 || !FlxG.sound.music.playing)
			FlxG.sound.music.resume();

		if (curSelected < 0) {curSelected = 0;}
		else if (curSelected > galleryList.length - 1) {curSelected = galleryList.length - 1;}
		pageNo = curSelected + 1;
		titleG.text = galleryList[curSelected][1];
		descG.text = galleryList[curSelected][2];
		instDisplay.text = "Q/E - Zoom In/Out\nWASD - Move Image\nX - Toggle Text\n" + pageNo + " / " + galleryList.length;
		loadfirstThing();
	}

	public function loadfirstThing(){
		remove(img);
		img = new FlxSprite().loadGraphic(Paths.image("gallery/img/" + galleryList[curSelected][0]));
		img.scale.set(0.85, 0.85);
		img.scrollFactor.set(0, 0);
		img.screenCenter();
		add(img);

		var graphicPath:String = "";
		switch (galleryList[curSelected][3]){
			case 1: graphicPath = "assets/shared/images/gallery/videoGraphic.png"; 
			default: graphicPath = "assets/shared/images/gallery/audioGraphic.png"; 
		}
		remove(graphic);
		graphic = new FlxSprite().loadGraphic(graphicPath);
		graphic.scale.set(1, 1);
		graphic.scrollFactor.set(0, 0);
		graphic.screenCenter();
		if (galleryList[curSelected][3] != 0) graphic.visible = true;
		else graphic.visible = false;
		add(graphic);

		FlxTween.tween(img, {"scale.x": 0.8, "scale.y": 0.8}, 0.2, {ease: FlxEase.sineOut, onUpdate:function(twn:FlxTween){img.screenCenter();}});
		FlxTween.tween(graphic, {"scale.x": 0.8, "scale.y": 0.8}, 0.2, {ease: FlxEase.sineOut, onUpdate:function(twn:FlxTween){graphic.screenCenter();}});
	}
}