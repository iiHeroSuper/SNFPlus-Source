isMuted = false
pauseMenuActive = false
helpEnter = false
pauseSelection = 1

-- LEVEL NUMBER HERE!
levelNumber = "ENCRYPTING FILES..."

--[[

Context as of why I called this as "oh that must be them":
"Angry Mogging" by VibingLeaf

]]

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

isCountdownStarted = false
pressedAnyButtons = false
ringCount = 0
ringCountCheck = false
startGameFix = false

local ringChecks = {2, 3, 4, 5, 6, 7, 8, 9,
10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
30, 31, 32}
local ringCountCheckNum = 2
walkingDist = 2170

runningSpeed = 0.1
minuteNum = 0
secondNum = 0
debugNum = 9999
tenSecondPassed = false

function onStartCountdown()
	if not isCountdownStarted then
	isCountdownStarted = true
	runTimer('opacity here', 1)
	runTimer('open game', 3.5)
	return Function_Stop;
	else
	return Function_Continue;
	end
end

function onCreate()
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	setProperty('skipCountdown', true)
	
	runHaxeCode([[
		FlxG.mouse.unload();
		FlxG.log.add("Angry Birds Cursor" + Paths.image("ab_cursor")); // amogusgameALT i'm looking at you 
		FlxG.mouse.load(Paths.image("ab_cursor").bitmap, 1, 0); // you can't hide what you did
	]])
	
	
	-- I have to make multiple lua sprites..............................................
	makeAnimatedLuaSprite('pauseMenuOverlay1', '3lamepausemenu', 0, 0) -- I DON'T GIVE A SHIT THAT IT'S LAME, FILE NAME!!!!!!! /silly (- Herox)
	addAnimationByPrefix('pauseMenuOverlay1', 'overlay_1', 'overlay_1', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'overlay_2', 'overlay_2', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_exit', 'button_exit', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_help', 'button_help', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_mute', 'button_mute', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_muted', 'button_muted', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_resume', 'button_resume', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_retry', 'button_retry', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'button_yuh_huh', 'button_yuh_huh', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'prompt_help', 'prompt_help', 0, false)
	addAnimationByPrefix('pauseMenuOverlay1', 'restart_song', 'restart_song', 0, false)
	objectPlayAnimation('pauseMenuOverlay1', 'overlay_2')
	setObjectCamera('pauseMenuOverlay1', 'other')
	addLuaSprite('pauseMenuOverlay1', true)
	setProperty('pauseMenuOverlay1.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuOverlay2', '3lamepausemenu', 0, 0)
	addAnimationByPrefix('pauseMenuOverlay2', 'overlay_1', 'overlay_1', 0, false)
	objectPlayAnimation('pauseMenuOverlay2', 'overlay_1')
	setObjectCamera('pauseMenuOverlay2', 'other')
	addLuaSprite('pauseMenuOverlay2', true)
	setProperty('pauseMenuOverlay2.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuResume', '3lamepausemenu', 10, 10)
	addAnimationByPrefix('pauseMenuResume', 'button_resume', 'button_resume', 0, false)
	objectPlayAnimation('pauseMenuResume', 'button_resume')
	scaleObject('pauseMenuResume', 0.9, 0.9)
	setObjectCamera('pauseMenuResume', 'other')
	addLuaSprite('pauseMenuResume', true)
	setProperty('pauseMenuResume.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuRetry', '3lamepausemenu', 125, 200+15)
	addAnimationByPrefix('pauseMenuRetry', 'button_retry', 'button_retry', 0, false)
	objectPlayAnimation('pauseMenuRetry', 'button_retry')
	scaleObject('pauseMenuRetry', 0.9, 0.9)
	setObjectCamera('pauseMenuRetry', 'other')
	addLuaSprite('pauseMenuRetry', true)
	setProperty('pauseMenuRetry.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuExit', '3lamepausemenu', 125, 400-15)
	addAnimationByPrefix('pauseMenuExit', 'button_exit', 'button_exit', 0, false)
	objectPlayAnimation('pauseMenuExit', 'button_exit')
	scaleObject('pauseMenuExit', 0.9, 0.9)
	setObjectCamera('pauseMenuExit', 'other')
	addLuaSprite('pauseMenuExit', true)
	setProperty('pauseMenuExit.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuMute', '3lamepausemenu', 90, 600)
	addAnimationByPrefix('pauseMenuMute', 'button_mute', 'button_mute', 0, false)
	addAnimationByPrefix('pauseMenuMute', 'button_muted', 'button_muted', 0, false)
	objectPlayAnimation('pauseMenuMute', 'button_mute')
	scaleObject('pauseMenuMute', 0.9, 0.9)
	setObjectCamera('pauseMenuMute', 'other')
	addLuaSprite('pauseMenuMute', true)
	setProperty('pauseMenuMute.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuHelp', '3lamepausemenu', 190, 600)
	addAnimationByPrefix('pauseMenuHelp', 'button_help', 'button_help', 0, false)
	objectPlayAnimation('pauseMenuHelp', 'button_help')
	scaleObject('pauseMenuHelp', 0.9, 0.9)
	setObjectCamera('pauseMenuHelp', 'other')
	addLuaSprite('pauseMenuHelp', true)
	setProperty('pauseMenuHelp.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuPrompt', '3lamepausemenu', 0, 0)
	addAnimationByPrefix('pauseMenuPrompt', 'prompt_help', 'prompt_help', 0, false)
	objectPlayAnimation('pauseMenuPrompt', 'prompt_help')
	setObjectCamera('pauseMenuPrompt', 'other')
	scaleObject('pauseMenuPrompt', 0.75, 0.75)
	screenCenter('pauseMenuPrompt')
	addLuaSprite('pauseMenuPrompt', true)
	setProperty('pauseMenuPrompt.alpha', 0)
	
	makeAnimatedLuaSprite('pauseMenuCheckmark', '3lamepausemenu', 775, 500)
	addAnimationByPrefix('pauseMenuCheckmark', 'button_yuh_huh', 'button_yuh_huh', 0, false)
	objectPlayAnimation('pauseMenuCheckmark', 'button_yuh_huh')
	setObjectCamera('pauseMenuCheckmark', 'other')
	scaleObject('pauseMenuCheckmark', 0.75, 0.75)
	-- screenCenter('pauseMenuCheckmark')
	addLuaSprite('pauseMenuCheckmark', true)
	setProperty('pauseMenuCheckmark.alpha', 0)
	
	makeLuaText('levels', levelNumber, 0, -260, 25) -- 180
	setProperty('levels.antialiasing', false)
	setTextFont('levels', 'angrybirds-regular.ttf')
	setTextSize('levels', 50, 50) -- 80
	addLuaText('levels')
	setTextAlignment('levels', 'center')
	setTextWidth('levels', 1000)
	setObjectCamera('levels', 'other')
	setProperty('levels.alpha', 0)
