debugCPUControlled = true

firstControl = 'W'
secondControl = 'Q'
switchBotplayControl = true

heroxLegacyControl = false

function onUpdatePost()
	if debugCPUControlled == true then
	
		if heroxLegacyControl == false then
			if keyboardJustPressed(''..firstControl..'') and switchBotplayControl == true then
			setProperty('cpuControlled', true)
			playSound('ring', 1)
			switchBotplayControl = false
			elseif keyboardJustPressed(''..firstControl..'') and switchBotplayControl == false then
			setProperty('cpuControlled', false)
			switchBotplayControl = true
			end
		else
			if keyboardJustPressed(''..firstControl..'') then
			setProperty('cpuControlled', true)
			playSound('ring', 1)
			elseif keyboardJustPressed(''..secondControl..'') then
			setProperty('cpuControlled', false)
			end
		end
	end
end