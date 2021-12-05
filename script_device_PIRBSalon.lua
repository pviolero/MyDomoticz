
commandArray = {}

if (devicechanged['PIRBSalon']) then
	if (otherdevices['PIRBSalon'] == 'Off') then
		print('NEXTION Level 0')
		commandArray['NextionDim'] = 'Set Level 0'
	else
		print('NEXTION Level 80')
		commandArray['NextionDim'] = 'Set Level 30'
	end
end

return commandArray
