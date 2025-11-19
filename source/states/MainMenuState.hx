// code written by tyler
// snf team you rock :3

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import backend.MusicBeatState;
import backend.Paths; 

import flixel.tweens.FlxEase;
import flixel.addons.effects.FlxTrail;

import options.OptionsState; 
import states.CreditsState;
import states.StoryMenuState;
import states.FreeplayState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0';

	// Main Menu
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
	
	var blender:FlxSprite;
	var storyBtn:FlxSprite;
	var freeplayBtn:FlxSprite;
	var selector:FlxSprite; 
	var curPlaySelect:Int = 0;

	var lockedInput:Bool = false;
	var menuMode:Int = 0;

	override public function create()
	{
		super.create();

		// BACKGROUNDS
		background = new FlxSprite().loadGraphic(Paths.image('newmainmenu/tripletsborn'));
		background.scrollFactor.set(); 
		add(background);

		checkerboard = new FlxBackdrop(Paths.image('newmainmenu/checkems'));
		checkerboard.velocity.set(50, 50); 
		checkerboard.scrollFactor.set();
		checkerboard.scale.set(3, 3); 
		add(checkerboard);

		// LOGO
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

		// MAIN MENU ITEMS
		aeroBar = new FlxSprite(0, FlxG.height - 220).loadGraphic(Paths.image('newmainmenu/weird aero bar'));
		aeroBar.scale.set(0.75, 0.75);
		aeroBar.updateHitbox();
		aeroBar.screenCenter(X);
		add(aeroBar);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

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

		var optionSprite = new FlxSprite(0, aeroBar.y + (aeroBar.height / 2));
		optionSprite.frames = Paths.getSparrowAtlas('newmainmenu/bootens');
		for (option in middleOptions) {
			optionSprite.animation.addByPrefix(option + '-idle', option + ' norm');
			optionSprite.animation.addByPrefix(option + '-hit', option + ' hit', 24, false);
		}
		optionSprite.animation.addByPrefix('flarp', 'flarp', 24, false);
		optionSprite.scale.set(0.8, 0.8);
		optionSprite.updateHitbox();
		optionSprite.y -= (optionSprite.height / 2) + 15;
		menuItems.add(optionSprite);
		recenterMiddleOption(); 

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
		
		// PLAY SELECT MENU ITEMS (Story vs Freeplay)
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
		var moved:Bool = false;
		if (controls.UI_LEFT_P)
		{
			lockedInput = true;
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
			moved = true;
		}
		
		if (controls.UI_RIGHT_P)
		{
			lockedInput = true;
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
			moved = true;
		}

		if (controls.ACCEPT)
		{
			lockedInput = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			var selectedSprite = menuItems.members[curSelected];
			
			switch(curSelected)
			{
				case 0: // TROPHY
					selectedSprite.animation.play('hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						trace("Go to Awards State");
						lockedInput = false; 
					};

				case 1: // PLAY
					var animName = middleOptions[curMiddleOption];
					selectedSprite.animation.play(animName + '-hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						selectMiddleOption(); 
					};

				case 2: // SETTINGS
					selectedSprite.animation.play('hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						MusicBeatState.switchState(new OptionsState());
					};
			}
		}
	}
	
	function updatePlaySelect()
	{
		if (controls.UI_UP_P || controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			updatePlaySelectSelection(1);
		}

		if (controls.ACCEPT)
		{
			lockedInput = true; 
			FlxG.sound.play(Paths.sound('confirmMenu'));

			var selectedBtn = (curPlaySelect == 0) ? storyBtn : freeplayBtn;
			FlxTween.tween(selectedBtn.scale, {x: 0.75, y: 0.75}, 0.1, {ease: FlxEase.sineInOut, type: FlxTween.PINGPONG});

			new flixel.util.FlxTimer().start(0.5, function(tmr:flixel.util.FlxTimer) {
				if (curPlaySelect == 0) // Story (Top)
				{
					MusicBeatState.switchState(new StoryMenuState());
				}
				else
				{
					MusicBeatState.switchState(new FreeplayState());
				}
			});
		}

		if (controls.BACK)
		{
			lockedInput = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxTween.tween(blender, {alpha: 0}, 0.2);
			selector.visible = false;
			storyBtn.visible = false;
			freeplayBtn.visible = false;

			new flixel.util.FlxTimer().start(0.2, function(tmr:flixel.util.FlxTimer) {
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

	function changeMiddleOption(change:Int = 0)
	{
		curMiddleOption += change;
		if (curMiddleOption < 0) curMiddleOption = middleOptions.length - 1;
		if (curMiddleOption >= middleOptions.length) curMiddleOption = 0;

		var animName = middleOptions[curMiddleOption];
		var optionSprite = menuItems.members[1]; 
		
		optionSprite.animation.play('flarp');
		optionSprite.animation.finishCallback = function(name:String) {
			if (name == 'flarp')
			{
				optionSprite.animation.play(animName + '-idle');
				optionSprite.updateHitbox();
				recenterMiddleOption();
				positionArrows();
				lockedInput = false;
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
				trace("Go to Gallery");
				lockedInput = false; 
				return;
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
				return;
			case 'soundtest':
				trace("Go to SoundTest");
				lockedInput = false; 
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
			selector.x = storyBtn.x - selector.width + 10; // Slight offset
			selector.y = storyBtn.y + (storyBtn.height / 2) - (selector.height / 2);
		}
		else
		{

			selector.x = freeplayBtn.x - selector.width + 10; // Slight offset
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
	}
}