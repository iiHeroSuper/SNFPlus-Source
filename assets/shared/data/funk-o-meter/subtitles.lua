function onCreatePost()
makeLuaSprite('goMF', 'funk-o-meter/go', 1200, -200)
addLuaSprite('goMF', false)
setProperty('goMF.alpha', 0)

makeLuaText('subtitle', "", screenWidth, 0, 500)
setTextWidth('subtitle', screenWidth)
addLuaText('subtitle', true)
setTextSize('subtitle', 50)
setTextFont('subtitle', 'NiseSegaSonic.ttf')
setTextBorder('subtitle', 2, '001CB0')
setObjectCamera('subtitle', "camHUD")
end

function onSectionHit()
	if curSection == 118 then
	setProperty('camZooming', false)
	setProperty('camGame.zoom', 1.5)
	doTweenZoom("vine boom", 'camGame', 0.5, 0.75, 'linear')
	triggerEvent('Camera Follow Pos', '500', '100')
	end
	
	if curSection == 119 then
	triggerEvent('Camera Follow Pos', nil, nil)
	end
end

function onEvent(name, v1, v2)
	if name == '' then
		if v1 == 'subtitle' then
		setTextString('subtitle', v2)
		setProperty('blackLYRIC.alpha', 1)
		end
		
		if v1 == 'go' then
		cancelTween('launch base')
		cancelTween('oh my god')
		setProperty('goMF.y', -200)
		setProperty('goMF.alpha', 0.5)
		doTweenY("launch base", 'goMF', -400, 0.75, 'cubeOut')
		doTweenAlpha("oh my god", 'goMF', 0, 0.75, 'linear')
		end
	end
	
	if name == 'Change Character' then
		if v1 == '1' then
			if v2 == 'cybers_hell' then
			cameraFlash('camGame', 'FFFF00', 0.25, true)
			end
		end
	end
end