path = 'newWeek1BG/'

stageYPos = 225
stageXPos = 200

function onCreate()
	-- background shit
	makeLuaSprite('ghz-sky', path..'sky', -500, -300);
	setLuaSpriteScrollFactor('ghz-sky', 1.0, 1.0);
	scaleObject('ghz-sky', 1.5, 1.5);
	
	makeLuaSprite('ghz-back-mountains', path..'back mountains', -560+stageXPos, 0+stageYPos);
	setLuaSpriteScrollFactor('ghz-back-mountains', 0.6, 0.8);
	scaleObject('ghz-back-mountains', 1, 1);
	
	makeLuaSprite('ghz-clouds', path..'cloudass', 600, 50);
	setLuaSpriteScrollFactor('ghz-clouds', 0.3, 0.6);
	scaleObject('ghz-clouds', 1.25, 1.25);
	setProperty('ghz-clouds.velocity.x', -25)
	
	makeLuaSprite('ghz-mountains', path..'pretty thing', -300+stageXPos, 0+stageYPos);
	setLuaSpriteScrollFactor('ghz-mountains', 0.7, 0.8);
	scaleObject('ghz-mountains', 1, 1);
	
	makeAnimatedLuaSprite('ghz-water-yum-yum', path..'waterfall', 845+stageXPos, 175+stageYPos)
	addAnimationByPrefix('ghz-water-yum-yum', 'fall', 'a bunch of assets to make the water to fall', 24, true)
	objectPlayAnimation('ghz-water-yum-yum', 'fall')
	scaleObject('ghz-water-yum-yum', 1.3, 1.3);
	setLuaSpriteScrollFactor('ghz-water-yum-yum', 0.7, 0.8);
	
	makeAnimatedLuaSprite('ghz-water-lake', path..'lake', -400, 700)
	addAnimationByPrefix('ghz-water-lake', 'fall', 'lake', 24, true)
	objectPlayAnimation('ghz-water-lake', 'fall')
	scaleObject('ghz-water-lake', 1.3, 1.3);
	setLuaSpriteScrollFactor('ghz-water-lake', 0.8, 0.8);
	
	--makeAnimatedLuaSprite('ghz-water-yum-yum', path..'waterfall', -600, -200)
	--addAnimationByPrefix('ghz-water-yum-yum', 'fall', 'fall', 24, true)
	--objectPlayAnimation('ghz-water-yum-yum', 'fall')
	
	makeLuaSprite('ghz-hill-that-is-indeed-green', path..'greenhill', -600, 780);
	scaleObject('ghz-hill-that-is-indeed-green', 1.3, 1.3);
	
	addLuaSprite('ghz-sky', false);
	addLuaSprite('ghz-back-mountains', false);
	addLuaSprite('ghz-mountains', false);
	addLuaSprite('ghz-water-lake', false);
	addLuaSprite('ghz-water-yum-yum', false);
	addLuaSprite('ghz-hill-that-is-indeed-green', false);
	addLuaSprite('ghz-clouds', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end