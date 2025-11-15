-- I DO THE EVENTS NOW!!! /j (- Herox/Arie Temps)

defaultCamZoom = getProperty('defaultCamZoom')
gameBeatZoom = false
danceTheHUD = false
disableCamZoom = false

switchDirectionHUD = 1

cinematicLevel = 6 -- 2 to 6, so to quickly explain: 2 to 4 or 5, 5 to 6.
-- 6 ends here which is no cinematic.
cinematicDuration = 0.5

function inCinematic()
doTweenY('wanna close in?', 'blackBars1', -120*cinematicLevel-20, cinematicDuration, 'sineOut')
doTweenY('wanna close in too?', 'blackBars2', 120*cinematicLevel+20, cinematicDuration, 'sineOut')
end

function onCreatePost()
setProperty('camHUD.alpha', 0)

makeLuaSprite('movementTween', 'fuck you movecam.lua?', 770, 705); -- opponent: 770, duet: 870, player: 970
-- uh oh, the camera is now locked in place, now it can't move based on movement hits anymore.
-- hmmm I got an idea though...
	
makeLuaSprite('blackBars1', 'weah', 0, 0);
makeGraphic('blackBars1', 1440, 720, '000000')
addLuaSprite('blackBars1', false);
setObjectCamera('blackBars1', 'camHUD');
setProperty('blackBars1.y', -120*cinematicLevel-20)

makeLuaSprite('blackBars2', 'weah', 0, 0);
makeGraphic('blackBars2', 1440, 720, '000000')
addLuaSprite('blackBars2', false);
setObjectCamera('blackBars2', 'camHUD');
setProperty('blackBars2.y', 120*cinematicLevel+20)
end

function onSongStart()
doTweenAlpha('the camera of the hud', 'camHUD', 1, 10, 'linear')
end

