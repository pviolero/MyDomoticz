commandArray = {}

NextionIP = '192.168.1.105'
PicOn = 2
PicOff = 1

if (devicechanged['MoteurPiscine']) then

   ip_nextion="192.168.1.105"

   -- test presence nextion
   NextionHere = os.execute('ping -c1 -w1 ' .. ip_nextion)

   if NextionHere then
      mo=otherdevices['MoteurPiscine']

      if (mo == 'Off') then
	 cmd = ip_nextion .. '/control?cmd=NEXTION,home.piscine.picc=' .. PicOff
      else
	 cmd = ip_nextion .. '/control?cmd=NEXTION,home.piscine.picc=' .. PicOn
      end

      commandArray[1] = {['OpenURL']=cmd}
   end
end

return commandArray