end

function onCreatePost()
makeLuaSprite('PSYCH YOU SUCK', 'ab_cursor', 0, 0)
setProperty('PSYCH YOU SUCK.antialiasing', false)
scaleObject('PSYCH YOU SUCK', 1, 1)
addLuaSprite('PSYCH YOU SUCK', true)
setObjectCamera('PSYCH YOU SUCK', 'other')
setProperty('PSYCH YOU SUCK.alpha', 0)

makeLuaSprite('titlescreenBoot', 'breitbart/titleScreen/boot splash screen', 0, 0)
addLuaSprite('titlescreenBoot', true)
scaleObject('titlescreenBoot', 1.2, 1.2)
setObjectCamera('titlescreenBoot', 'other')
screenCenter('titlescreenBoot')
--setProperty('titlescreenBoot.alpha', 0)

makeLuaSprite('titlescreenMain', 'breitbart/titleScreen/titlescreen_back', 0, 0)
addLuaSprite('titlescreenMain', true)
setObjectCamera('titlescreenMain', 'other')
setProperty('titlescreenMain.alpha', 0)

makeLuaSprite('titlescreenStart', 'breitbart/titleScreen/pressstart1', 0, 0)
addLuaSprite('titlescreenStart', true)
setObjectCamera('titlescreenStart', 'other')
setProperty('titlescreenStart.alpha', 0)

makeLuaSprite('titlescreenStart2', 'breitbart/titleScreen/pressstart2', 0, 0)
addLuaSprite('titlescreenStart2', true)
setObjectCamera('titlescreenStart2', 'other')
setProperty('titlescreenStart2.alpha', 0)

setPropertyFromClass('openfl.Lib', 'application.window.opacity', 0)
end

function spawnCharacter()
--[[
makeLuaSprite('bgTemp', 'breitbart/gameplaySprites/rapzoneA01/RAPZONEA01 stage bg', 0, -250)
setProperty('bgTemp.antialiasing', false)
scaleObject('bgTemp', 0.75, 0.75)
addLuaSprite('bgTemp', true)
setObjectCamera('bgTemp', 'other')
--setProperty('bgTemp.alpha', 0)
]]

