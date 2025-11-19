--Images
function onCreatePost()
--Countdown
	makeLuaSprite('twoFNM', 'FNM UI/FNMready', 0, 0)
	screenCenter('twoFNM', 'xy')
	setObjectCamera('twoFNM', 'other')
	makeLuaSprite('oneFNM', 'FNM UI/FNMset', 0, 0)
	screenCenter('oneFNM', 'xy')
	setObjectCamera('oneFNM', 'other')
	makeLuaSprite('goFNM', 'FNM UI/FNMgo', 0, 0)
	screenCenter('goFNM', 'xy')
	setObjectCamera('goFNM', 'other')
end

function onCountdownTick(swagCounter)
	if swagCounter == 0 then  -- 3
		if songName == 'mama coco night funkin v5' then
		setProperty('countdown3.visible', false)
		else
		--playSound('Intro3', 2)
		makeLuaSprite('3', 'ha1', screenWidth / 1.7 - 369, screenHeight / 1.8 - 185);
		setObjectCamera('3', 'camHUD');
		scaleObject('3', 1, 1);
		doTweenAlpha('elpepe', '3', 0, crochet / 1000, 'cubeInOut');
		setProperty('countdown3.visible', false);
		addLuaSprite('3', true);
		end
	
	elseif swagCounter == 1 then  -- Ready
		if songName == 'mama coco night funkin v5' then
		addLuaSprite('twoFNM')
		setProperty('countdownReady.visible', false);
		else
		--playSound('Intro2', 2)
		makeLuaSprite('ready', 'ha2', screenWidth / 1.7 - 369, screenHeight / 1.8 - 185);
		setObjectCamera('ready', 'camHUD');
		scaleObject('ready', 1, 1);
		doTweenAlpha('elpepe', 'ready', 0, crochet / 1000, 'cubeInOut');
		setProperty('countdownReady.visible', false);
		addLuaSprite('ready', true);
		end
		
	elseif swagCounter == 2 then -- Set
		if songName == 'mama coco night funkin v5' then
		removeLuaSprite('twoFNM', false)
		addLuaSprite('oneFNM')
		setProperty('countdownSet.visible', false);
		else
		--playSound('Intro1', 2)
		makeLuaSprite('set', 'ha3', screenWidth / 1.7 - 369, screenHeight / 1.8 - 185);
		setObjectCamera('set', 'camHUD');
		scaleObject('set', 1, 1);
		doTweenAlpha('elpepe', 'set', 0, crochet / 1000, 'cubeInOut');
		setProperty('countdownSet.visible', false);
		addLuaSprite('set', true);
		end
	
	elseif swagCounter == 3 then -- GO
		if songName == 'mama coco night funkin v5' then
		removeLuaSprite('oneFNM', false)
		addLuaSprite('goFNM')
		setProperty('countdownGo.visible', false);
		else
		--playSound('IntroGo', 2)
		makeLuaSprite('GO', 'one', screenWidth / 1.5 - 569, screenHeight / 1.8 - 185);
		setObjectCamera('GO', 'camHUD');
		scaleObject('GO', 1, 1);
		doTweenAlpha('elpepe', 'GO', 0, crochet / 1000, 'cubeInOut');
		setProperty('countdownGo.visible', false);
		addLuaSprite('GO', true);
		end
		
	elseif swagCounter == 4 then
		if songName == 'mama coco night funkin v5' then
		removeLuaSprite('goFNM')
		end
	end
end
