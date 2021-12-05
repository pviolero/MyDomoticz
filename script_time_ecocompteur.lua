local url = 'http://192.168.1.110/inst.json'

commandArray={}

--import des fontions pour lire le JSON
json = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()

local config=assert(io.popen("curl '"..url.."'"))
local location = config:read('*all')
config:close()
local jsonLocation = json:decode(location)

local data1=jsonLocation.data1      -- piscine
local data2=jsonLocation.data2      -- general
local data3=jsonLocation.data3      -- solaire

print('Piscine = ' .. data1)
print('General = ' .. data2)
print('Solaire = ' .. data3)




commandArray[1]={['OpenURL']='192.168.1.73:8080/json.htm?type=command&param=udevice&idx=45&svalue=' .. data1/60}
commandArray[2]={['OpenURL']='192.168.1.73:8080/json.htm?type=command&param=udevice&idx=46&svalue=' .. data2/60}
commandArray[3]={['OpenURL']='192.168.1.73:8080/json.htm?type=command&param=udevice&idx=47&svalue=' .. data3/60}
commandArray[4]={['OpenURL']='192.168.1.73:8080/json.htm?type=command&param=udevice&idx=48&svalue=' .. data2}

return commandArray
 