createInstance('bgTemp', 'flixel.addons.display.FlxBackdrop', {nil,0x01}) 
loadGraphic('bgTemp', 'breitbart/gameplaySprites/rapzoneA01/RAPZONEA01 stage bg')
addInstance('bgTemp', true)
setProperty('bgTemp.antialiasing', false)
setProperty('bgTemp.y', -250)
scaleObject('bgTemp', 0.75, 0.75)
--updateHitbox('bgTemp')
setObjectCamera('bgTemp', 'other')
--setObjectOrder("bgTemp", 999)

-- BREITBART SPRITES
makeLuaSprite('sonicMoving', 'breitbart/gameplaySprites/sonic/individual frames/walkframe1', 508, 208)
setProperty('sonicMoving.antialiasing', false)
scaleObject('sonicMoving', 0.75, 0.75)
addLuaSprite('sonicMoving', true)
setObjectCamera('sonicMoving', 'other')
setProperty('sonicMoving.flipX', true)

makeLuaSprite('sonicMovingWalk', 'breitbart/gameplaySprites/sonic/individual frames/walkframe1', 508, 208)
setProperty('sonicMovingWalk.antialiasing', false)
scaleObject('sonicMovingWalk', 0.75, 0.75)
addLuaSprite('sonicMovingWalk', true)
setObjectCamera('sonicMovingWalk', 'other')
setProperty('sonicMovingWalk.flipX', true)
setProperty('sonicMovingWalk.visible', false)

makeLuaSprite('sonicMoving2', 'breitbart/gameplaySprites/sonic/individual frames/walkframe2', 508, 208)
setProperty('sonicMoving2.antialiasing', false)
scaleObject('sonicMoving2', 0.75, 0.75)
addLuaSprite('sonicMoving2', true)
setObjectCamera('sonicMoving2', 'other')
setProperty('sonicMoving2.flipX', true)
setProperty('sonicMoving2.visible', false)

makeLuaSprite('sonicMoving3', 'breitbart/gameplaySprites/sonic/individual frames/walkframe3 (unused)', 508, 208)
setProperty('sonicMoving3.antialiasing', false)
scaleObject('sonicMoving3', 0.75, 0.75)
addLuaSprite('sonicMoving3', true)
setObjectCamera('sonicMoving3', 'other')
setProperty('sonicMoving3.flipX', true)
setProperty('sonicMoving3.visible', false)
-- screenCenter('sonicMoving')
-- debugPrint("Y: "..getProperty('sonicMoving.y'))
-- debugPrint("X: "..getProperty('sonicMoving.x'))
--setProperty('sonicMoving.alpha', 0)
doTweenY('startDown', 'sonicMoving', 368, 1, 'sineIn')

makeLuaSprite('sonicBall', 'breitbart/gameplaySprites/sonic/individual frames/jump/jumpball1', 508, 208)
setProperty('sonicBall.antialiasing', false)
scaleObject('sonicBall', 0.75, 0.75)
addLuaSprite('sonicBall', true)
setObjectCamera('sonicBall', 'other')
-- setProperty('sonicBall.flipX', true)

makeLuaSprite('sonicBall2', 'breitbart/gameplaySprites/sonic/individual frames/jump/jumpball2', 508, 208)
setProperty('sonicBall2.antialiasing', false)
scaleObject('sonicBall2', 0.75, 0.75)
addLuaSprite('sonicBall2', true)
setObjectCamera('sonicBall2', 'other')
-- setProperty('sonicBall.flipX', true)
-- BREITBART SPRITES

makeLuaSprite('ringCollect', 'breitbart/gameplaySprites/ring/spin1', walkingDist, 450)
setProperty('ringCollect.antialiasing', false)
scaleObject('ringCollect', 5, 5)
addLuaSprite('ringCollect', true)
setObjectCamera('ringCollect', 'other')
--setProperty('ringCollect.alpha', 0)

for _,counts in ipairs(ringChecks) do
walkingDist = walkingDist+350
makeLuaSprite('ringCollect'..counts, 'breitbart/gameplaySprites/ring/spin1', walkingDist, 450)
setProperty('ringCollect'..counts..'.antialiasing', false)
scaleObject('ringCollect'..counts, 5, 5)
addLuaSprite('ringCollect'..counts, true)
setObjectCamera('ringCollect'..counts, 'other')
--setProperty('ringCollect.alpha', 0)
end

makeLuaSprite('ringCollectFinal', 'breitbart/gameplaySprites/ring/spin1', walkingDist+500, 150) -- HOW
setProperty('ringCollectFinal.antialiasing', false)
scaleObject('ringCollectFinal', 18, 18)
addLuaSprite('ringCollectFinal', true)
setObjectCamera('ringCollectFinal', 'other')
--setProperty('ringCollect.alpha', 0)

