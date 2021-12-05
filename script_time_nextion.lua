commandArray = {}

function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

function round(num, dec)
    if num == 0 then
        return 0
    else
        local mult = 10^(dec or 0)
        return math.floor(num * mult + 0.5) / mult
    end
end

function round2(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

-- ip/control?cmd=NEXTION,sleep=0"

ip_nextion="192.168.1.105"

-- test presence nextion
ping_success = os.execute('ping -c1 -w1 ' .. ip_nextion)

if ping_success then

	-- Temperature du salon
	sv = otherdevices_svalues['TempSalon']
	lw = {}
	for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
	th = lw[1] .. "°/" .. lw[2] .. "%"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.ts.txt="' .. url_encode(th) .. '"'
	commandArray[1] = {['OpenURL']=cmd}

	-- Temperature du Garage
	sv = otherdevices_svalues['TempGarage']
	lw = {}
	for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
	th = lw[1] .. "°/" .. lw[2] .. "%"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.tg.txt="' .. url_encode(th) .. '"'
	commandArray[2] = {['OpenURL']=cmd}

	-- Temperature du bureau
	sv = otherdevices_svalues['TempBureau']
	lw = {}
	for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
	th = lw[1] .. "°/" .. lw[2] .. "%"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.tb.txt="' .. url_encode(th) .. '"'
	commandArray[3] = {['OpenURL']=cmd}

	-- Temperature du ext
	sv = otherdevices_svalues['TempExt']
	lw = {}
	for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
	th = lw[1] .. "°/" .. lw[2] .. "%"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.te.txt="' .. url_encode(th) .. '"'
	commandArray[4] = {['OpenURL']=cmd}

	-- Temperature du chambre
	sv = otherdevices_svalues['TempChambre']
	lw = {}
	for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
	th = lw[1] .. "°/" .. lw[2] .. "%"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.tc.txt="' .. url_encode(th) .. '"'
	commandArray[5] = {['OpenURL']=cmd}

	-- Temperature du piscine
	v = tonumber(otherdevices_svalues['TempEauPiscine']) .. "°"
	cmd = ip_nextion .. '/control?cmd=NEXTION,home.tp.txt="' .. url_encode(v) .. '"'
	commandArray[6] = {['OpenURL']=cmd}


-- conso
sv = otherdevices['ConsoGeneraleEco']
lw = {}
for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
th = round2(tonumber(lw[1])) .. "W"
cmd = ip_nextion .. '/control?cmd=NEXTION,home.me.txt="' .. url_encode(th) .. '"'
commandArray[7] = {['OpenURL']=cmd}


-- production
-- sv = otherdevices['Enphase kWh Production']
sv = otherdevices['ProductionSolaireEco']
lw = {}
for w in sv:gmatch("([^;]+)") do table.insert(lw, w) end
th = round2(tonumber(lw[1])) .. "W"
cmd = ip_nextion .. '/control?cmd=NEXTION,home.ms.txt="' .. url_encode(th) .. '"'
commandArray[8] = {['OpenURL']=cmd}

end

return commandArray
