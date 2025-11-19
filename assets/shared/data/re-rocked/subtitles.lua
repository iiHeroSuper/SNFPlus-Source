function onCreate()
makeLuaSprite('blackLYRIC', 'blackLYRIC', -250, 0);
makeGraphic('blackLYRIC',1920, 100, '000000')
addLuaSprite('blackLYRIC', true);
setObjectCamera('blackLYRIC', 'camHUD');
setProperty('blackLYRIC.y', 50)
setProperty('blackLYRIC.alpha', 0)
end

function onCreatePost()
makeLuaText('subtitle', "", 1280, 0, 0)
setTextAlignment('subtitle', 'left')
setTextWidth('subtitle', 1280)
addLuaText('subtitle', true)
setTextSize('subtitle', 50)
setTextFont('subtitle', 'vcrog.ttf')
setTextBorder('subtitle', 0, '000000')
setObjectCamera('subtitle', "camHUD")
end

function onUpdate()
	setProperty('subtitle.y', getProperty('blackLYRIC.y')+15)
end

function onEvent(name, v1, v2)
	if name == '' then
		if v1 == 'subtitles' then
		setTextString('subtitle', string.upper(v2))
		setProperty('blackLYRIC.alpha', 1)
		
			if v2 == '' then
			setProperty('blackLYRIC.alpha', 0)
			end
		end
	end
end