makeLuaSprite('black1', 'black1', getProperty('ringCollect.x'), getProperty('ringCollect.y'));
makeGraphic('black1', 1, 16, 'FF0000')
addLuaSprite('black1', true);
scaleObject('black1', 5, 5)
setObjectCamera('black1', 'other');

--[[
makeLuaSprite('tileTemp', 'breitbart/gameplaySprites/rapzoneA01/RAPZONEA01 ground tile', 0, 625)
setProperty('tileTemp.antialiasing', false)
scaleObject('tileTemp', 5, 0.5)
addLuaSprite('tileTemp', true)
setObjectCamera('tileTemp', 'other')
--setProperty('tileTemp.alpha', 0)
]]

createInstance('tileTemp', 'flixel.addons.display.FlxBackdrop', {nil,0x01}) 
loadGraphic('tileTemp', 'breitbart/gameplaySprites/rapzoneA01/RAPZONEA01 ground tile')
addInstance('tileTemp', true)
setProperty('tileTemp.antialiasing', false)
setProperty('tileTemp.y', 625)
scaleObject('tileTemp', 0.5, 0.5)
--updateHitbox('tileTemp')
setObjectCamera('tileTemp', 'other')

makeLuaSprite('ringCollectHUD', 'breitbart/gameplaySprites/ring/spin1', 15, 15)
setProperty('ringCollectHUD.antialiasing', false)
scaleObject('ringCollectHUD', 6, 6)
addLuaSprite('ringCollectHUD', true)
setObjectCamera('ringCollectHUD', 'other')
--setProperty('ringCollectHUD.alpha', 0)

makeLuaText('points', "x", 0, 120, 30);
setTextSize('points', 75);
addLuaText('points');
setProperty('points.borderSize', 0)
setTextFont('points', 'vcrog.ttf')
setObjectCamera('points', 'camOther');
--setProperty('points.visible', false)

makeLuaText('pointsTime', "TIME", 0, 25, 125);
setTextSize('pointsTime', 70);
addLuaText('pointsTime');
setProperty('pointsTime.borderSize', 0)
setTextFont('pointsTime', 'vcrog.ttf')
setObjectCamera('pointsTime', 'camOther');
--setProperty('pointsTime.visible', false)

makeLuaText('pointsTimeTxt', "0:00", 0, 230, 125);
setTextSize('pointsTimeTxt', 70);
addLuaText('pointsTimeTxt');
setProperty('pointsTimeTxt.borderSize', 0)
setTextFont('pointsTimeTxt', 'vcrog.ttf')
setObjectCamera('pointsTimeTxt', 'camOther');
--setProperty('pointsTimeTxt.visible', false)

--[[
makeLuaText('pointsDebug', "0:00", 0, 230, 200);
setTextSize('pointsDebug', 70);
addLuaText('pointsDebug');
setProperty('pointsDebug.borderSize', 0)
setTextFont('pointsDebug', 'vcrog.ttf')
setObjectCamera('pointsDebug', 'camOther');
--setProperty('pointsDebug.visible', false)
]]

makeLuaText('pointsDebugFinal', "BIG RING CHECKED!!!!", 0, 230, 500);
setTextSize('pointsDebugFinal', 50);
addLuaText('pointsDebugFinal');
setProperty('pointsDebugFinal.borderSize', 0)
setTextFont('pointsDebugFinal', 'vcrog.ttf')
setObjectCamera('pointsDebugFinal', 'camOther');
setProperty('pointsDebugFinal.alpha', 0)
--setProperty('pointsDebugFinal.visible', false)

makeLuaSprite('lifeHUD', 'breitbart/gameplaySprites/sonic/lifeIcon', 15, 615)
--setProperty('lifeHUD.antialiasing', false)
scaleObject('lifeHUD', 1, 1)
addLuaSprite('lifeHUD', true)
setObjectCamera('lifeHUD', 'other')
--setProperty('lifeHUD.alpha', 0)

makeLuaText('pointsLife', "x5", 0, 150, 625);
setTextSize('pointsLife', 80);
addLuaText('pointsLife');
setProperty('pointsLife.borderSize', 0)
setTextFont('pointsLife', 'vcrog.ttf')
setObjectCamera('pointsLife', 'camOther');
--setProperty('pointsLife.visible', false)

makeLuaSprite('walkingPos', nil)
setProperty('walkingPos.x', 508)

setProperty('sonicMoving.visible', false)
setProperty('sonicMovingWalk.visible', false)
end

