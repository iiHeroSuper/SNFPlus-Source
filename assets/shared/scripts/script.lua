function noteMiss(membersIndex, noteData, noteType, isSustainNote)
	if songName == 'mama coco night funkin v5' then
		if not isSustainNote then
		playSound('fnm/bad_disc', 1, 'fnm')
		end
	else
		local random = math.random (3)
		if random == 1 then
			playSound("missnote1", 0.4, "miss1") -- change the decimal number to change the volume
		elseif random == 2 then
			playSound("missnote2", 0.4, "miss2")
		elseif random == 3 then
			playSound("missnote3", 0.4, "miss3")
		end
	end
end