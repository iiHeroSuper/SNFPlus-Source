function onCreate()
makeLuaText('congrats', "Congrats, you found a", 1280, 725, 175);
setTextSize('congrats', 27);
setTextAlignment('congrats', 'right')
setTextWidth('congrats', '1280')
addLuaText('congrats');
setObjectCamera('congrats', 'camHUD');

makeLuaText('lily pick', "Gold Cube!", 1280, 725, 175);
setTextSize('lily pick', 27);
setTextAlignment('lily pick', 'right')
setTextWidth('lily pick', '1280')
setProperty('lily pick.color', getColorFromHex('FFB86A'))
addLuaText('lily pick');
setObjectCamera('lily pick', 'camHUD');

makeLuaText('lily pick2', "\n\n\n\nThis means you're playing one\nof Lily's favorite composed songs. Enjoy!", 1280, 725, 175);
setTextSize('lily pick2', 27);
setTextAlignment('lily pick2', 'right')
setTextWidth('lily pick2', '1280')
addLuaText('lily pick2');
setObjectCamera('lily pick2', 'camHUD');

makeAnimatedLuaSprite('lilyBlush', 'lilyBlushing', 1000+725, 205);
addAnimationByPrefix('lilyBlush', 'blushed by syn', 'blush', 24, true);
playAnim('lilyBlush', 'blushed by syn');
scaleObject('lilyBlush', 0.8, 0.8);
setObjectCamera('lilyBlush', 'camHUD');
addLuaSprite('lilyBlush', false);

--[[
makeLuaSprite('lilyIcon', 'credits/zescrew2', 1000+725, 180);
setObjectCamera('lilyIcon', 'camHUD')
addLuaSprite('lilyIcon', false);
]]
end

function onUpdate()
setProperty('congrats.x', getProperty('lily pick.x')-160)
end

function onSongStart()
doTweenX("no way wow it's not the credits itself!!", 'congrats', 0, 1, 'sineInOut')
doTweenX("no way wow it's not the credits itself 0!!", 'lily pick', 0, 1, 'sineInOut')
doTweenX("no way wow it's not the credits itself 1!!", 'lily pick2', 0, 1, 'sineInOut')
doTweenX("no way wow it's not the credits itself 2!!", 'lilyBlush', 1000, 1, 'sineInOut')
runTimer('bye goober', 6)
end

function onTimerCompleted(tag)
	if tag == 'bye goober' then
	doTweenX("no way wow it's not the credits itself!!", 'congrats', 725, 1, 'sineInOut')
	doTweenX("no way wow it's not the credits itself 0!!", 'lily pick', 725, 1, 'sineInOut')
	doTweenX("no way wow it's not the credits itself 1!!", 'lily pick2', 725, 1, 'sineInOut')
	doTweenX("no way wow it's not the credits itself 2!!", 'lilyBlush', 1725, 1, 'sineInOut')
	end
end