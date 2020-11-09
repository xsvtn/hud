sx, sy = guiGetScreenSize()
hud = {}
show = false

sw = function(value)
    return sx*value/1920    
end
            
sh = function(value)    
    return sy*value/1080
end
local tick = {money = getTickCount()}
local components = { 'weapon', 'ammo', 'health', 'clock', 'money', 'breath', 'armour', 'wanted', 'radio', 'area_name', 'vehicle_name'}
local render = {
    ['fist'] = {
        x = sw(1499), y = sh(47), 
        w = sw(145), h = sh(145)
    },
    ['bg_bar'] = {
        x = sw(1647), y = sh(50),
        w = sw(261), h = sh(117)
    },
    ['bg_line'] = {
        x = sw(1647), y = sh(167),
        w = sw(261), h = sh(3)
    },
    ['heart_bar'] = {
        x = sw(1656), y = sh(58),
        w = sw(243), h = sh(30)
    },
    ['food_bar'] = {
        x = sw(1656), y = sh(93), 
        w = sw(243), h = sh(30)
    },
    ['armor_bar'] = {
        x = sw(1656), y = sh(129), 
        w = sw(243), h = sh(30)
    },
    ['lungs_bar'] = {
        x = sw(1656), y = sh(22.5), 
        w = sw(243), h = sh(30)
    },
    ['heart_icon'] = {
        x = sw(1662), y = sh(67), 
        w = sw(15), h = sh(15)
    },
    ['food_icon'] = {
        x = sw(1662), y = sh(100), 
        w = sw(15), h = sh(15)
    },
    ['armor_icon'] = {
        x = sw(1662), y = sh(137), 
        w = sw(15), h = sh(15)
    },
    ['lungs_icon'] = {
        x = sw(1662), y = sh(30), 
        w = sw(15), h = sh(15)
    },
    ['heart_text'] = {
        x = sw(1641), y = sh(60.6),
        w = sw(1890), h = sh(202)
    },
    ['food_text'] = {
        x = sw(1641), y = sh(95.3),
        w = sw(1890), h = sh(202)
    },
    ['armor_text'] = {
        x = sw(1641), y = sh(131.25),
        w = sw(1890), h = sh(202)
    },
    ['lungs_text'] = {
        x = sw(1641), y = sh(24.3),
        w = sw(1890), h = sh(202)
    },
    ['money_text'] = {
        x = sw(1656), y = sh(170),
        w = sw(1899), h = sh(202)
    },
    money = getPlayerMoney(),
    tick = {money = getTickCount()},
    hp = getElementHealth(localPlayer),
    food = getElementData(localPlayer, 'plr:food') or 100,
    armor = getPedArmor(localPlayer) or 0,
    lungs = getPedOxygenLevel(localPlayer)
}

