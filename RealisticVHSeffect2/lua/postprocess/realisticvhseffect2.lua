AddCSLuaFile()
AddCSLuaFile("realisticvhseffect2_menu.lua")

if not CLIENT then return end
-- Please note: this effect simulates the PAL 720x576 25f-fps system. For NTSC you will need to replace the following values: 720->640; 576->480; 25->30; 288->240

-- terms used in this file:
--  INTERLACED: Display of frames, when the signal generator produces two half-frames which the TV draws through the lines, adding them on top of each other.
--  OSD: ON-SCREEN-DISPLAY. Its a signal generator that creates its own signal and synchronizes it with the input signal, overlapping the input signal with its own.
--  FRAME-SYNCHRO: Frame synchronization. From this the TV starts drawing the frame. This is vertical sync.
--  HORIZONTAL SYNCHRONIZATION: This is the beginning of each line in the frame. If this synchronization is delayed, the line will be shifted.
--  CHROMA: Colour Channel
--  LUMA: Brightness Channel

-- If you dont understand something - you should contact more knowledgeable people.
local cachedcurtime = CurTime()
local rt = render.GetScreenEffectTexture(0)
local blurmat = Material("pp/blurx")
local morphrt = GetRenderTarget("realisticvhseffect2/morphrt2",720,576)
local morphmat = CreateMaterial("realisticvhseffect2/morphmat2","g_refract",{["$fbtexture"] = rt:GetName(),["$normalmap"] = morphrt:GetName(),["$refractamount"] = 1,["$bluramout"] = 0})
local matred = CreateMaterial("realisticvhseffect2/redmat","UnLitGeneric",{
    ["$basetexture"] = rt:GetName(),
    ["$color2"] = "[1 0 0]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})
local matgreen = CreateMaterial("realisticvhseffect2/greenmat","UnLitGeneric",{
    ["$basetexture"] = rt:GetName(),
    ["$color2"] = "[0 1 0]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})
local matblue = CreateMaterial("realisticvhseffect2/bluemat","UnLitGeneric",{
    ["$basetexture"] = rt:GetName(),
    ["$color2"] = "[0 0 1]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})
local colormod = CreateMaterial("realisticvhseffect2/colormod","g_colourmodify",{["$fbtexture"] = rt:GetName(),["$pp_colour_addr"] = 0,["$pp_colour_addg"] = 0,["$pp_colour_addb"] = 0,["$pp_colour_brightness"] = 0.1,["$pp_colour_inv"] = 0,["$pp_colour_colour"] = 0,["$pp_colour_contrast"] = 1,["$pp_colour_mulr"] = 0,["$pp_colour_mulg"] = 0,["$pp_colour_mulb"] = 0,})
local interlacedbufferrt = GetRenderTargetEx("realisticvhseffect2/interlacedbufferrt",ScrW(),ScrH(),
	RT_SIZE_NO_CHANGE,
	3,
	bit.bor(2, 256),
	0,
	IMAGE_FORMAT_BGR888) -- remove alpha channel for buffer. update 09.06.2025
local interlacedbuffermat = CreateMaterial("realisticvhseffect2/interlacedbuffermat","UnLitGeneric",{["$basetexture"] = interlacedbufferrt:GetName(),["$ignorez"] = "1",["$translucent"] = "1"})
local interlacedcopyrt = GetRenderTarget("realisticvhseffect2/interlacedcopyrt",ScrW(),ScrH())
local interlacedcopymat = CreateMaterial("realisticvhseffect2/interlacedcopymat","UnLitGeneric",{["$basetexture"] = interlacedcopyrt:GetName(),["$ignorez"] = "1",["$translucent"] = "1"})

local noisert = GetRenderTarget("realisticvhseffect2/noisert",720,576)
local noisemat = CreateMaterial("realisticvhseffect2/noisemat","UnLitGeneric",{["$basetexture"] = noisert:GetName(),["$ignorez"] = "1",["$translucent"] = "1",["$vertexalpha"] = "1"})
render.PushRenderTarget(morphrt)
render.Clear(127,127,0,255,true,true)
render.PopRenderTarget()

REALISTICVHSEFFECT2_CFG = {}

REALISTICVHSEFFECT2_CFG.enabled = true

REALISTICVHSEFFECT2_CFG.currenthookclass = "PostDrawHUD"

REALISTICVHSEFFECT2_CFG.framesynchro = 576
REALISTICVHSEFFECT2_CFG.shuttlering = 0
REALISTICVHSEFFECT2_CFG.paused = false

REALISTICVHSEFFECT2_CFG.testtable = nil

REALISTICVHSEFFECT2_CFG.osd = {
    middletext = nil,
    hours = 2,
    minutes = 22,
    seconds = 15,
    days = 9,
    months = 1,
    years = 2025,
    fixsize = {m = {" ",2},s = {"0",2},ms = {" ",4},f = {"0",2}}, -- fixed size
    dateenabled = true,
    datepos = 3,
    -- 1: LEFTTOP;2: RIGHTTOP;3:LEFTDOWN;4:RIGHTDOWN;
    datetbl = {
        "%h",":","%mi",":","%s","\n","%d",".","%m",".","%y"
    },
    datesamples = {
        ["\n"] = "NewLine",
        ["%h"] = "Hours",
        ["%mi"] = "Minutes",
        ["%s"] = "Seconds",
        ["%f"] = "Frames",
        ["%ms"] = "Miliseconds",
        ["%d"] = "Days",
        ["%m"] = "Months",
        ["%y"] = "Years",
    }
}

REALISTICVHSEFFECT2_CFG.postclrmod = {
    ["pp_colour_addr"] = 0,
    ["pp_colour_addg"] = 0,
    ["pp_colour_addb"] = 0,
    ["pp_colour_brightness"] = 0,
    ["pp_colour_colour"] = 1,
    ["pp_colour_inv"] = 0,
    ["pp_colour_contrast"] = 1,
    ["pp_colour_mulr"] = 0,
    ["pp_colour_mulg"] = 0,
    ["pp_colour_mulb"] = 0,
}
REALISTICVHSEFFECT2_CFG.viewtype = 1
REALISTICVHSEFFECT2_CFG.wave = {enabled = true,freq = 4,detail = 2,amp = 0.025}
REALISTICVHSEFFECT2_CFG.sharpen = {enabled = true,size = 1,value = 3}
REALISTICVHSEFFECT2_CFG.cameraclrdist = {r = 0,g = 0,b = 0}
REALISTICVHSEFFECT2_CFG.interlaced = {enabled = true,pos = 0}
REALISTICVHSEFFECT2_CFG.channelssettings = {
    chroma_line_drop = false,
    chroma_line_drop_maxdrops = 1,
    chroma_blur = 4,
    chroma_noise_enabled = true,
    chroma_noise_scalex = 16,
    chroma_noise_scaley = 8,
    chroma_noise_alpha = 0.004125,
    
    general_blur = 1.5,
    luma_noise_enabled = true,
    luma_noise_scalex = 32,
    luma_noise_scaley = 18,
    luma_noise_alpha = 0.025,
}
REALISTICVHSEFFECT2_CFG.comets = {factor = 50000,enabled = false,size = 0.5}

local function cfg_readstring(cfile)
    return cfile:Read(cfile:ReadByte())
end

local function cfg_readdata(cfile)
    local type = cfile:ReadByte()
    local name = cfg_readstring(cfile)
    if not name then return end
    if type == 3 then
        return name,cfile:ReadBool()
    elseif type == 2 then
        local tbl = {}
        for i = 1,cfile:ReadByte() do
            local name,data = cfg_readdata(cfile)
            if name then tbl[tonumber(name) or name] = data else break end
            -- there is an obvious problem here - keys are always serialized as strings and lua wont be able to index them correctly. of course, this can be fixed, but for now it works
        end
        return name,tbl
    elseif type == 1 then
        return name,cfg_readstring(cfile)
    elseif type == 0 then
        return name,cfile:ReadDouble()
    end
    return name,nil
end

local function LoadCFG()
    local cfile = file.Open("realisticvhseffect2cfg.dat","rb","DATA")
    if cfile then
        if cfile:Read(9) == "RVHSE2CFG" then
            cfile:Skip(4)
            local name,data = cfg_readdata(cfile)
            if name == "REALISTICVHSEFFECT2_CFG" then
                REALISTICVHSEFFECT2_CFG = data
            end
        end
        cfile:Close()
    end
end

LoadCFG()

-- OSD support

local osdfontsize = math.min(ScrH()/8,ScrW()/8)
surface.CreateFont("RealisticVHSEffect2Font", {
    font = "Real Vhs Font",
    extended = false, -- this font only supports ascii set
    size = osdfontsize,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local function getdateosd_monthdays()
    local days = {31,28,31,30,31,30,31,31,30,31,30,31}

    if (REALISTICVHSEFFECT2_CFG.osd.months == 2 and ((REALISTICVHSEFFECT2_CFG.osd.years % 4 == 0 and REALISTICVHSEFFECT2_CFG.osd.years % 100 ~= 0) or (REALISTICVHSEFFECT2_CFG.osd.years % 400 == 0))) then
        return 29
    end

    return days[REALISTICVHSEFFECT2_CFG.osd.months]
end

local function getdateosd_value(val,type)
    local val = tostring(val)
    local tbl = REALISTICVHSEFFECT2_CFG.osd.fixsize[type]
    if tbl then
        local diff = tbl[2]-#val
        if diff < 0 then
            val = string.sub(val,1,diff)
        elseif diff > 0 then
            val = string.rep(tbl[1],diff) .. val
        end
        return val
    end
    return val
end

local realframetime = 0
local function formattostring(tbl,y,m,d,h,mi,s,ms,f)
    local str = ""
    for k,v in pairs(tbl) do
        if v == "%y" then str = str .. y       -- years
        elseif v == "%mi" then str = str .. mi -- minutes
        elseif v == "%d" then str = str .. d   -- days
        elseif v == "%h" then str = str .. h   -- hours
        elseif v == "%m" then str = str .. m   -- mounths
        elseif v == "%s" then str = str .. s   -- seconds
        elseif v == "%ms" then str = str .. ms -- miliseconds
        elseif v == "%f" then str = str .. f   -- frames
        else str = str .. v end                -- raw
    end
    return str
end

local function getdateosd()
    REALISTICVHSEFFECT2_CFG.osd.seconds = REALISTICVHSEFFECT2_CFG.osd.seconds + realframetime -- fixes the cause of time speeding up when the menu is open
    if REALISTICVHSEFFECT2_CFG.osd.seconds >= 60 then
        REALISTICVHSEFFECT2_CFG.osd.seconds = 0
        REALISTICVHSEFFECT2_CFG.osd.minutes = REALISTICVHSEFFECT2_CFG.osd.minutes + 1 -- please note that the difference between the current seconds and the maximum is not taken into account!
        if REALISTICVHSEFFECT2_CFG.osd.minutes >= 60 then
            REALISTICVHSEFFECT2_CFG.osd.minutes = 0
            REALISTICVHSEFFECT2_CFG.osd.hours = REALISTICVHSEFFECT2_CFG.osd.hours + 1
            if REALISTICVHSEFFECT2_CFG.osd.hours >= 24 then
                REALISTICVHSEFFECT2_CFG.osd.hours = 0
                REALISTICVHSEFFECT2_CFG.osd.days = REALISTICVHSEFFECT2_CFG.osd.days + 1
                if REALISTICVHSEFFECT2_CFG.osd.days > getdateosd_monthdays() then
                    REALISTICVHSEFFECT2_CFG.osd.days = 1
                    REALISTICVHSEFFECT2_CFG.osd.months = REALISTICVHSEFFECT2_CFG.osd.months + 1
                    if REALISTICVHSEFFECT2_CFG.osd.months > 12 then
                        REALISTICVHSEFFECT2_CFG.osd.months = 1
                        REALISTICVHSEFFECT2_CFG.osd.years = REALISTICVHSEFFECT2_CFG.osd.years + 1
                    end
                end
            end
        end
    end
    return formattostring(REALISTICVHSEFFECT2_CFG.osd.datetbl,getdateosd_value(REALISTICVHSEFFECT2_CFG.osd.years,"y"),
    getdateosd_value(REALISTICVHSEFFECT2_CFG.osd.months,"m"),getdateosd_value(REALISTICVHSEFFECT2_CFG.osd.days,"d"),
    getdateosd_value(REALISTICVHSEFFECT2_CFG.osd.hours,"h"),getdateosd_value(REALISTICVHSEFFECT2_CFG.osd.minutes,"mi"),
    getdateosd_value(math.floor(REALISTICVHSEFFECT2_CFG.osd.seconds),"s"),getdateosd_value(math.floor((REALISTICVHSEFFECT2_CFG.osd.seconds-math.floor(REALISTICVHSEFFECT2_CFG.osd.seconds))*1000),"ms"), -- seconds and miliseconds
    getdateosd_value(math.floor((REALISTICVHSEFFECT2_CFG.osd.seconds-math.floor(REALISTICVHSEFFECT2_CFG.osd.seconds))*25),"f")) -- frames(25 f-fps)
end

local function draw_osdtext(a,b,c,d,e,f,g)
    draw.SimpleText(a,b,c+4,d,Color(0,0,0,255),f,g)
    return draw.SimpleText(a,b,c,d,e,f,g)
end

local function addosd()
    if REALISTICVHSEFFECT2_CFG.osd.dateenabled then
        local datealign = TEXT_ALIGN_LEFT
        local datex = 0
        local datey = 0
        if REALISTICVHSEFFECT2_CFG.osd.datepos == 1 then     -- left down
            datex = ScrW()/8
            datey = ScrH()/6
            if REALISTICVHSEFFECT2_CFG.viewtype == 2 then -- fix cropping date
                datex = ((ScrW()-(ScrW()/1.25))/2)+(ScrW()/16)
            end
        elseif REALISTICVHSEFFECT2_CFG.osd.datepos == 2 then -- right up
            datealign = TEXT_ALIGN_RIGHT
            datex = ScrW()-(ScrW()/8)
            datey = ScrH()/6
            if REALISTICVHSEFFECT2_CFG.viewtype == 2 then -- fix cropping date
                datex = ((ScrW()-(ScrW()/1.25))/2)+(ScrW()/16)
            end
        elseif REALISTICVHSEFFECT2_CFG.osd.datepos == 3 then -- left dwon
            datex = ScrW()/8
            datey = ScrH()/1.4
            if REALISTICVHSEFFECT2_CFG.viewtype == 2 then -- fix cropping date
                datex = ((ScrW()-(ScrW()/1.25))/2)+(ScrW()/16)
            end
        elseif REALISTICVHSEFFECT2_CFG.osd.datepos == 4 then -- right down
            datealign = TEXT_ALIGN_RIGHT
            datex = ScrW()-(ScrW()/8)
            datey = ScrH()/1.4
            if REALISTICVHSEFFECT2_CFG.viewtype == 2 then -- fix cropping date
                datex = ((ScrW()-(ScrW()/1.25))/2)+(ScrW()/16)
            end
        end
        local datetbl = string.Explode("\n",getdateosd())
        for i = 0,#datetbl-1 do
            draw_osdtext(datetbl[i+1],"RealisticVHSEffect2Font",datex,datey+((osdfontsize/2)*i),Color(255,255,255),datealign,TEXT_ALIGN_TOP)
        end
    end
    if REALISTICVHSEFFECT2_CFG.osd.middletext then
        local middletexttbl = string.Explode("\n",REALISTICVHSEFFECT2_CFG.osd.middletext)
        if #middletexttbl > 1 then
            for i = 0,#middletexttbl-1 do
                draw_osdtext(string.upper(middletexttbl[i+1]),"RealisticVHSEffect2Font",ScrW()/2,(ScrH()/2)+((osdfontsize/2)*i),Color(255,255,255),TEXT_ALIGN_CENTER)
            end
        else
            draw_osdtext(string.upper(REALISTICVHSEFFECT2_CFG.osd.middletext),"RealisticVHSEffect2Font",ScrW()/2,ScrH()/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end
-- Horizontal Synchronization Support

local function getwavex(i,shift,initval)
    local val = initval
    for j = 1,REALISTICVHSEFFECT2_CFG.wave.detail do
        val = val + (math.sin((i/64)+(cachedcurtime*(REALISTICVHSEFFECT2_CFG.wave.freq*j))*shift)/j)
    end
    return val*10
end

local function updatemorphrt()
    render.PushRenderTarget(morphrt)
    render.Clear(127,127,0,255,true,true)
    local shift = math.Rand(0,1)
    if REALISTICVHSEFFECT2_CFG.shuttlering == 0 then
        for i = 1,576 do
            render.SetViewPort(0,i,720,1)
            render.Clear(127+getwavex(i,shift,0),127,0,255,true,true)
        end
    else
        local height3 = (576/3)
        local cshift = 0
        local cshiftn = 0
        for i = 1,576 do
            render.SetViewPort(0,i,720,1)
            render.Clear(127+getwavex(i,shift,cshift),127,0,255,true,true)
            cshiftn = cshiftn + 1
            cshift = cshift+((cshiftn/height3)*REALISTICVHSEFFECT2_CFG.shuttlering)
            if cshift > 32 or cshift < -32 then
                cshift = 0
                cshiftn = 0
            end
        end
    end
    render.PopRenderTarget()
end

--

local function updatenoisert(chroma)
    -- i know that i can buffer all this, but it will take up more memory space, right?
    render.PushRenderTarget(noisert)
    render.Clear(0,0,0,0,true,true)
    if chroma then
        local scalex = 720/REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scalex
        for y = 1,576/REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scaley do
            for x = 0,scalex do
                render.SetViewPort(x,y,1,1)
                render.Clear(math.random(1,255),math.random(1,255),math.random(1,255),255,true,true)
            end
        end
    else
        local scalex = 720/REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scalex
        for y = 1,576/REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scaley do
            for x = 0,scalex do
                render.SetViewPort(x,y,1,1)
                local br = math.random(1,255)
                render.Clear(br,br,br,255,true,true)
            end
        end
    end
    render.PopRenderTarget()
end

local function drawcomets()
    if REALISTICVHSEFFECT2_CFG.comets.enabled then
        local maxrand = -REALISTICVHSEFFECT2_CFG.comets.factor
        local maxsizediff = REALISTICVHSEFFECT2_CFG.comets.size
        local xw = 720/4
        for y = 1,576/2 do
            local cometval = 0
            local curmin = math.random(maxrand,0)
            for x = 0,xw do
                if cometval > 0 then
                    draw.RoundedBox(0,x*4,y*2,4,2,Color(cometval*255,cometval*255,cometval*255,255))
                end
                cometval = cometval - math.Rand(0,maxsizediff)
                if cometval < curmin then
                    cometval = 1
                    curmin = math.random(maxrand,0)
                end
            end
        end
        render.UpdateScreenEffectTexture(0)
    end
end

local function addblur()
    render.OverrideAlphaWriteEnable(true,false)

    -- draw a black and white picture on top of the screen
    render.UpdateScreenEffectTexture(0)
    colormod:SetFloat("$pp_colour_brightness",0.1)colormod:SetFloat("$pp_colour_contrast",1)colormod:SetFloat("$pp_colour_colour",0)
    render.SetMaterial(colormod)
    render.DrawScreenQuadEx(0,0,ScrW()*(ScrW()/720),ScrH()*(ScrH()/576))
    if REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_enabled then
        updatenoisert(false)
        surface.SetMaterial(noisemat)
        surface.SetDrawColor(255,255,255,REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_alpha*255)
        surface.DrawTexturedRectUV(0,0,(ScrW()*(ScrW()/720))*REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scalex,(ScrH()*(ScrH()/576))*REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scaley,-2,-1,0,0)
    end

    -- now add some colours
    
    if REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled or REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop then
        if REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled then
            updatenoisert(true)
        end
        render.PushRenderTarget(rt)
        if REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled then
            surface.SetMaterial(noisemat)
            surface.SetDrawColor(255,255,255,REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_alpha*255)
            -- increase the size by repetition(for speed)
            surface.DrawTexturedRectUV(0,0,(ScrW()*(ScrW()/720))*REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scalex,(ScrH()*(ScrH()/576))*REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scaley,-1,-1,1,1)
        end
        if REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop then
            for i = 1,math.random(1,REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop_maxdrops) do
                render.SetViewPort(0,math.random(1,576),720,math.random(1,5))
                render.Clear(0,0,0,0,true,true)
            end
        end
        render.PopRenderTarget()
    end

    render.OverrideBlend(true,3,2,0) -- approximately the same blending effect
    
    blurmat:SetTexture("$basetexture",rt)
    blurmat:SetFloat("$size",REALISTICVHSEFFECT2_CFG.channelssettings.chroma_blur)
    render.SetMaterial(blurmat)
    render.DrawScreenQuadEx(0,0,ScrW()*(ScrW()/720),ScrH()*(ScrH()/576))

    render.OverrideAlphaWriteEnable(false,false)
    render.OverrideBlend(false)
    -- in the original version the pixel colour is the average value. double the colour
    render.UpdateScreenEffectTexture(0)
    colormod:SetFloat("$pp_colour_brightness",0)colormod:SetFloat("$pp_colour_colour",2)colormod:SetFloat("$pp_colour_contrast",1)
    render.SetMaterial(colormod)
    render.DrawScreenQuadEx(0,0,ScrW(),ScrH())
    render.UpdateScreenEffectTexture(0)
end

local function renderinterlacing()
    if REALISTICVHSEFFECT2_CFG.interlaced.enabled then
        -- principle: buffer frame 1 and draw frame 2 on it
        render.UpdateScreenEffectTexture(0)
        if REALISTICVHSEFFECT2_CFG.interlaced.pos == 1 then
            REALISTICVHSEFFECT2_CFG.interlaced.pos = 0
            render.CopyTexture(rt,interlacedbufferrt)
            render.PushRenderTarget(interlacedbufferrt)
            render.PopRenderTarget()
        else
            render.CopyTexture(rt,interlacedcopyrt)
            render.PushRenderTarget(interlacedcopyrt)
            render.PopRenderTarget()
            REALISTICVHSEFFECT2_CFG.interlaced.pos = 1
        end
        render.SetMaterial(interlacedcopymat)
        render.DrawScreenQuad()
        render.SetStencilEnable(true)
        render.ClearStencil()
        render.SetStencilTestMask(255)
        render.SetStencilWriteMask(255)
        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(9)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        
        local linesize2 = math.ceil(ScrH()/288)
        local linesize = linesize2/2
        for j = 0,ScrH()/linesize2 do
            draw.RoundedBox(0,0,(j*linesize2)+linesize,ScrW(),linesize,Color(0,0,0))
        end

        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        
        render.SetMaterial(interlacedbuffermat)
        render.DrawScreenQuad()

        render.SetStencilEnable(false)
        render.UpdateScreenEffectTexture(0)
    end
end

local lastquery = 0

local lastsavedtime = 0

local function rendervhseffect()
    if not REALISTICVHSEFFECT2_CFG.enabled then return end
    if SysTime()-lastsavedtime > 60 then
        RunConsoleCommand("realisticvhseffect2_savecfg","")
        lastsavedtime = SysTime()
    end
    if REALISTICVHSEFFECT2_CFG.testtable then
        render.SetMaterial(REALISTICVHSEFFECT2_CFG.testtable)
        render.DrawScreenQuad()
        render.UpdateScreenEffectTexture(0)
    else
        if REALISTICVHSEFFECT2_CFG.cameraclrdist.r ~= 0 or REALISTICVHSEFFECT2_CFG.cameraclrdist.g ~= 0 or REALISTICVHSEFFECT2_CFG.cameraclrdist.b ~= 0 then
            render.UpdateScreenEffectTexture(0)
            render.SetMaterial(matred)
            render.DrawScreenQuadEx(-REALISTICVHSEFFECT2_CFG.cameraclrdist.r,-REALISTICVHSEFFECT2_CFG.cameraclrdist.r,ScrW()+REALISTICVHSEFFECT2_CFG.cameraclrdist.r,ScrH()+REALISTICVHSEFFECT2_CFG.cameraclrdist.r)
            render.SetMaterial(matgreen)
            render.DrawScreenQuadEx(-REALISTICVHSEFFECT2_CFG.cameraclrdist.g,-REALISTICVHSEFFECT2_CFG.cameraclrdist.g,ScrW()+REALISTICVHSEFFECT2_CFG.cameraclrdist.g,ScrH()+REALISTICVHSEFFECT2_CFG.cameraclrdist.g)
            render.SetMaterial(matblue)
            render.DrawScreenQuadEx(-REALISTICVHSEFFECT2_CFG.cameraclrdist.b,-REALISTICVHSEFFECT2_CFG.cameraclrdist.b,ScrW()+REALISTICVHSEFFECT2_CFG.cameraclrdist.b,ScrH()+REALISTICVHSEFFECT2_CFG.cameraclrdist.b)
            colormod:SetFloat("$pp_colour_brightness",0)colormod:SetFloat("$pp_colour_contrast",0.82)colormod:SetFloat("$pp_colour_colour",1)
            render.SetMaterial(colormod)
            render.DrawScreenQuad()

            render.UpdateScreenEffectTexture(0)
        end
    end
    if REALISTICVHSEFFECT2_CFG.wave.enabled then
        updatemorphrt()
    end

    addosd()
    
    render.UpdateScreenEffectTexture(0)
    blurmat:SetTexture("$basetexture",rt)
    blurmat:SetFloat("$size",REALISTICVHSEFFECT2_CFG.channelssettings.general_blur)
    render.SetMaterial(blurmat)
    render.DrawScreenQuadEx(0,0,720,576)
    -- Please note that starting from this line the image is in 720 x 576 format (for ease of adding effects)

    if REALISTICVHSEFFECT2_CFG.paused then
        colormod:SetFloat("$pp_colour_brightness",0)colormod:SetFloat("$pp_colour_contrast",1)colormod:SetFloat("$pp_colour_colour",0)
        render.SetMaterial(colormod)
        render.DrawScreenQuadEx(0,0,720,576)
    end
    drawcomets()

    draw.RoundedBox(0,-2,0,4,576,Color(0,0,0))
    draw.RoundedBox(0,720,0,ScrW()-720,576,Color(0,0,0))
    render.UpdateScreenEffectTexture(0)
    if REALISTICVHSEFFECT2_CFG.wave.enabled then
        morphmat:SetFloat("$refractamount",REALISTICVHSEFFECT2_CFG.wave.amp/2)
        render.SetMaterial(morphmat)
        render.DrawScreenQuad()
    end
    if REALISTICVHSEFFECT2_CFG.shuttlering ~= 0 then
        for i = 1,2 do
            local cometval = 0
            local curmin = -math.random(0,10)
            for y = 0,ScrH()/40 do
                for x = 0,ScrW()/4 do
                    if cometval > 0 then
                        draw.RoundedBox(0,x*4,(y+((576/3)*i))+10,4,3,Color(cometval*255,cometval*255,cometval*255,255))
                    end
                    cometval = cometval - math.Rand(0,1)/5
                    if cometval < curmin then
                        cometval = 1
                        curmin = -math.random(0,10)
                    end
                end
            end
        end
    end
    -- Back to original resolution
    addblur()
    if REALISTICVHSEFFECT2_CFG.sharpen.enabled then
        if REALISTICVHSEFFECT2_CFG.sharpen.size > 0 and REALISTICVHSEFFECT2_CFG.sharpen.value > 0 then
            DrawSharpen(REALISTICVHSEFFECT2_CFG.sharpen.size,REALISTICVHSEFFECT2_CFG.sharpen.value)
            render.UpdateScreenEffectTexture(0)
        end
    end
    renderinterlacing()
    for k,v in pairs(REALISTICVHSEFFECT2_CFG.postclrmod) do
        colormod:SetFloat("$" .. k,v)
    end
    render.SetMaterial(colormod)
    render.DrawScreenQuad()
    render.UpdateScreenEffectTexture(0)
    if REALISTICVHSEFFECT2_CFG.framesynchro > 0 then
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0))
        blurmat:SetTexture("$basetexture",rt)
        blurmat:SetFloat("$size",0)
        render.SetMaterial(blurmat)
        render.DrawScreenQuadEx(0,REALISTICVHSEFFECT2_CFG.framesynchro,ScrW(),ScrH())
        REALISTICVHSEFFECT2_CFG.framesynchro = math.max(REALISTICVHSEFFECT2_CFG.framesynchro - 288,0)
        render.UpdateScreenEffectTexture(0)
    end
    if REALISTICVHSEFFECT2_CFG.viewtype == 1 then
        -- resizing
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0))
        blurmat:SetTexture("$basetexture",rt)
        blurmat:SetFloat("$size",0)
        render.SetMaterial(blurmat)
        render.DrawScreenQuadEx((ScrW()-(ScrW()/1.25))/2,0,ScrW()/1.25,ScrH())
        render.UpdateScreenEffectTexture(0)
    elseif REALISTICVHSEFFECT2_CFG.viewtype == 2 then
        -- cropping
        local cropwidth = (ScrW()-(ScrW()/1.25))/2
        draw.RoundedBox(0,0,0,cropwidth,ScrH(),Color(0,0,0))
        draw.RoundedBox(0,ScrW()-cropwidth,0,cropwidth,ScrH(),Color(0,0,0))
        render.UpdateScreenEffectTexture(0)
    end
    cachedcurtime = CurTime()
    realframetime = SysTime()-lastquery
    lastquery = SysTime()
end

hook.Add(REALISTICVHSEFFECT2_CFG.currenthookclass,"realisticvhseffect2_hook",rendervhseffect)

concommand.Add("realisticvhseffect2_changehook",function(_,_,_,argsstr)
    local argsstr = string.Replace(argsstr,'"',"")
    hook.Remove(REALISTICVHSEFFECT2_CFG.currenthookclass,"realisticvhseffect2_hook")
    hook.Add(argsstr,"realisticvhseffect2_hook",rendervhseffect)
    REALISTICVHSEFFECT2_CFG.currenthookclass = argsstr
end)
concommand.Add("realisticvhseffect2_pause",function()
    REALISTICVHSEFFECT2_CFG.framesynchro = 576
    REALISTICVHSEFFECT2_CFG.paused = not REALISTICVHSEFFECT2_CFG.paused
end)
concommand.Add("realisticvhseffect2_+shuttlering",function()
    REALISTICVHSEFFECT2_CFG.shuttlering = math.Clamp(REALISTICVHSEFFECT2_CFG.shuttlering + 0.1,-1,1)
end)
concommand.Add("realisticvhseffect2_-shuttlering",function()
    REALISTICVHSEFFECT2_CFG.shuttlering = math.Clamp(REALISTICVHSEFFECT2_CFG.shuttlering - 0.1,-1,1)
end)
concommand.Add("realisticvhseffect2_shuttlering",function()
    REALISTICVHSEFFECT2_CFG.shuttlering = 0
end)
local function cfg_writestring(cfile,str)
    cfile:WriteByte(#str) -- 0-255 length
    cfile:Write(str)      -- string
end
-- universal function for serialization of different types of data
local function cfg_writedata(cfile,name,data)
    if type(data) == "boolean" then
        cfile:WriteByte(3) -- boolean type
        cfg_writestring(cfile,name)
        cfile:WriteBool(data)
    elseif type(data) == "table" then
        cfile:WriteByte(2) -- table type
        cfg_writestring(cfile,name)
        cfile:WriteByte(table.Count(data))
        for k,v in pairs(data) do
            cfg_writedata(cfile,tostring(k),v)
        end
    elseif type(data) == "string" then
        cfile:WriteByte(1) -- string type
        cfg_writestring(cfile,name)
        cfg_writestring(cfile,data)
    elseif type(data) == "number" then
        cfile:WriteByte(0) -- number type
        cfg_writestring(cfile,name)
        cfile:WriteDouble(data)
    end
end
concommand.Add("realisticvhseffect2_savecfg",function()
    local cfile = file.Open("realisticvhseffect2cfg.dat","wb","DATA")
    -- header
    cfile:Write("RVHSE2CFG")   -- signature
    cfile:WriteLong(os.time()) -- current time
    -- data
    cfg_writedata(cfile,"REALISTICVHSEFFECT2_CFG",REALISTICVHSEFFECT2_CFG)
    --
    cfile:Close()
end)
concommand.Add("realisticvhseffect2_loadcfg",LoadCFG)

include("realisticvhseffect2_menu.lua")
