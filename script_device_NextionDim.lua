
commandArray = {}

curl = '/usr/bin/curl -m 5 '
NextionIP = '192.168.1.105'

if (devicechanged['NextionDim']) then
	newval=otherdevices_svalues['NextionDim']
	cmd = curl .. 'http://' .. NextionIP .. '/control?cmd=NEXTION,dim=' .. newval 
	os.execute(cmd)
end

return commandArray