-- necessary if you want the normal mouse to show up in things like the chart editor
function onDestroy()
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	runHaxeCode('FlxG.mouse.unload();')
end

function onPause()
	if canOpenCustomPause then
	openCustomSubstate('pauseState', true);
	end
	-- thisShit = {'Overlay1', 'Overlay2', 'Resume', '', '', '', ''}
	setProperty('pauseMenuOverlay1.alpha', 1)
	setProperty('pauseMenuOverlay2.alpha', 1)
	setProperty('pauseMenuResume.alpha', 1)
	setProperty('pauseMenuRetry.alpha', 1)
	setProperty('pauseMenuExit.alpha', 1)
	setProperty('pauseMenuMute.alpha', 1)
	setProperty('pauseMenuHelp.alpha', 1)
	setProperty('levels.alpha', 1)
	pauseMenuActive = true
	pauseSelection = 1
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
	setProperty('PSYCH YOU SUCK.alpha', 1)
	return Function_Stop;
end

function onUpdate()
	if isMuted == true then
	setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
	runHaxeCode([[
	game.vocals.volume = 0;
	game.opponentVocals.volume = 0;
	]])
	else
		if doubleCheckIfItDoesntSoundLikeOST == true then
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 1)
		runHaxeCode([[
		game.vocals.volume = 1;
		game.opponentVocals.volume = 1;
		]])
		doubleCheckIfItDoesntSoundLikeOST = false
		end
	end
	
	if pressedAnyButtons == true then
		if keyJustPressed('accept') then
		runTimer('flashingb', 0.05, 999)
		runTimer('startGame', 2)
		runTimer('runSonic', runningSpeed, 9999)
		pressedAnyButtons = false
		end
	end
	
	-- Just the debugging for myself, Herox.
	
	setTextString("points", "x"..ringCount)
	setTextString("pointsDebug", getProperty('walkingPos.x'))
	setProperty('sonicMovingWalk.x', getProperty('sonicMoving.x'))
	setProperty('sonicMoving2.x', getProperty('sonicMoving.x'))
	setProperty('sonicMoving3.x', getProperty('sonicMoving.x'))
	setProperty('sonicBall.x', getProperty('sonicMoving.x'))
	setProperty('sonicBall2.x', getProperty('sonicMoving.x'))
	setProperty('sonicMovingWalk.y', getProperty('sonicMoving.y'))
	setProperty('sonicMoving2.y', getProperty('sonicMoving.y'))
	setProperty('sonicMoving3.y', getProperty('sonicMoving.y'))
	setProperty('sonicBall.y', getProperty('sonicMoving.y'))
	setProperty('sonicBall2.y', getProperty('sonicMoving.y'))
	setProperty('sonicMovingWalk.flipX', getProperty('sonicMoving.flipX'))
	setProperty('sonicMoving2.flipX', getProperty('sonicMoving.flipX'))
	setProperty('sonicMoving3.flipX', getProperty('sonicMoving.flipX'))
	setProperty('sonicBall.flipX', getProperty('sonicMoving.flipX'))
	setProperty('sonicBall2.flipX', getProperty('sonicMoving.flipX'))
	
	if tenSecondPassed == true then
	setTextString('pointsTimeTxt', minuteNum..":"..secondNum)
	else
	setTextString('pointsTimeTxt', minuteNum..":0"..secondNum)
	end
	
	if canMoveSonic == true then
		if keyboardPressed('LEFT') then
		setProperty('sonicMoving.flipX', false)
		setProperty('sonicMoving.x', getProperty('sonicMoving.x')-5)
		setProperty('walkingPos.x', getProperty('walkingPos.x')-1)
			if getProperty('walkingPos.x') >= 1 then
			setProperty('tileTemp.x', getProperty('tileTemp.x')+5)
			setProperty('bgTemp.x', getProperty('bgTemp.x')+4)
			elseif getProperty('walkingPos.x') <= 0 then
			setProperty('walkingPos.x', 0)
			end
			
			if getProperty('walkingPos.x') >= 700 then
			setProperty('ringCollect.x', getProperty('ringCollect.x')+5)
			setProperty('ringCollectFinal.x', getProperty('ringCollectFinal.x')+5)
				for i = 2,32 do
				setProperty('ringCollect'..i..'.x', getProperty('ringCollect'..i..'.x')+5)
				end
			end
			--end
		isOnIdle = false
		if startGameFix then
			if isJumped == false then
			setProperty('sonicMovingWalk.visible', true)
			setProperty('sonicMoving2.visible', true)
			setProperty('sonicMoving3.visible', true)
			setProperty('sonicMoving.visible', false)
			end
		end
		
		elseif keyboardPressed('RIGHT') then
		setProperty('sonicMoving.flipX', true)
		setProperty('sonicMoving.x', getProperty('sonicMoving.x')+5)
		setProperty('walkingPos.x', getProperty('walkingPos.x')+1)
		setProperty('tileTemp.x', getProperty('tileTemp.x')-5)
		setProperty('bgTemp.x', getProperty('bgTemp.x')-4)
			if getProperty('walkingPos.x') >= 700 then
			setProperty('ringCollect.x', getProperty('ringCollect.x')-5)
			setProperty('ringCollectFinal.x', getProperty('ringCollectFinal.x')-5)
				for i = 2,32 do
				setProperty('ringCollect'..i..'.x', getProperty('ringCollect'..i..'.x')-5)
				end
			end
		isOnIdle = false
		if startGameFix then
			if isJumped == false then
			setProperty('sonicMovingWalk.visible', true)
			setProperty('sonicMoving2.visible', true)
			setProperty('sonicMoving3.visible', true)
			setProperty('sonicMoving.visible', false)
			end
		end
		
		elseif keyboardReleased('LEFT') or keyboardReleased('RIGHT') then
			if isJumped == false then
			isOnIdle = true
			end
		end
		
		if keyboardJustPressed('SPACE') then
			if isJumped == false then -- checks if breitbart jumped
			doTweenY('startUp', 'sonicMoving', 268, 0.5, 'sineOut')
			setProperty('sonicMoving2.visible', false)
			setProperty('sonicMovingWalk.visible', false)
			setProperty('sonicMoving3.visible', false)
			setProperty('sonicMoving.visible', false)
			setProperty('sonicBall.visible', true)
			setProperty('sonicBall2.visible', true)
			jumpCheck = 'up'
			isJumped = true
			isOnIdle = false
			end
		end
	
	if startGameFix then
		if isOnIdle == true then
		setProperty('sonicMoving2.visible', false)
		setProperty('sonicMovingWalk.visible', false)
		setProperty('sonicMoving3.visible', false)
		setProperty('sonicMoving.visible', true)
		else
		setProperty('sonicMoving.visible', false)
		end
	end
		
	if getProperty('walkingPos.x') >= 700 then
		if getProperty('sonicMoving.x') >= getProperty('ringCollect.x')-250 then
		setProperty('ringCollect.alpha', 0)
			if ringCountCheck == false then
			ringCount = ringCount+1
			playSound('ring', 0.75)
			ringCountCheck = true
			end
		end
	
	-- I'm so sorry, I can't even get it right.
		for i = 2, 32 do
			if getProperty('sonicMoving.x') >= getProperty('ringCollect'..i..'.x')-250 then
			setProperty('ringCollect'..i..'.alpha', 0)
				if ringCountCheckNum == i then
				ringCount = ringCount+1
				ringCountCheckNum = ringCountCheckNum+1
				playSound('ring', 0.75)
				end
			end
		end
		
		if getProperty('sonicMoving.x') >= getProperty('ringCollectFinal.x') then
		--setProperty('pointsDebugFinal.alpha', 1)
		soundFadeIn('zoneTag', 0.0001, 1, 0)
		playSound('funksterGAME/scream', 0.75)
		canMoveSonic = false
		setProperty('sonicMovingWalk.visible', false)
		setProperty('sonicMoving2.visible', false)
		setProperty('sonicMoving3.visible', false)
		setProperty('sonicMoving.visible', false)
		setProperty('ringCollect.visible', false)
		setProperty('tileTemp.visible', false)
		setProperty('bgTemp.visible', false)
		setProperty('sonicBall.visible', false)
		setProperty('sonicBall2.visible', false)
		setProperty('points.visible', false)
		setProperty('pointsTime.visible', false)
		setProperty('pointsTimeTxt.visible', false)
		setProperty('pointsLife.visible', false)
		setProperty('lifeHUD.visible', false)
		setProperty('ringCollectHUD.visible', false)
		setProperty('ringCollectFinal.visible', false)
		makeLuaSprite('black', '', 0, 0)
		makeGraphic('black', screenWidth, screenHeight, '000000')
		setObjectCamera('black', 'other')
		addLuaSprite('black', true)
		runTimer('eh', 4)
			for i = 2, 32 do
			setProperty('ringCollect'..i..'.visible', false)
			end
		end
	end
	
		if getProperty('sonicMoving.x') <= 0 then
		setProperty('sonicMoving.x', 0)
		setProperty('walkingPos.x', getProperty('walkingPos.x'))
		overZeroCheck = false
			if keyboardPressed('LEFT') then
			cancelTween('startUp')
			cancelTween('startDowns')
			end
			
			if keyboardReleased('LEFT') then
			doTweenY('startDowns', 'sonicMoving', 368, 0.5, 'sineIn')
			end
			
		elseif getProperty('sonicMoving.x') >= 0 then
			if overZeroCheck == false then
			doTweenY('startDowns', 'sonicMoving', 368, 0.5, 'sineIn')
			overZeroCheck = true
			end
		end
		if getProperty('sonicMoving.x') >= 508 then
		setProperty('sonicMoving.x', 508)
		
		elseif getProperty('walkingPos.x') >= 100 then
		setProperty('sonicMoving.x', 508)
		end
	end
