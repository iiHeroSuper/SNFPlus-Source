package;

/*
use this if you're using the latest Psych Engine
package states;
(put this file in "source/states")

use this if you are using codename:
package funkin.menus;
(put this file in "source/funkin/menus", yes this is codename source)

use this if you are adding it to base fnf:
package funkin.ui;
(put this file in "source/funkin/ui")

use this if you are using forever engine:
package meta.state.menus;
(put this file in "source/meta/state/menus")

use this if your 'source' folder within you mod has no files/not all files organized into folders (eg. Kade Engine, Mic'd Up, Psych Engine 0.6.3):
package;
(put this file in "source")
*/

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
import flixel.util.FlxColor;
using StringTools;

/*
----- HXCODEC (USED IN PSYCH ENGINE AT ONE POINT??????, BASE FNF, I WILL USE IT HERE BY DEFAULT) -----

1. Make sure you've installed hxCodec (recommended version 3.0.2)
2. ADD THIS TO YOUR PROJECT.XML FILE FIRST IF YOU DON'T HAVE THIS!!!!:
<haxelib name="hxCodec" if="desktop || android" />

3. Take this code out of the comment:

#if (hxCodec >= "2.7.0")
import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec == "2.6.1")
import hxcodec.VideoHandler;
#elseif (hxCodec == "2.6.0")
import VideoHandler;
#else
import vlc.MP4Handler as VideoHandler;
#end

Note for BASE FNF:
The Funkin' Crew have committed a little bit of tomfoolery with their videos....
They created a class based on hxCodec called FunkinVideoSprite, the only difference
between the two is that with FunkinVideoSprite you have more control with the video's volume.

THIS IS OPTIONAL but if you wish to use it, then:

1. You'll need to remove the hxCodec code below (lines 70 - 78) this entire comment and replace it with
just this line:
import funkin.graphics.video.FunkinVideoSprite;

...and then edit slightly the video code at line 226
from this:
var video:VideoHandler = new VideoHandler();
to this:
var video:FunkinVideoSprite = new FunkinVideoSprite(0, 0);

----- HXVLC (USED IN PSYCH ENGINE 1.0 AND CODENAME ENGINE) -----

1. Make sure you've installed hxvlc (recommended version 1.9.2)
2. ADD THIS TO YOUR PROJECT.XML FILE FIRST IF YOU DON'T HAVE THIS!!!!: 
<haxelib name="hxvlc" if="VIDEOS_ALLOWED" version="1.9.2"/>
3. Take this code outside of the comment:
import hxvlc.flixel.FlxVideoSprite;
*/

class GalleryState extends FlxState{
	// file name, title, desc, type (0 = image, 1 = video, 2 = sound effect, 3 = music)
	var galleryList:Array<Array<Dynamic>> = [
        ["bima", "bimagamongMOP", "The creator of this gallery and this image.", 0],
		["videoexample", "Video Example", "Press enter to play your video.", 1],
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
				FlxG.switchState(new MainMenuState());
				/*
					Adding this in case:
					MusicBeatState.switchState(new MainMenuState());
				*/
			}

			if (FlxG.keys.justPressed.LEFT) changeItem(-1);
			if (FlxG.keys.justPressed.RIGHT) changeItem(1);
			if (galleryList[curSelected][3] == 0){
				if (FlxG.keys.justPressed.Q) img.scale.set(img.scale.x + 0.2, img.scale.y + 0.2);
				if (FlxG.keys.justPressed.E) img.scale.set(img.scale.x - 0.2, img.scale.y - 0.2);
				if (FlxG.keys.justPressed.W) img.y -= 20;
				if (FlxG.keys.justPressed.A) img.x -= 20;
				if (FlxG.keys.justPressed.S) img.y += 20;	
				if (FlxG.keys.justPressed.D) img.x += 20;
			}

			if (FlxG.keys.justPressed.ENTER){
				if (galleryList[curSelected][3] == 1){
					if (FlxG.keys.justPressed.ENTER){
						FlxG.sound.music.pause();
						disableInput = true;
						img.alpha = 0;
						instDisplay.alpha = 0;
						descG.alpha = 0;
						titleG.alpha = 0;
						graphic.alpha = 0;
		
						// CHANGE THE PATH IF NEEDED!
						var filepath:String = "assets/videos/gallery/" + galleryList[curSelected][0] + ".mp4";
		
						/* 
						---- HXCODEC ----
						var video:VideoHandler = new VideoHandler();
						#if (hxCodec >= "3.0.0")
						// RECENT VERSIONS
						video.play(filepath);
						video.onEndReached.add(function()
						{
							video.dispose();
							FlxG.sound.music.resume();
							disableInput = false;
							img.alpha = 1;
							instDisplay.alpha = 1;
							descG.alpha = 1;
							titleG.alpha = 1;
							graphic.alpha = 1;
							return;
						}, true);
						#else
						// OLDER VERSIONS
						video.playVideo(filepath);
						video.finishCallback = function()
						{
							FlxG.sound.music.resume();
							disableInput = false;
							img.alpha = 1;
							instDisplay.alpha = 1;
							descG.alpha = 1;
							titleG.alpha = 1;
							graphic.alpha = 1;
							return;
						}
						#end	
						---- HXVLC ----
						var video:FlxVideoSprite = new FlxVideoSprite(0, 0);
						video.load(filepath);
						video.bitmap.onFormatSetup.add(function():Void
						{
							if (video.bitmap != null && video.bitmap.bitmapData != null)
							{
								final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);
								video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
								video.updateHitbox();
								video.screenCenter();
							}
						});
						video.bitmap.onEndReached.add(function()
						{
							video.destroy();
							FlxG.sound.music.resume();
							disableInput = false;
							img.alpha = 1;
							instDisplay.alpha = 1;
							descG.alpha = 1;
							titleG.alpha = 1;
							graphic.alpha = 1;
							remove(video);						
						});
						video.play();
						add(video);	
						*/			
					}
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
			case 1: graphicPath = "assets/shared/images/gallery/videoGraphic.png"; //displays the video graphic 
			default: graphicPath = "assets/shared/images/gallery/audioGraphic.png"; //displays the audio graphic
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