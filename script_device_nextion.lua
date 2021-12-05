commandArray = {}

function lst_value(sv)
   local lw = {}
   for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
   return lw
end


function sv_val(sv, idx)
   local lw = {}
   for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
   return lw[idx]
end

BtPortail=509
BtPortillon=510
BtPoisson=511

if (devicechanged['nextion']) then
   Bt =  tonumber(sv_val(otherdevices['nextion'],1))
   lv = lst_value(otherdevices['nextion'])

   print('NEXTION = ' .. otherdevices['nextion'])
   
   if (Bt == BtPortail) then
      print('Ouverture Portail')
      commandArray['Portail'] = 'On'
   elseif (Bt == BtPortillon) then
      print('Ouverture Portillon')
      -- commandArray['Portillon'] = 'On'
   elseif (Bt == BtPoisson) then
      print('Poisson')
      -- commandArray['Portillon'] = 'On'
   else
      print('AUTRE BOUTON')
   end
end

return commandArray
