-- chargement des modules
dofile('/home/pi/domoticz/scripts/lua/modules.lua')

commandArray = {}

-- si la porte s'ouvre la nuit, on allume la lampe
if devicechanged['PIRDevant'] == 'On' and tonumber(otherdevices_svalues['LumDevant']) < 50 then
   print('presence devant')
   switchOnFor('Lumiere Devant',120)
   
end
return commandArray 