comma = function(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

renderHud = function()
    if alphaState=='in' then
		alphaMain=interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-lu_start)/1000, 'Linear')
		if alphaMain==255 then
			alphaState='showed'
			alphaMain=255
		end
	elseif alphaState=='out' then
		alphaMain=interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-lu_start)/1000, 'Linear')
		if alphaMain==0 then
			alphaState='hidden'
			alphaMain=0
		end
    end
    if getTickCount() - tick > 10 then
        if render.money ~= getPlayerMoney(localPlayer) then
            local checkMoney = render.money - getPlayerMoney(localPlayer)
                if checkMoney == math.abs(checkMoney) then
                    render.money = render.money - 1
                else
                    render.money = render.money + 1
                end
            end
        tick = getTickCount()
    end

    if math.floor(render.hp) ~= math.floor(getElementHealth(localPlayer)) then
        local check = render.hp - getElementHealth(localPlayer)
            if check == math.abs(check) then
                render.hp = render.hp - 1
            else
                render.hp = render.hp + 1
            end
        end
    local progresshp = render.hp / 100

    if math.floor(render.food) ~= math.floor(getElementData(localPlayer, 'plr:food') or 100) then
        local check = render.food - getElementData(localPlayer, 'plr:food') or 100
            if check == math.abs(check) then
                render.food = render.food - 1
            else
                render.food = render.food + 1
            end
        end
    local progressfood = render.food / 100

    if math.floor(render.armor) ~= math.floor(getPedArmor(localPlayer)) then
        local check = render.armor - getPedArmor(localPlayer)
            if check == math.abs(check) then
                render.armor = render.armor - 1
            else
                render.armor = render.armor + 1
            end
        end
    local progressarmor = render.armor / 100

    if math.floor(render.lungs) ~= math.floor(getPedOxygenLevel(localPlayer)) then
        local check = render.lungs - getPedOxygenLevel(localPlayer)
            if check == math.abs(check) then
                render.lungs = render.lungs - 1
            else
                render.lungs = render.lungs + 1
            end
        end
    local progresslungs = render.lungs / 1000

      --  dxDrawImage(render['fist'].x, render['fist'].y, render['fist'].w, render['fist'].h, hud.fist, 0, 0, 0, tocolor(255, 255, 255, alphaMain))

        -- health
        dxDrawRectangle(render['bg_bar'].x, render['bg_bar'].y, render['bg_bar'].w, render['bg_bar'].h, tocolor(34, 35, 64, alphaMain), false)
        dxDrawRectangle(render['bg_line'].x, render['bg_line'].y, render['bg_line'].w, render['bg_line'].h, tocolor(217, 125, 10, alphaMain), false)
        dxDrawRectangle(render['heart_bar'].x, render['heart_bar'].y, render['heart_bar'].w, render['heart_bar'].h, tocolor(135, 0, 0, alphaMain), false)
        dxDrawRectangle(render['heart_bar'].x, render['heart_bar'].y, (render['heart_bar'].w*progresshp), render['heart_bar'].h, tocolor(215, 0, 0, alphaMain), false)
        dxDrawText(math.floor(render.hp)..'%', render['heart_text'].x+1, render['heart_text'].y+1, render['heart_text'].w+1, render['heart_text'].h+1, tocolor(0, 0, 0, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawText(math.floor(render.hp)..'%', render['heart_text'].x, render['heart_text'].y, render['heart_text'].w, render['heart_text'].h, tocolor(181, 181, 181, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawImage(render['heart_icon'].x, render['heart_icon'].y, render['heart_icon'].w, render['heart_icon'].h, hud.heart_icon, 0, 0, 0, tocolor(255, 255, 255, alphaMain), false)
        -- food
        dxDrawRectangle(render['food_bar'].x, render['food_bar'].y, render['food_bar'].w, render['food_bar'].h, tocolor(165, 107, 37, alphaMain), false)
        dxDrawRectangle(render['food_bar'].x, render['food_bar'].y, (render['food_bar'].w*progressfood), render['food_bar'].h, tocolor(231, 149, 52, alphaMain), false)
        dxDrawText(math.floor(render.food)..'%', render['food_text'].x+1, render['food_text'].y+1, render['food_text'].w+1, render['food_text'].h+1, tocolor(0, 0, 0, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawText(math.floor(render.food)..'%', render['food_text'].x, render['food_text'].y, render['food_text'].w, render['food_text'].h, tocolor(181, 181, 181, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawImage(render['food_icon'].x, render['food_icon'].y, render['food_icon'].w, render['food_icon'].h, hud.food_icon, 0, 0, 0, tocolor(255, 255, 255, alphaMain), false)
        -- armor
        dxDrawRectangle(render['armor_bar'].x, render['armor_bar'].y, render['armor_bar'].w, render['armor_bar'].h, tocolor(120, 120, 120, alphaMain), false)
        dxDrawRectangle(render['armor_bar'].x, render['armor_bar'].y, (render['armor_bar'].w*progressarmor), render['armor_bar'].h, tocolor(165, 165, 165, alphaMain), false)
        dxDrawText(math.floor(render.armor)..'%', render['armor_text'].x+1, render['armor_text'].y+1, render['armor_text'].w+1, render['armor_text'].h+1, tocolor(0, 0, 0, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawText(math.floor(render.armor)..'%', render['armor_text'].x, render['armor_text'].y, render['armor_text'].w, render['armor_text'].h, tocolor(181, 181, 181, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawImage(render['armor_icon'].x, render['armor_icon'].y, render['armor_icon'].w, render['armor_icon'].h, hud.armor_icon, 0, 0, 0, tocolor(255, 255, 255, alphaMain), false)
        --money
        dxDrawText(comma(render.money)..' $', render['money_text'].x+1, render['money_text'].y+1, render['money_text'].w+1, render['money_text'].h+1, tocolor(0, 0, 0, alphaMain), 1.00, bold, 'right', 'top', false, false, false, false, false)
        dxDrawText(comma(render.money)..' #e37d0a$', render['money_text'].x, render['money_text'].y, render['money_text'].w, render['money_text'].h, tocolor(225, 225, 225, alphaMain), 1.00, bold, 'right', 'top', false, false, false, true, false)
        -- lungs
    if isElementInWater(localPlayer) then
        dxDrawRectangle(render['lungs_bar'].x, render['lungs_bar'].y, render['lungs_bar'].w, render['lungs_bar'].h, tocolor(0, 99, 220, alphaMain), false)
        dxDrawRectangle(render['lungs_bar'].x, render['lungs_bar'].y, (render['lungs_bar'].w*progresslungs), render['lungs_bar'].h, tocolor(0, 114, 255, alphaMain), false)
        dxDrawText(math.floor(render.lungs/10)..'%', render['lungs_text'].x+1, render['lungs_text'].y+1, render['lungs_text'].w+1, render['lungs_text'].h+1, tocolor(0, 0, 0, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawText(math.floor(render.lungs/10)..'%', render['lungs_text'].x, render['lungs_text'].y, render['lungs_text'].w, render['lungs_text'].h, tocolor(181, 181, 181, alphaMain), 1.00, regular, 'right', 'top')
        dxDrawImage(render['lungs_icon'].x, render['lungs_icon'].y, render['lungs_icon'].w, render['lungs_icon'].h, hud.lungs_icon, 0, 0, 0, tocolor(255, 255, 255, alphaMain), false)
    end
end

showing = function()
	if not show then
		show = not show
        show = true

        --hud.fist = dxCreateTexture('files/fist.png', 'dxt5', false, 'wrap')
        hud.heart_icon = dxCreateTexture('files/heart_icon.png', 'dxt5', false, 'wrap')
        hud.food_icon = dxCreateTexture('files/food_icon.png', 'dxt5', false, 'wrap')
        hud.armor_icon = dxCreateTexture('files/armor_icon.png', 'dxt5', false, 'wrap')
        hud.lungs_icon = dxCreateTexture('files/lungs_icon.png', 'dxt5', false, 'wrap')

        bold = dxCreateFont('files/bold.ttf', sw(16), false, 'antialiased')
        regular = dxCreateFont('files/regular.ttf', sw(15), false, 'antialiased')
        tick = getTickCount()
        lu_start=getTickCount()
        alphaState= 'in'
		addEventHandler('onClientRender', root, renderHud)
		return true
	end
	return false
end

hidden = function()
	if show then
		show = not show
        lu_start=getTickCount()
        alphaState= 'out'
        setTimer(function()
        removeEventHandler('onClientRender', root, renderHud)
        destroyElement(bold)
        destroyElement(regular)
    end, 1500, 1)
		return true
	end
	return false
end

function showHUD() return showing() end
function hideHUD() return hidden() end

addEventHandler('onClientResourceStart', resourceRoot, function()
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
    end
end)