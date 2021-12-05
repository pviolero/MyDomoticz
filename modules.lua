curl = '/usr/bin/curl ' -- ne pas oublier l'espace  la fin
json = assert(loadfile '/home/pi/domoticz/scripts/lua/JSON.lua')() -- for linux http://regex.info/blog/lua/json

domoticzIP = '127.0.0.1'
domoticzPORT = '8080'
domoticzURL = 'http://'..domoticzIP..':'..domoticzPORT

-- get group/scene idx
function groupIdx(device)
	local getallgroups = assert(io.popen(curl..'"'..domoticzURL..'/json.htm?type=scenes"'))
	local readallgroups = getallgroups:read('*all')
	getallgroups:close()
	alldecoded = json:decode(readallgroups)
	allgroups = alldecoded.result
	for n, group in pairs(allgroups) do
		if (group.Name == device) then
			return group.idx
		end	
	end
end

-- switch On a device and set level if dimmmable
function switchOn(device,level)
	if level ~= nil then
		os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchlight&idx='..otherdevices_idx[device]..'&switchcmd=Set%20Level&level='..level..'" &')
	else	
		os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchlight&idx='..otherdevices_idx[device]..'&switchcmd=On" &')
	end	
end

-- switch Off a device
function switchOff(device)
	os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchlight&idx='..otherdevices_idx[device]..'&switchcmd=Off" &')
end

-- Toggle a device
function switch(device)
	os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchlight&idx='..otherdevices_idx[device]..'&switchcmd=Toggle" &')
end

-- switch On a group or scene
function groupOn(device)
	os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchscene&idx='..groupIdx(device)..'&switchcmd=On" &')
end

-- switch Off a group
function groupOff(device)
	os.execute(curl..'"'..domoticzURL..'/json.htm?type=command&param=switchscene&idx='..groupIdx(device)..'&switchcmd=Off" &')
end
