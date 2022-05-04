function onEvent(name)
	if name == 'Destiny Bond' then
		health = getProperty('health')
		
			function goodNoteHit(id, noteData, noteType, isSustainNote)
			if getProperty('health') >= 2 then
				setProperty('health', health- 2);
			end
			end
		else
			
		end
end