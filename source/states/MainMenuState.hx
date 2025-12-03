// code made by tyler
// if you peek in this code, you'll see segments written by me
// because why not

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import backend.MusicBeatState;
import backend.Paths; 
import flixel.util.FlxTimer;

import flixel.tweens.FlxEase;
import flixel.addons.effects.FlxTrail;

import options.OptionsState; 
import states.CreditsState;
import states.StoryMenuState;
import states.FreeplayState;
import states.AchievementsMenuState; 

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0';
	public static var psychEngineIntro:Bool = false;
	
	// Main Menu Assets
	var background:FlxSprite;
	var checkerboard:FlxBackdrop;
	var logo:FlxSprite;
	var aeroBar:FlxSprite;
	var logoTrail:FlxTrail;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var middleOptions:Array<String> = ['play', 'gallery', 'credits', 'soundtest'];
	var curSelected:Int = 1; 
	var curMiddleOption:Int = 0; 
	var arrowL:FlxSprite;
	var arrowR:FlxSprite;
	
	// Play Select Menu Assets
	var blender:FlxSprite;
	var storyBtn:FlxSprite;
	var freeplayBtn:FlxSprite;
	var selector:FlxSprite; 
	var curPlaySelect:Int = 0;

	// State Management
	var lockedInput:Bool = false;
	var menuMode:Int = 0;

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;

		// Bgs
		background = new FlxSprite().loadGraphic(Paths.image('newmainmenu/tripletsborn'));
		background.scrollFactor.set(); 
		add(background);

		checkerboard = new FlxBackdrop(Paths.image('newmainmenu/checkems'));
		checkerboard.velocity.set(50, 50);
		checkerboard.alpha = 0.4; 
		checkerboard.scrollFactor.set();
		checkerboard.scale.set(3, 3); 
		add(checkerboard);

		// Logo
		logo = new FlxSprite(0, 30).loadGraphic(Paths.image('newmainmenu/logo'));
		logo.scale.set(0.7, 0.7); 
		logo.updateHitbox();
		logo.screenCenter(X);
		
		logoTrail = new FlxTrail(logo, null, 4, 4, 0.3); 
		add(logoTrail);
		add(logo);
		
		FlxTween.tween(logo, { y: logo.y + 20 }, 1.2, {
			type: FlxTween.PINGPONG,
			ease: FlxEase.sineInOut
		});

		// Main Menu Thingies
		aeroBar = new FlxSprite(0, FlxG.height - 220).loadGraphic(Paths.image('newmainmenu/weird aero bar'));
		aeroBar.scale.set(0.75, 0.75);
		aeroBar.updateHitbox();
		aeroBar.screenCenter(X);
		add(aeroBar);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// Trophy
		var trophyIcon = new FlxSprite(aeroBar.x + 80, aeroBar.y + (aeroBar.height / 2));
		trophyIcon.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		trophyIcon.animation.addByPrefix('idle', 'awards norm');
		trophyIcon.animation.addByPrefix('hit', 'awards hit', 24, false);
		trophyIcon.animation.play('idle');
		trophyIcon.scale.set(0.6, 0.6);
		trophyIcon.updateHitbox();
		trophyIcon.x = aeroBar.x + 150;
		trophyIcon.y -= trophyIcon.height / 2;
		menuItems.add(trophyIcon);

		// Middle Option
		var optionSprite = new FlxSprite(0, aeroBar.y + (aeroBar.height / 2));
		optionSprite.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		for (option in middleOptions) {
			optionSprite.animation.addByPrefix(option + '-idle', option + ' norm');
			optionSprite.animation.addByPrefix(option + '-hit', option + ' hit', 24, false);
			optionSprite.animation.addByPrefix(option + '-teelt', option + ' teelt', 24, false);
		}
		optionSprite.animation.addByPrefix('flarp', 'flarp', 24, false);
		optionSprite.scale.set(0.8, 0.8);
		optionSprite.updateHitbox();
		menuItems.add(optionSprite);
		recenterMiddleOption(); 

		// Settings
		var settingsIcon = new FlxSprite(0, aeroBar.y + (aeroBar.height / 2));
		settingsIcon.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		settingsIcon.animation.addByPrefix('idle', 'settings norm');
		settingsIcon.animation.addByPrefix('hit', 'settings hit', 24, false);
		settingsIcon.animation.play('idle');
		settingsIcon.scale.set(0.6, 0.6);
		settingsIcon.updateHitbox();
		settingsIcon.y -= settingsIcon.height / 2;
		settingsIcon.x = (aeroBar.x + aeroBar.width) - 150 - settingsIcon.width; 
		menuItems.add(settingsIcon);

		// Arrows
		arrowL = new FlxSprite(0, 0);
		arrowL.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		arrowL.animation.addByPrefix('idle', 'go there', 24, true);
		arrowL.animation.play('idle');
		arrowL.flipX = true;
		arrowL.scale.set(0.8, 0.8);
		arrowL.updateHitbox();
		add(arrowL);

		arrowR = new FlxSprite(0, 0);
		arrowR.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		arrowR.animation.addByPrefix('idle', 'go there', 24, true);
		arrowR.animation.play('idle');
		arrowR.scale.set(0.8, 0.8);
		arrowR.updateHitbox();
		add(arrowR);

		positionArrows();
		changeSelection();

		// PLAY SELECT ITEMS
		blender = new FlxSprite().loadGraphic(Paths.image('newmainmenu/blender'));
		blender.screenCenter();
		blender.scrollFactor.set();
		blender.visible = false;
		blender.alpha = 0;
		add(blender);

		storyBtn = new FlxSprite(0, 0).loadGraphic(Paths.image('newmainmenu/storymode'));
		storyBtn.scale.set(0.7, 0.7);
		storyBtn.updateHitbox();
		storyBtn.screenCenter(X);
		storyBtn.y = (FlxG.height / 2) - 220; 
		storyBtn.visible = false;
		add(storyBtn);

		freeplayBtn = new FlxSprite(0, 0).loadGraphic(Paths.image('newmainmenu/freeplay'));
		freeplayBtn.scale.set(0.7, 0.7);
		freeplayBtn.updateHitbox();
		freeplayBtn.screenCenter(X);
		freeplayBtn.y = (FlxG.height / 2) - 5; 
		freeplayBtn.visible = false;
		add(freeplayBtn);

		selector = new FlxSprite();
		selector.frames = Paths.getSparrowAtlas('newmainmenu/arrowthing');
		selector.animation.addByPrefix('idle', 'gay little arrow', 24, true);
		selector.animation.play('idle');
		selector.angle = 90; 
		selector.scale.set(0.8, 0.8);
		selector.updateHitbox();
		selector.visible = false;
		add(selector);

		updatePlaySelectSelection(0); 
		
		if (psychEngineIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 4);
			psychEngineIntro = false;
		}
	}

	override public function update(elapsed:Float)
	{
		if (lockedInput) 
		{
			super.update(elapsed);
			return;
		}

		super.update(elapsed);
		if (menuMode == 0) {
			updateMainMenu();
		} else {
			updatePlaySelect();
		}
	}
	
	function updateMainMenu()
	{
		if (FlxG.mouse.overlaps(arrowL))
		{
			if (FlxG.mouse.justPressed) {
				changeMiddleOption(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}
		if (FlxG.mouse.overlaps(arrowR))
		{
			if (FlxG.mouse.justPressed) {
				changeMiddleOption(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (FlxG.mouse.overlaps(spr))
			{
				var id:Int = menuItems.members.indexOf(spr);
				if (curSelected != id)
				{
					curSelected = id;
					changeSelection(0);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				
				if (FlxG.mouse.justPressed)
				{
					acceptSelection();
				}
			}
		});

		if (controls.UI_LEFT_P)
		{
			if (curSelected == 1)
			{
				changeMiddleOption(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else
			{
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}
		
		if (controls.UI_RIGHT_P)
		{
			if (curSelected == 1)
			{
				changeMiddleOption(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else
			{
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}

		if (controls.ACCEPT)
		{
			acceptSelection();
		}
	}

	function acceptSelection()
	{
		lockedInput = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		var selectedSprite = menuItems.members[curSelected];
		
		switch(curSelected)
		{
			case 0: // TROPHY
				selectedSprite.animation.play('hit');
				selectedSprite.animation.finishCallback = function(name:String) {
					FlxG.mouse.visible = false;
					MusicBeatState.switchState(new AchievementsMenuState());
				};

			case 1: // MIDDLE OPTION
				var animName = middleOptions[curMiddleOption];
				selectedSprite.animation.play(animName + '-hit');
				selectedSprite.animation.finishCallback = function(name:String) {
					selectMiddleOption(); 
				};

			case 2: // SETTINGS
				selectedSprite.animation.play('hit');
				selectedSprite.animation.finishCallback = function(name:String) {
					FlxG.mouse.visible = false;
					MusicBeatState.switchState(new OptionsState());
				};
		}
	}
	
	function updatePlaySelect()
	{
		if (FlxG.mouse.overlaps(storyBtn))
		{
			if (curPlaySelect != 0) {
				updatePlaySelectSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (FlxG.mouse.justPressed) acceptPlaySelect();
		}
		
		if (FlxG.mouse.overlaps(freeplayBtn))
		{
			if (curPlaySelect != 1) {
				updatePlaySelectSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (FlxG.mouse.justPressed) acceptPlaySelect();
		}

		if (controls.UI_UP_P || controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			updatePlaySelectSelection(1);
		}

		if (controls.ACCEPT)
		{
			acceptPlaySelect();
		}

		if (controls.BACK)
		{
			lockedInput = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			
			FlxTween.tween(blender, {alpha: 0}, 0.2);
			selector.visible = false;
			storyBtn.visible = false;
			freeplayBtn.visible = false;
			
			new FlxTimer().start(0.2, function(tmr:flixel.util.FlxTimer) {
				blender.visible = false;
				menuMode = 0; 
				menuItems.visible = true;
				arrowL.visible = true;
				arrowR.visible = true;
				aeroBar.visible = true;
				logo.visible = true;
				logoTrail.visible = true;
				lockedInput = false; 
			});
		}
	}

	function acceptPlaySelect()
	{
		lockedInput = true; 
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var selectedBtn = (curPlaySelect == 0) ? storyBtn : freeplayBtn;
		FlxTween.tween(selectedBtn.scale, {x: 0.75, y: 0.75}, 0.1, {ease: FlxEase.sineInOut, type: FlxTween.PINGPONG});
		new flixel.util.FlxTimer().start(0.5, function(tmr:flixel.util.FlxTimer) {
			FlxG.mouse.visible = false;
			if (curPlaySelect == 0) MusicBeatState.switchState(new StoryMenuState());
			else MusicBeatState.switchState(new FreeplayState());
		});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0) curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length) curSelected = 0;

		for (i in 0...menuItems.length)
		{
			var item = menuItems.members[i];
			item.alpha = 0.6;
			if(i == 0) item.animation.play('idle');
			if(i == 1) {
				item.animation.play(middleOptions[curMiddleOption] + '-idle');
				item.updateHitbox();
			}
			if(i == 2) item.animation.play('idle');
		}
		
		// update log: opacity
		// if on Middle Option (1), alpha 1.0. if not, alpha 0.6.
		arrowL.alpha = (curSelected == 1) ? 1.0 : 0.6;
		arrowR.alpha = (curSelected == 1) ? 1.0 : 0.6;
		
		recenterMiddleOption();
		positionArrows();
		var selectedItem = menuItems.members[curSelected];
		selectedItem.alpha = 1.0;
		if (curSelected == 1) 
		{
			var animName = middleOptions[curMiddleOption];
			selectedItem.animation.play(animName + '-hit');
			selectedItem.animation.finishCallback = function(name:String) {
				selectedItem.animation.play(animName + '-idle');
				selectedItem.updateHitbox();
				recenterMiddleOption();
				positionArrows();
				lockedInput = false;
			};
		}
		else
		{
			selectedItem.animation.play('hit');
			selectedItem.animation.finishCallback = function(name:String) {
				selectedItem.animation.play('idle');
				lockedInput = false;
			};
		}
	}

	//update log: fied animation order
	function changeMiddleOption(change:Int = 0)
	{
		lockedInput = true;
		
		curMiddleOption += change;
		if (curMiddleOption < 0) curMiddleOption = middleOptions.length - 1;
		if (curMiddleOption >= middleOptions.length) curMiddleOption = 0;

		var animName = middleOptions[curMiddleOption];
		var optionSprite = menuItems.members[1]; 
		
		// 1. Play TEELT
		optionSprite.animation.play(animName + '-teelt', true);
		optionSprite.updateHitbox();
		recenterMiddleOption();
		
		optionSprite.animation.finishCallback = function(name:String) {
			if (name == animName + '-teelt')
			{
				// 2. Play FLARP
				optionSprite.animation.play('flarp', true);
				optionSprite.updateHitbox();
				recenterMiddleOption();
				
				// 3. Switch to IDLE
				optionSprite.animation.finishCallback = function(name2:String) {
					if (name2 == 'flarp') {
						optionSprite.animation.play(animName + '-idle');
						optionSprite.updateHitbox();
						recenterMiddleOption();
						positionArrows();
						lockedInput = false;
					}
				};
			}
		};
	}

	function selectMiddleOption()
	{
		var selection = middleOptions[curMiddleOption];
		switch(selection)
		{
			case 'play':
				lockedInput = true;
				menuMode = 1;
				menuItems.visible = false;
				aeroBar.visible = false;
				arrowL.visible = false;
				arrowR.visible = false;
				logo.visible = false;
				logoTrail.visible = false;
				
				blender.visible = true;
				FlxTween.tween(blender, {alpha: 1}, 0.4, {ease: FlxEase.quartOut});
				storyBtn.visible = true;
				freeplayBtn.visible = true;
				selector.visible = true;
				
				updatePlaySelectSelection(0);
				new flixel.util.FlxTimer().start(0.2, function(tmr:flixel.util.FlxTimer)
				{
					lockedInput = false;
				});
				return;
			case 'gallery':
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new GalleryState()); 
				return;
			case 'credits':
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new CreditsState());
				return;
			case 'soundtest':
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new SoundTestState());
				return;
		}
	}
	
	function updatePlaySelectSelection(change:Int = 0)
	{
		if(change != 0)
			curPlaySelect = (curPlaySelect == 0) ? 1 : 0;
		
		if (curPlaySelect == 0) {
			storyBtn.alpha = 1.0;
			freeplayBtn.alpha = 0.6;
		} else {
			storyBtn.alpha = 0.6;
			freeplayBtn.alpha = 1.0;
		}

		if (curPlaySelect == 0) 
		{
			selector.x = storyBtn.x - selector.width + 10;
			selector.y = storyBtn.y + (storyBtn.height / 2) - (selector.height / 2);
		}
		else 
		{
			selector.x = freeplayBtn.x - selector.width + 10;
			selector.y = freeplayBtn.y + (freeplayBtn.height / 2) - (selector.height / 2);
		}
	}

	function positionArrows()
	{
		var optionSprite = menuItems.members[1];
		arrowL.x = optionSprite.x - arrowL.width - 20;
		arrowL.y = optionSprite.y + (optionSprite.height / 2) - (arrowL.height / 2);
		arrowR.x = optionSprite.x + optionSprite.width + 20;
		arrowR.y = optionSprite.y + (optionSprite.height / 2) - (arrowR.height / 2);
	}

	function recenterMiddleOption()
	{
		var optionSprite = menuItems.members[1];
		optionSprite.x = aeroBar.x + (aeroBar.width / 2) - (optionSprite.width / 2);
		optionSprite.y = (aeroBar.y + (aeroBar.height / 2)) - (optionSprite.height / 2) - 15;
	}
}