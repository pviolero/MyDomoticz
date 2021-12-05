commandArray = {}

local dbPath      = "/home/pi/domoticz/domoticz.db"
local dev_TEau    = "TempEauPiscine"     -- device Temprature eau piscine
local val_TEau    = -1                   -- Temperature eau moyenne
local val_Conso   = -1

DebugMode = true
TempEauPiscine = -1 
TempHivernage = 12
DureeFiltrage = -1
TempExtPiscine = -1
TempGel = 0.5

-- -------------------------------
-- Bibliotheque de fonctions
-- -------------------------------
function round(num, dec)
    if num == 0 then
        return 0
    else
        local mult = 10^(dec or 0)
        return math.floor(num * mult + 0.5) / mult
    end
end

function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

TempEauPiscine = tonumber(otherdevices_svalues[dev_TEau])

val_TEau=os.capture('sqlite3 '..dbPath..' "select temp_avg from temperature_calendar where devicerowid='..otherdevices_idx[dev_TEau]..' order by date desc limit 1"')
val_TEau=round(val_TEau,1)



--recupere l heure
time=os.time()
minutes=tonumber(os.date('%M',time))
hours=tonumber(os.date('%H',time))
hm = (hours * 60 + minutes)  

djour=os.date('%Y-%m-%d')

sql = 'sqlite3 ' .. dbPath .. ' "select date from LightingLog where DeviceRowID=49 and date like \'' .. djour .. '%\' and nvalue = 0"'
mo0 = os.capture(sql)
sql = 'sqlite3 ' .. dbPath .. ' "select date from LightingLog where DeviceRowID=49 and date like \'' .. djour .. '%\' and nvalue = 1"'
mo1 = os.capture(sql)
print('mo1 = [' .. mo1 .. '] mo0 = [' .. mo0 .. '] djour=' .. djour)

if string.len(mo1) == 0 and string.len(mo0) == 0 then
  print('MO=00')
elseif string.len(mo1) ~= 0 and string.len(mo0) ~= 0 then
  print('MO=11')
end
 



-- TempExtPiscine = tonumber(otherdevices_svalues['TempExt'])
TempExtPiscine = round(tonumber(otherdevices_temperature['TempExt']),1)


mo = otherdevices['MoteurPiscine']

print('TempEau = ' .. TempEauPiscine .. ' TempEauMoy = ' .. val_TEau .. ' TempExt = ' .. TempExtPiscine .. ' HM = ' .. hm .. ' Moteur=' .. mo .. ' CGel=' .. TempGel)

if (TempExtPiscine < TempGel) then

-- Mode Gel, je laisse le moteur tourne tant que la temperature est < TempGel
   print('piscine en mode GEL')
   if (mo == 'Off') then
      commandArray['MoteurPiscine'] = 'On'
   end

-- Attention a la sortie du mode gel, car le moteur tourne

elseif (val_TEau < TempHivernage) then
-- Mode Hiver sans Gel, donc filtration de 2h a partir de 12h
   print('Piscine en Mode Hiver')

   if ((mo == 'Off') and (hm == 720)) then 
      -- Il est 12h et le moteur est Off, alors je demarre
      commandArray['MoteurPiscine'] = 'On'
   elseif ((mo == 'On') and (hm == 840)) then
      -- Il est 14h et le moteur est On, alors je l'arrete
      commandArray['MoteurPiscine'] = 'Off'
   elseif ((mo == 'On') and ((hm < 720) or (hm > 840))) then
      -- le moteur tourne, nous somme en mode hiver et dehors de la periode de filtration, donc 
      -- nous venons juste de sortir du mode GEL
      -- J'eteind le moteur avec un histeresis de 1 degre
      if (TempExtPiscine > TempGel + 1) then
          commandArray['MoteurPiscine'] = 'Off'
      end
   end
      
else
-- Pas de gel, pas en hivernage, donc c'est le mode ete
-- Je gere 1 periode de filtrage avec une duree variable en fonction de la temperature de l'eau
   print('Piscine en Mode ETE')
   DureeFiltrage = (45 + (val_TEau - 17) * 5) * 8 
   
   print('Filtrage normal ' .. DureeFiltrage .. ' mns')

   -- 1 cycles de filtrage autour de 14h, donc autour de hm = 840

   if ((mo == 'Off') and ((hm >= 840 - (DureeFiltrage/2)) and (hm <= 840 + (DureeFiltrage/2)))) then
       commandArray['MoteurPiscine'] = 'On'      
   end   

   if ((mo == 'On') and ((hm < 840 - (DureeFiltrage/2)) or (hm > 840 + (DureeFiltrage/2)))) then
       commandArray['MoteurPiscine'] = 'Off'      
   end   

end

mo = otherdevices['MoteurPiscine']
print('Moteur=' .. mo)

return commandArray