function onUpdate()
triggerEvent('Camera Follow Pos', getProperty('movementTween.x'), getProperty('movementTween.y'))
setProperty('cameraSpeed', 999)

	if disableCamZoom == true then
	setProperty('camZooming', false)
	else
	setProperty('camZooming', true)
	end
	
	if getProperty('dad.animation.curAnim.name') == 'singLEFT' or getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
	doTweenX("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	
	elseif getProperty('dad.animation.curAnim.name') == 'singDOWN' or getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
	doTweenY("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	
	elseif getProperty('dad.animation.curAnim.name') == 'singUP' or getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
	doTweenY("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	
	elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT' or getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
	doTweenX("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	
	else
	doTweenX("move the tween2", 'camGame', 0, 0.5, 'cubeOut')
	end
	
end

function danceHUD()
	if switchDirectionHUD == 1 then
	cancelTween('bopping')
	cancelTween('bopping2')
	setProperty('camHUD.x', 0)
	setProperty('camGame.angle', -1)
	doTweenX("bopping", 'camHUD', -25, 0.75, 'cubeOut')
	doTweenAngle("bopping2", 'camGame', 0, 0.5, 'cubeOut')
	switchDirectionHUD = switchDirectionHUD+1
	elseif switchDirectionHUD == 2 then
	cancelTween('bopping')
	cancelTween('bopping2')
	setProperty('camHUD.x', 0)
	setProperty('camGame.angle', 1)
	doTweenX("bopping", 'camHUD', 25, 0.75, 'cubeOut')
	doTweenAngle("bopping2", 'camGame', 0, 0.5, 'cubeOut')
	switchDirectionHUD = switchDirectionHUD+1
	else
	switchDirectionHUD = 0
	switchDirectionHUD = switchDirectionHUD+1
	danceHUD()
	end
end

--[[
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if direction == 0 then
	doTweenX("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	elseif direction == 1 then
	doTweenY("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	elseif direction == 2 then
	doTweenY("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	elseif direction == 3 then
	doTweenX("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if direction == 0 then
	doTweenX("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	elseif direction == 1 then
	doTweenY("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	elseif direction == 2 then
	doTweenY("move the tween2", 'camGame', 10, 0.5, 'cubeOut')
	elseif direction == 3 then
	doTweenX("move the tween2", 'camGame', -10, 0.5, 'cubeOut')
	end
end
]]


function onBeatHit()
	if curBeat >= 352 and curBeat <= 379 then
		if curBeat %2 == 1 then
		setProperty('camGame.zoom', defaultCamZoom+0.05)
		setProperty('camHUD.zoom', 1.05)
		end
	end


	if gameBeatZoom == true then
	--triggerEvent('Add Camera Zoom') -- that's the only second plan for this, because the moment I do camGame.zoom, it just doesn't work, which is weird. In fact, it did work on my other mods but not this. (- Herox/Arie Temps)
	-- Update after this: I just figured it out why it doesn't work, it was RalZoom.lua >:[ (- Herox/Arie Temps)
	
	setProperty('camGame.zoom', defaultCamZoom+0.05)
		if danceTheHUD == true then
		danceHUD()
		end
	end
end

function onSectionHit()
	if mustHitSection == true then
	doTweenX("move the tween", 'movementTween', 970, 0.75, 'cubeOut')
	else
	doTweenX("move the tween", 'movementTween', 770, 0.75, 'cubeOut')
	end
	
	if curSection == 83 then
	doTweenX("move the tween", 'movementTween', 870, 0.75, 'cubeOut')
	end
	
	if curSection == 8 or curSection == 16 or curSection == 64 then
	gameBeatZoom = true
	setProperty('camHUD.zoom', 1)
	elseif curSection == 15 or curSection == 79 then
	gameBeatZoom = false
	end
	
	if curSection == 16 or curSection == 64 then
	danceTheHUD = true
	disableCamZoom = false
	cameraFlash('camGame', 'FFFFFF', 0.5)
	setProperty('defaultCamZoom', 0.8)
	cancelTween('he zooms')
	cancelTween('rotate on a degree')
	setProperty('camGame.angle', 0)
	setProperty('camGame.zoom', 0.8)
	end
	
	if curSection == 31 or curSection == 63 then
	disableCamZoom = true
	danceTheHUD = false
	gameBeatZoom = false
	cancelTween('bopping')
	doTweenX("bopping", 'camHUD', 0, 0.75, 'sineInOut')
	doTweenZoom("he zooms", 'camGame', 1.2, 1.2, 'sineIn')
	doTweenAngle("rotate on a degree", 'camGame', 6, 1.2, 'sineIn')
	doTweenZoom("he zooms 2", 'camHUD', 1, 0.75, 'cubeOut')
	setProperty('defaultCamZoom', 1)
	end
	
	if curSection == 32 then
	cameraFlash('camGame', 'FFFFFF', 1.5)
	cancelTween('he zooms')
	cancelTween('rotate on a degree')
	setProperty('camGame.angle', 0)
	setProperty('camHUD.zoom', 1)
	setProperty('defaultCamZoom', 0.8)
	setProperty('camGame.zoom', 0.8)
	cinematicLevel = 5
	cinematicDuration = 1
	inCinematic()
	end
	
	if curSection == 48 then
	cinematicLevel = 6
	cinematicDuration = 0.5
	inCinematic()
	disableCamZoom = false
	gameBeatZoom = true
	end
	
	if curSection == 55 then
	gameBeatZoom = false
	doTweenX("move the tween", 'movementTween', 770, 0.75, 'cubeOut')
	setProperty('defaultCamZoom', 1)
	
	elseif curSection == 56 then
	setProperty('defaultCamZoom', 0.8)
	setProperty('camHUD.zoom', 1)
	gameBeatZoom = true
	end
	
	if curSection == 79 then
	gameBeatZoom = false
	cancelTween('bopping')
	doTweenX("bopping", 'camHUD', 0, 0.75, 'sineInOut')
	end
	
	if curSection == 86 then
	setProperty('defaultCamZoom', 0.9)
	elseif curSection == 87 then
	setProperty('defaultCamZoom', 1)
	elseif curSection == 88 then
	setProperty('defaultCamZoom', 0.8)
	end
	
	if curSection == 104 then
	doTweenAlpha("ending", 'camHUD', 0, 1, 'linear')
	setProperty('defaultCamZoom', 1)
	doTweenX("move the tween", 'movementTween', 1100, 0.75, 'cubeOut')
	doTweenY("move the tween2", 'movementTween', 725, 0.75, 'cubeOut')
	elseif curSection == 105 then
	setProperty('camGame.alpha', 0)
	end
end