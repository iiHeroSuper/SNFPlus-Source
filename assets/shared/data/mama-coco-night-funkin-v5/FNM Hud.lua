--Friday Night Maker Hud BTG Take
--Coded all By BlixerTheGamebananer (Or BlixerTheGamer Only)
--Images Found By DaPastaGuy
--Smb Funk Mix Countdown (Used as the code for it) by MTFuture
--Custom Noteskin Script Thanks By vCherry.kAI.16!!

--Text Stuff
function onCreatePost()
--Quite Some Hud + No Note Splashes
setProperty('scoreTxt.visible', false)
setProperty('timeBar.visible', false)
setProperty('timeTxt.visible', false)
setProperty('timeBarBG.visible', false)
setProperty('botplayTxt.visible', false)
setProperty('grpNoteSplashes.visible', false)

setProperty('introSoundsSuffix', '-fnm')

--Bye Bey Stupid Combo Blocking My View
setProperty('showRating', false)
setProperty('showComboNum', false)
setProperty('showCombo', false)

--ScoreText
if downscroll then
makeLuaText("score", "Score:", 0, 847, 95)
else
makeLuaText("score", "Score:", 0, 847, 657)
end
setTextSize('score', 22);
setTextBorder('score',0)
setTextFont('score', "ariblk.ttf");
setTextAlignment('score', 'right')
addLuaText("score");
end

--Set String + no Splashes
function onUpdate()
--Score
setTextString("score", string.format('Score:%s', score))
end

--Return to Menu
function onGameOverStart()
exitSong()
end

function onGameOver()
exitSong()
end