end

function onTweenCompleted(tag)
	if tag == 'startUp' then
	doTweenY('startDowns', 'sonicMoving', 368, 0.5, 'sineIn')
	jumpCheck = 'down'
	end
	
	if tag == 'startDowns' then
	isJumped = false
	isOnIdle = true
	setProperty('sonicBall.visible', false)
	setProperty('sonicBall2.visible', false)
	end
	
	if tag == 'startDown' then
	isJumped = false
	isOnIdle = true
	setProperty('sonicBall.visible', false)
	setProperty('sonicBall2.visible', false)
	startGameFix = true
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'flashingb' then
		if loopsLeft % 2 == 0 then
		setProperty('titlescreenStart2.alpha', 0)
		else
		setProperty('titlescreenStart2.alpha', 1)
		end
	end
	
	if tag == 'runSonic' then
		if loopsLeft % 3 == 0 then
		setProperty('sonicMovingWalk.alpha', 1)
		setProperty('sonicMoving2.alpha', 0)
		setProperty('sonicMoving3.alpha', 0)
		
		elseif loopsLeft % 2 == 0 then
		setProperty('sonicMovingWalk.alpha', 0)
		setProperty('sonicMoving2.alpha', 1)
		setProperty('sonicMoving3.alpha', 0)
		setProperty('sonicBall.alpha', 1)
		setProperty('sonicBall2.alpha', 0)
		else
		setProperty('sonicMovingWalk.alpha', 0)
		setProperty('sonicMoving2.alpha', 0)
		setProperty('sonicMoving3.alpha', 1)
		setProperty('sonicBall.alpha', 0)
		setProperty('sonicBall2.alpha', 1)
		end
	end
	
	if tag == 'opacity here' then
	setPropertyFromClass('openfl.Lib', 'application.window.opacity', 1)
	end
	
	if tag == 'open game' then
	setProperty('titlescreenBoot.alpha', 0)
	setProperty('titlescreenMain.alpha', 1)
	setProperty('titlescreenStart.alpha', 1)
	playSound('funksterGAME/title', 1, 'titleTag')
	pressedAnyButtons = true
	end
	
	if tag == 'startGame' then
	cancelTimer('flashingb')
	setProperty('titlescreenStart.alpha', 0)
	setProperty('titlescreenStart2.alpha', 1)
	soundFadeIn('titleTag', 0.0001, 1, 0)
	runTimer('startedGame', 1.5)
	end
	
	if tag == 'startedGame' then
	setProperty('titlescreenMain.alpha', 0)
	setProperty('titlescreenStart.visible', false)
	setProperty('titlescreenStart2.visible', false)
	spawnCharacter()
	canMoveSonic = true
	isOnIdle = true
	runTimer('minute', 60)
	runTimer('second', 1)
	playSound('funksterGAME/zone', 1, 'zoneTag')
	end
	
	if tag == 'minute' then
	minuteNum = minuteNum+1
	runTimer('minute', 60)
	
	elseif tag == 'second' then
	secondNum = secondNum+1
	runTimer('second', 1)
	
	if secondNum == 10 and tenSecondPassed == false then
	tenSecondPassed = true
	end
	
		if secondNum == 60 then
		tenSecondPassed = false
		secondNum = 0
		end
	end
	
	if tag == 'eh' then
	playSound('funksterGAME/breitbartStarting', 1)
	runTimer('ehh', 0.6)
	end
	
	if tag == 'ehh' then
	playSound('funksterGAME/breitbartStarting', 1)
	runTimer('ehhh', 0.6)
	end
	
	if tag == 'ehhh' then
	playSound('funksterGAME/breitbartStarting', 1)
	runTimer('start song', 0.5)
	end
	
	if tag == 'start song' then
	startCountdown()
	canOpenCustomPause = true
	end
	
	if tag == 'resume' then
	restartSong()
	end
	
	if tag == 'aint' then
	helpEnter = true
	
	elseif tag == 'aint v2' then
	pauseMenuActive = true
	end
