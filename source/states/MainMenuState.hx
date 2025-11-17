// code written by tyler
// snf team you rock :3
// (current code relies on freeplay after pressing play. this will be fixed later)

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
import states.PlaySelectState; 

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0';

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
	var lockedInput:Bool = false;

	override public function create()
	{
		super.create();

		background = new FlxSprite().loadGraphic(Paths.image('newmainmenu/tripletsborn'));
		background.scrollFactor.set(); 
		add(background);

		checkerboard = new FlxBackdrop(Paths.image('newmainmenu/checkems'));
		checkerboard.scale.set(2, 2);
		checkerboard.velocity.set(50, 50); 
		checkerboard.alpha = 1; 
		checkerboard.scrollFactor.set();
		add(checkerboard);

		logo = new FlxSprite(0, 30).loadGraphic(Paths.image('newmainmenu/logo'));
		logo.scale.set(0.7, 0.7); 
		logo.updateHitbox();
		logo.screenCenter(X);
		logoTrail = new FlxTrail(logo, null, 4, 4, 0.3); // (target, graphic, length, delay, alpha)
		add(logoTrail);
		
		add(logo);

		FlxTween.tween(logo, { y: logo.y + 20 }, 1.2, { // (Object, Properties, Duration)
			type: FlxTween.PINGPONG,
			ease: FlxEase.sineInOut
		});

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
	}

	override public function update(elapsed:Float)
	{
		if (lockedInput) 
		{
			super.update(elapsed);
			return;
		}

		super.update(elapsed);

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
				case 0:
					selectedSprite.animation.play('hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						trace("Go to Awards State (not implemented)");
						lockedInput = false; 
					};

				case 1:
					var animName = middleOptions[curMiddleOption];
					selectedSprite.animation.play(animName + '-hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						selectMiddleOption(); 
					};

				case 2:
					selectedSprite.animation.play('hit');
					selectedSprite.animation.finishCallback = function(name:String) {
						MusicBeatState.switchState(new OptionsState());
					};
			}
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
				MusicBeatState.switchState(new FreeplayState()); 
				return;
			case 'gallery':
				trace("Go to Gallery State (not implemented)");
				lockedInput = false; 
				return;
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
				return;
			case 'soundtest':
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