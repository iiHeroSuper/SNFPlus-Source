-- poor song

function onCreate()
createInstance('line', 'flixel.addons.display.FlxBackdrop', {nil,0x01})
makeGraphic('line', 50, 500, '000000')
setProperty('line.y', 485)
setObjectCamera('line', 'other');
addInstance('line', false)
setProperty('line.alpha', 0)

makeLuaText('sonicText', "''Thanks for playing the SRB2 Demo,", 0, 25, 500);
addLuaText('sonicText');
setTextFont('sonicText', 'sonic.ttf')
setTextSize('sonicText', 20, 20)
setTextAlignment('sonicText', 'left')
setObjectCamera('sonicText', 'camOther');
setProperty('sonicText.alpha', 0)
end

function onCreatePost()
setProperty('camGame.alpha', 0)
setProperty('camGame.y', 100)
setProperty('camGame.zoom', getProperty('defaultCamZoom')-0.1)

createInstance('whitescreen', 'flixel.addons.display.FlxBackdrop', {nil,0x11})
makeGraphic('whitescreen', 50, 50, 'FFFFFF')
setObjectCamera('whitescreen', 'camGame');
addInstance('whitescreen', true)
setBlendMode('whitescreen', "add")
setProperty('whitescreen.alpha', 0)
end

function onSongStart()
doTweenAlpha('welcome to srb', 'camGame', 1, 4, 'linear')
doTweenY('welcome to srb2', 'camGame', 0, 7, 'sineInOut')
doTweenZoom('welcome to srb3', 'camGame', getProperty('defaultCamZoom'), 7, 'sineInOut')
end

function onSectionHit()
	if curSection == 3 then
	doTweenAlpha('welcome to srb', 'camHUD', 0, 2, 'linear')
	elseif curSection == 8 then
	doTweenAlpha('welcome to srb', 'camHUD', 1, 0.5, 'linear')
	doTweenAlpha('welcome to srb2', 'sonicText', 0, 0.5, 'linear')
	doTweenY('thanks srb0', 'camGame', 0, 0.5, 'sineInOut')
	doTweenAlpha('thanks srb', 'line', 0, 0.5, 'linear')
	end
	
	if curSection == 4 then
	cancelTween('welcome to srb2')
	doTweenY('thanks srb0', 'camGame', -135, 0.5, 'sineInOut')
	doTweenAlpha('thanks srb', 'line', 1, 0.5, 'sineInOut')
	doTweenAlpha('thanks srb2', 'sonicText', 1, 0.5, 'sineInOut')
	end
	
	if curSection == 78 then
	doTweenAlpha('fade', 'P1314059', 0.5, 0.5, 'linear')
	doTweenAlpha('fade2', 'dad', 0.5, 0.5, 'linear')
	doTweenAlpha('fade3', 'gf', 0.5, 0.5, 'linear')
	
	elseif curSection == 80 then
	doTweenAlpha('fade', 'P1314059', 1, 0.5, 'linear')
	doTweenAlpha('fade2', 'dad', 1, 0.5, 'linear')
	doTweenAlpha('fade3', 'gf', 1, 0.5, 'linear')
	end
	
	if curSection == 112 then
	setProperty('whitescreen.alpha', 0.5)
	doTweenAlpha('flashlights', 'whitescreen', 0, 2, 'linear')
	end
	
	if curSection == 113 then
	doTweenAlpha('welcome to srb', 'camGame', 0, 5, 'linear')
	doTweenY('welcome to srb2', 'camHUD', -750, 5, 'sineInOut')
	end
end

function onEvent(tag, v1, v2)
	if tag == '' then
		if v1 == 'bop' then
		setProperty('camGame.y', 15)
		setProperty('camGame.zoom', getProperty('defaultCamZoom')+0.025)
		doTweenY('welcome to srb2', 'camGame', 0, 0.5, 'cubeOut')
		
			if curSection >= 48 and curSection <= 78 then
				if flashingLights then
				setProperty('whitescreen.alpha', 0.25)
				doTweenAlpha('flashlights', 'whitescreen', 0, 0.5, 'linear')
				end
			end
		end
		
		if v1 == 's' then
			if v2 == 'e' then
			setTextString('sonicText', "''Thanks for playing the SRB2 Demo, if you think the game has ended,")
			elseif v2 == 'l' then
			setTextString('sonicText', "''Thanks for playing the SRB2 Demo, if you think the game has ended,\nit didn't.")
			
			elseif v2 == 'w' then
			setTextString('sonicText', "''Thanks for playing the SRB2 Demo, if you think the game has ended,\nit didn't. We just started")
			
			elseif v2 == 'p' then
			setTextString('sonicText', "''Thanks for playing the SRB2 Demo, if you think the game has ended,\nit didn't. We just started, pussy.''")
			end
		end
	end
end