end

function onCustomSubstateUpdatePost(name)
    if name == 'pauseState' then
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Q') then
		restartSong()
		end
	
	if pauseMenuActive == true then
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
			pauseSelection = pauseSelection-1
			end
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DOWN') then
			pauseSelection = pauseSelection+1
			end
		
			if pauseSelection > 5 then
				pauseSelection = 1
			end
			if pauseSelection < 1 then
				pauseSelection = 5
			end

		if pauseSelection == 1 then
		doTweenX('cursorX', 'PSYCH YOU SUCK', 50, 0.5, 'quartOut')
		doTweenY('cursorY', 'PSYCH YOU SUCK', 50, 0.5, 'quartOut')
		end

		if pauseSelection == 2 then
		doTweenX('cursorX', 'PSYCH YOU SUCK', 190, 0.5, 'quartOut')
		doTweenY('cursorY', 'PSYCH YOU SUCK', 275, 0.5, 'quartOut')
		end
		
		if pauseSelection == 3 then
		doTweenX('cursorX', 'PSYCH YOU SUCK', 190, 0.5, 'quartOut')
		doTweenY('cursorY', 'PSYCH YOU SUCK', 450, 0.5, 'quartOut')
		end
		
		if pauseSelection == 4 then
		doTweenX('cursorX', 'PSYCH YOU SUCK', 125, 0.5, 'quartOut')
		doTweenY('cursorY', 'PSYCH YOU SUCK', 635, 0.5, 'quartOut')
		end
		
		if pauseSelection == 5 then
		doTweenX('cursorX', 'PSYCH YOU SUCK', 225, 0.5, 'quartOut')
		doTweenY('cursorY', 'PSYCH YOU SUCK', 635, 0.5, 'quartOut')
		end

		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and pauseSelection == 1 then
		closeCustomSubstate();
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);
		setProperty('pauseMenuOverlay1.alpha', 0)
		setProperty('pauseMenuOverlay2.alpha', 0)
		setProperty('pauseMenuResume.alpha', 0)
		setProperty('pauseMenuRetry.alpha', 0)
		setProperty('pauseMenuExit.alpha', 0)
		setProperty('pauseMenuMute.alpha', 0)
		setProperty('pauseMenuHelp.alpha', 0)
		setProperty('levels.alpha', 0)
		setProperty('PSYCH YOU SUCK.alpha', 0)
		end
		
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and pauseSelection == 2 then
		restartSong()
		end
		
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and pauseSelection == 3 then
		exitSong()
		end
		
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and pauseSelection == 4 then
			if isMuted == false then
			objectPlayAnimation('pauseMenuMute', 'button_muted')
			isMuted = true
			doubleCheckIfItDoesntSoundLikeOST = true
			else
			objectPlayAnimation('pauseMenuMute', 'button_mute')
			isMuted = false
			end
		end
		
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and pauseSelection == 5 then
			setProperty('pauseMenuPrompt.alpha', 1)
			setProperty('pauseMenuCheckmark.alpha', 1)
			setProperty('pauseMenuOverlay2.alpha', 0)
			setProperty('pauseMenuResume.alpha', 0)
			setProperty('pauseMenuRetry.alpha', 0)
			setProperty('pauseMenuExit.alpha', 0)
			setProperty('pauseMenuMute.alpha', 0)
			setProperty('pauseMenuHelp.alpha', 0)
			setProperty('levels.alpha', 0)
			doTweenX('cursorX', 'PSYCH YOU SUCK', 840, 0.5, 'quartOut')
			doTweenY('cursorY', 'PSYCH YOU SUCK', 550, 0.5, 'quartOut')
	
			pauseMenuActive = false
			runTimer('aint', 0.0001)
			end
		end
		
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and helpEnter == true then
		helpEnter = false
		runTimer('aint v2', 0.0001)
		setProperty('pauseMenuPrompt.alpha', 0)
		setProperty('pauseMenuCheckmark.alpha', 0)
		setProperty('pauseMenuOverlay2.alpha', 1)
		setProperty('pauseMenuResume.alpha', 1)
		setProperty('pauseMenuRetry.alpha', 1)
		setProperty('pauseMenuExit.alpha', 1)
		setProperty('pauseMenuMute.alpha', 1)
		setProperty('pauseMenuHelp.alpha', 1)
		setProperty('levels.alpha', 1)
		end
	end
end