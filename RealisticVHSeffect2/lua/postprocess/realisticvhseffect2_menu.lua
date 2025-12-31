
local REALISTICVHSEFFECT2_CFG_enabled = GetConVar_Internal("realisticvhseffect2_enabled")
local REALISTICVHSEFFECT2_CFG_autodisable = GetConVar_Internal("realisticvhseffect2_autodisable")
local REALISTICVHSEFFECT2_CFG_osdautocurtime = GetConVar_Internal("realisticvhseffect2_osdautocurtime")
local REALISTICVHSEFFECT2_CFG_dspenabled = GetConVar_Internal("realisticvhseffect2_dspenabled")

local function menu_addslider(parent,x,y,w,h,name,min,max,decimals,onchange,think)
    local newslider = vgui.Create("DNumSlider",parent)
    newslider:SetPos(x,y)
    newslider:SetSize(w,h)
    newslider:SetText(name)
    newslider:SetMin(min)
    newslider:SetMax(max)
    newslider:SetDecimals(decimals)
    newslider.OnValueChanged = onchange
    if think then newslider.Think = think end
    return newslider
end
local function menu_addlabel(parent,x,y,w,h,text)
    local newlabel = vgui.Create("DLabel",parent)
    newlabel:SetPos(x,y)
    newlabel:SetSize(w,h)
    newlabel:SetText(text)
    return newlabel
end
local function menu_addnumwang(parent,x,y,lw,w,h,name,min,max,initval,onchange)
    local newnumwang = vgui.Create("DNumberWang",parent)
    newnumwang:SetPos(lw+x+2,y)
    newnumwang:SetSize(w,h)
    newnumwang:SetMin(min)
    newnumwang:SetMax(max)
    newnumwang:SetValue(initval)
    newnumwang.OnValueChanged = onchange
    newnumwang.label = menu_addlabel(parent,x,y,lw,h,name)
    return newnumwang
end
local function menu_addbutton(parent,x,y,w,h,name,onclick)
    local newbutton = vgui.Create("DButton",parent)
    newbutton:SetText(name)	
    newbutton:SetPos(x,y)
    newbutton:SetSize(w,h)
    newbutton.DoClick = onclick
    newbutton.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        if self:IsDown() then
            draw.RoundedBox(6,1,1,w-2,h-2,Color(32,32,32))
        else
            draw.RoundedBox(6,1,1,w-2,h-2,Color(200,200,200))
        end
    end
    return newbutton
end
local function menu_addcombobox(parent,x,y,lw,w,h,name,initval,tbl,onselect)
    local newcombobox = vgui.Create("DComboBox",parent)
    newcombobox:SetPos(x+lw,y)
    newcombobox:SetSize(w,h)
    for k,v in pairs(tbl) do
        newcombobox:AddChoice(v)
    end
    newcombobox:SetValue(initval)
    newcombobox.OnSelect = onselect
    newcombobox.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        if self:IsDown() then
            draw.RoundedBox(6,1,1,w-2,h-2,Color(32,32,32))
        else
            draw.RoundedBox(6,1,1,w-2,h-2,Color(200,200,200))
        end
    end
    newcombobox.label = menu_addlabel(parent,x,y,lw,h,name)
    return newcombobox
end
local function menu_addcheckbox(parent,x,y,w,h,name,onchange,think)
	local newcheckbox = vgui.Create("DCheckBoxLabel",parent)
	newcheckbox:SetPos(x,y)
    newcheckbox:SetSize(w,h)
	newcheckbox:SetText(name)
	newcheckbox:SetValue(initval)
    newcheckbox.OnChange = onchange
    if think then newcheckbox.Think = think end
    return newcheckbox
end
local function menu_addcategory(parent,x,y,w,h,name,opened)
    local newcategory = vgui.Create("DCollapsibleCategory",parent)
    newcategory:SetLabel(name)
    newcategory:SetPos(x,y)
    newcategory:SetSize(w,h)
    newcategory:SetExpanded(opened)
    newcategory.OnToggle = function(self,opened)
        local ypos = nil
        for k,v in pairs(self:GetParent():GetChildren()) do
                if ypos then
                    local xpos = v:GetPos()
                    v:SetPos(xpos,ypos)
                else
                    _,ypos = v:GetPos()
                end
            if v:GetName() == "DCollapsibleCategory" then
                if v:GetExpanded() then
                    local _,vheight = v:ChildrenSize()
                    ypos = ypos + vheight+v:GetHeaderHeight()+8 -- v.OldHeight
                else
                    ypos = ypos + v:GetHeaderHeight()+8
                end
            else
                local _,vheight = v:GetSize()
                ypos = ypos + vheight
            end
        end
        timer.Simple(0.5,function()--RealFrameTime()*10,function()
        if IsValid(self:GetParent():GetParent()) then
            local ypos = nil
            for k,v in pairs(self:GetParent():GetParent():GetChildren()) do
                    if ypos then
                        local xpos = v:GetPos()
                        v:SetPos(xpos,ypos)
                    else
                        _,ypos = v:GetPos()
                    end
                if v:GetName() == "DCollapsibleCategory" then
                    if v:GetExpanded() then
                        local _,vheight = v:ChildrenSize()
                        ypos = ypos + vheight+v:GetHeaderHeight()+8 -- v.OldHeight
                    else
                        ypos = ypos + v:GetHeaderHeight()+8
                    end
                else
                    local _,vheight = v:GetSize()
                    ypos = ypos + vheight
                end
            end
        end
        end)
    end
    return newcategory
end
concommand.Add("realisticvhseffect2_testtablemenu",function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("RealisticVHSEffect2 Test Table Menu")
    frame:SetSize(256,96)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
    end
    local edittext = vgui.Create("DTextEntry",frame)
    edittext:SetPos(32,32)
    edittext:SetSize(192,32)
    if IsValid(REALISTICVHSEFFECT2_CFG.testtable) then
        if type(REALISTICVHSEFFECT2_CFG.testtable) == "Material" then
            edittext:SetText(tostring(REALISTICVHSEFFECT2_CFG.testtable:GetName()))
        else
            edittext:SetText(tostring(REALISTICVHSEFFECT2_CFG.testtable))
        end
    else
        edittext:SetText("")
    end
    menu_addbutton(frame,32,64,32,16,"Set",function()
        local str = edittext:GetValue()
        if #str == 0 then
            REALISTICVHSEFFECT2_CFG.testtable = nil
        else
            REALISTICVHSEFFECT2_CFG.testtable = Material(str)
        end
    end)
    menu_addbutton(frame,192,64,32,16,"Clear",function()
        edittext:SetValue("")
        REALISTICVHSEFFECT2_CFG.testtable = nil
    end)
end)
concommand.Add("realisticvhseffect2_osdmenu",function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("RealisticVHSEffect2 OSD Menu")
    frame:SetSize(512,512)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
    end
    menu_addcheckbox(frame,8,32,448,32,"Date Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.osd.dateenabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.osd.dateenabled) end)
    local datepostbl = {"LEFTTOP","RIGHTTOP","LEFTDOWN","RIGHTDOWN"}
    menu_addcombobox(frame,8,64,64,96,16,"Date Pos",datepostbl[REALISTICVHSEFFECT2_CFG.osd.datepos],datepostbl,function(_,ind)REALISTICVHSEFFECT2_CFG.osd.datepos = ind end)

    local scrollpanel = vgui.Create("DScrollPanel",frame)
    scrollpanel:SetPos(8,96)
    scrollpanel:SetSize(128,256)
    local function rebuildlist()
        frame:Close()
        RunConsoleCommand("realisticvhseffect2_osdmenu","")
    end
    for k,v in pairs(REALISTICVHSEFFECT2_CFG.osd.datetbl) do
        local fragmentpanel = scrollpanel:Add("DPanel")
        fragmentpanel:Dock(TOP)
        fragmentpanel:DockMargin(0,0,0,5)
        local fragmentbutton = vgui.Create("DButton",fragmentpanel)
        fragmentbutton:SetPos(62,0)
        fragmentbutton:SetSize(52,26)
        if REALISTICVHSEFFECT2_CFG.osd.datesamples[v] then
            fragmentbutton:SetText(REALISTICVHSEFFECT2_CFG.osd.datesamples[v] or "None")
        else
            if v == "\n" then
                fragmentbutton:SetText("NewLine")
            else
                fragmentbutton:SetText(v)
            end
        end
        fragmentbutton.DoClick = function(self)
            local _,cy = self:CursorPos()
            if cy < 13 then
                if k > 1 then
                    local oldval = REALISTICVHSEFFECT2_CFG.osd.datetbl[k-1]
                    REALISTICVHSEFFECT2_CFG.osd.datetbl[k-1] = v
                    REALISTICVHSEFFECT2_CFG.osd.datetbl[k] = oldval
                    rebuildlist()
                end
            else
                if k < #REALISTICVHSEFFECT2_CFG.osd.datetbl then
                    local oldval = REALISTICVHSEFFECT2_CFG.osd.datetbl[k+1]
                    REALISTICVHSEFFECT2_CFG.osd.datetbl[k+1] = v
                    REALISTICVHSEFFECT2_CFG.osd.datetbl[k] = oldval
                    rebuildlist()
                end
            end
        end
        local fragmentbuttonclose = vgui.Create("DButton",fragmentpanel)
        fragmentbuttonclose:SetPos(0,0)
        fragmentbuttonclose:SetSize(26,26)
        fragmentbuttonclose:SetText("X")
        fragmentbuttonclose.DoClick = function()
            table.remove(REALISTICVHSEFFECT2_CFG.osd.datetbl,k)
            rebuildlist()
        end
    end
    local scrollpanel2 = vgui.Create("DScrollPanel",frame)
    scrollpanel2:SetPos(144,96)
    scrollpanel2:SetSize(128,256)
    for k,v in pairs(REALISTICVHSEFFECT2_CFG.osd.fixsize) do
        local fragmentpanel = scrollpanel2:Add("DPanel")
        fragmentpanel:Dock(TOP)
        fragmentpanel:DockMargin(0,0,0,5)
        local fragmentbutton = vgui.Create("DButton",fragmentpanel)
        fragmentbutton:SetPos(62,0)
        fragmentbutton:SetSize(52,26)
        fragmentbutton:SetText(k)
        fragmentbutton.DoClick = function(self)
            local frame2 = vgui.Create("DFrame")
            frame2:SetTitle("RealisticVHSEffect2 Size Editor")
            frame2:SetSize(256,128)
            frame2:Center()
            frame2:MakePopup()
            frame2.Paint = function(self,w,h)
                draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
                draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
            end
            menu_addlabel(frame2,4,32,64,32,"space")
            local edittext = vgui.Create("DTextEntry",frame2)
            edittext:SetPos(64,32)
            edittext:SetSize(192,32)
            edittext:SetText(tostring(v[1]))
            menu_addlabel(frame2,4,64,64,32,"number")
            local edittext2 = vgui.Create("DTextEntry",frame2)
            edittext2:SetPos(64,64)
            edittext2:SetSize(192,32)
            edittext2:SetText(tostring(v[2]))
            menu_addbutton(frame2,64,96,192,32,"Set",function()
                REALISTICVHSEFFECT2_CFG.osd.fixsize[k] = {edittext:GetValue(),tonumber(edittext2:GetValue()) or 0}
            end)
        end
        local fragmentbuttonclose = vgui.Create("DButton",fragmentpanel)
        fragmentbuttonclose:SetPos(0,0)
        fragmentbuttonclose:SetSize(26,26)
        fragmentbuttonclose:SetText("X")
        fragmentbuttonclose.DoClick = function()
            REALISTICVHSEFFECT2_CFG.osd.fixsize[k] = nil
            rebuildlist()
        end
    end
    local datesamples = {}
    for k,v in pairs(REALISTICVHSEFFECT2_CFG.osd.datesamples) do
        datesamples[k] = "[" .. string.Replace(string.TrimLeft(tostring(k),"%",""),"\n","") .. "] " .. v
    end
    menu_addcombobox(frame,8,424,96,96,16,"Add Fragment","Select Sample",datesamples,function(_,ind,val)
        local sampleval = nil

        local strS = string.find(val,"] ")
        if not strS then return end
        local sval = string.sub(val,strS+2)
        for k,v in pairs(REALISTICVHSEFFECT2_CFG.osd.datesamples) do
            if v == sval then
                sampleval = k
            end
        end
        if sampleval then
        REALISTICVHSEFFECT2_CFG.osd.datetbl[#REALISTICVHSEFFECT2_CFG.osd.datetbl+1] = sampleval
        rebuildlist() end end)
    local edittext = vgui.Create("DTextEntry",frame)
    edittext:SetPos(8,456)
    edittext:SetSize(192,16)
    edittext:SetText("")
    menu_addbutton(frame,202,456,32,16,"Add",function()
        local str = edittext:GetValue()
        if #str > 0 then
            REALISTICVHSEFFECT2_CFG.osd.datetbl[#REALISTICVHSEFFECT2_CFG.osd.datetbl+1] = str
            rebuildlist()
        end
    end)
    menu_addbutton(frame,256,456,32,16,"Reset",function()
        frame:Close()
        RunConsoleCommand("realisticvhseffect2_resetosd","openosdmenu")
    end)
    menu_addbutton(frame,320,216,64,16,"Set CurTime",function()
        local osdatereturn = os.date("*t")
        REALISTICVHSEFFECT2_CFG.osd.hours = osdatereturn.hour
        REALISTICVHSEFFECT2_CFG.osd.minutes = osdatereturn.min
        REALISTICVHSEFFECT2_CFG.osd.seconds = osdatereturn.sec
        REALISTICVHSEFFECT2_CFG.osd.days = osdatereturn.day
        REALISTICVHSEFFECT2_CFG.osd.months = osdatereturn.month
        REALISTICVHSEFFECT2_CFG.osd.years = osdatereturn.year
        rebuildlist()
    end)
    menu_addcheckbox(frame,320,232,448,32,"Auto set to CurTime",function(_,value) REALISTICVHSEFFECT2_CFG_osdautocurtime:SetBool(value) end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG_osdautocurtime:GetBool()) end)
    menu_addnumwang(frame,320,96,64,64,16,"Years",0,9999,REALISTICVHSEFFECT2_CFG.osd.years,function(self)REALISTICVHSEFFECT2_CFG.osd.years = self:GetValue() end)
    menu_addnumwang(frame,320,116,64,64,16,"Months",1,12,REALISTICVHSEFFECT2_CFG.osd.months,function(self)REALISTICVHSEFFECT2_CFG.osd.months = self:GetValue() end)
    menu_addnumwang(frame,320,136,64,64,16,"Days",1,31,REALISTICVHSEFFECT2_CFG.osd.days,function(self)REALISTICVHSEFFECT2_CFG.osd.days = self:GetValue() end)
    menu_addnumwang(frame,320,156,64,64,16,"Hours",1,24,REALISTICVHSEFFECT2_CFG.osd.hours,function(self)REALISTICVHSEFFECT2_CFG.osd.hours = self:GetValue() end)
    menu_addnumwang(frame,320,176,64,64,16,"Minutes",0,59,REALISTICVHSEFFECT2_CFG.osd.minutes,function(self)REALISTICVHSEFFECT2_CFG.osd.minutes = self:GetValue() end)
    menu_addnumwang(frame,320,196,64,64,16,"Seconds",9,59,REALISTICVHSEFFECT2_CFG.osd.seconds,function(self)REALISTICVHSEFFECT2_CFG.osd.seconds = self:GetValue() end)
    menu_addlabel(frame,196,32,256,64,"Use X to remove elements and click the buttons\nat the top and bottom with the fragment name\nto change. Add fragments using samples or\ncreate your own.")
    menu_addlabel(frame,8,464,128,32,"Middle Text")
    local edittext2 = vgui.Create("DTextEntry",frame)
    edittext2:SetPos(8,488)
    edittext2:SetSize(192,16)
    edittext2:SetText(REALISTICVHSEFFECT2_CFG.osd.middletext or "")
    menu_addbutton(frame,202,488,32,16,"Set",function()
        local str = edittext2:GetValue()
        if #str > 0 then
            REALISTICVHSEFFECT2_CFG.osd.middletext = str
        else
            REALISTICVHSEFFECT2_CFG.osd.middletext = nil
        end
    end)
    local edittext3 = vgui.Create("DTextEntry",frame)
    edittext3:SetPos(144,364)
    edittext3:SetSize(128,16)
    edittext3:SetText("")
    menu_addbutton(frame,272,364,32,16,"Add",function()
        local str = edittext3:GetValue()
        if #str > 0 then
            REALISTICVHSEFFECT2_CFG.osd.fixsize[str] = {"0",0}
            rebuildlist()
        end
    end)
    menu_addcheckbox(frame,320,264,448,32,"VCR Text",function(_,value)REALISTICVHSEFFECT2_CFG.osd.vcr_text_enabled=value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.osd.vcr_text_enabled)end)
    local edittext4 = vgui.Create("DTextEntry",frame)
    edittext4:SetPos(320,280)
    edittext4:SetSize(128,16)
    edittext4:SetText(REALISTICVHSEFFECT2_CFG.osd.vcr_text)
    edittext4.OnChange = function(self)
        REALISTICVHSEFFECT2_CFG.osd.vcr_text = self:GetValue()
    end
end)
concommand.Add("realisticvhseffect2_resetall",function(_,_,args,argsStr)
    if string.find(argsStr or "","force",0,-1) then
        REALISTICVHSEFFECT2_CFG = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT)
        return
    end
    local frame = vgui.Create("DFrame")
    frame:SetTitle("RealisticVHSEffect2")
    frame:SetSize(256,128)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
    end
    frame.btnMinim:Hide(true)
    frame.btnMaxim:Hide(true)
    menu_addlabel(frame,32,32,192,32,"Do you want to reset all settings?")
    menu_addbutton(frame,32,64,64,64,"No",function()
        frame:Close()
    end)
    menu_addbutton(frame,192,64,32,32,"Yes",function()
        frame:Close()
        RunConsoleCommand("realisticvhseffect2_resetall","force")
    end)
end)
concommand.Add("realisticvhseffect2_resetosd",function(_,_,args,argsStr)
    if string.find(argsStr or "","force",0,-1) then
        REALISTICVHSEFFECT2_CFG.osd = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.osd)
        return
    end
    local frame = vgui.Create("DFrame")
    frame:SetTitle("RealisticVHSEffect2")
    frame:SetSize(256,128)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
    end
    frame.btnMinim:Hide(true)
    frame.btnMaxim:Hide(true)
    menu_addlabel(frame,32,32,192,32,"Do you want to reset all OSD settings?")
    menu_addbutton(frame,32,64,64,64,"No",function()
        frame:Close()
        if string.find(argsStr or "","openosdmenu",0,-1) then
           RunConsoleCommand("realisticvhseffect2_osdmenu")
        end
    end)
    menu_addbutton(frame,192,64,32,32,"Yes",function()
        frame:Close()
        RunConsoleCommand("realisticvhseffect2_resetosd","force")
        if string.find(argsStr or "","openosdmenu",0,-1) then
           RunConsoleCommand("realisticvhseffect2_osdmenu")
        end
    end)
end)
concommand.Add("realisticvhseffect2_menu",function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("RealisticVHSEffect2 Menu")
    frame:SetSize(512,512)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(64,64,64))
        draw.RoundedBox(6,0,0,w,25,Color(127,127,127))
    end
    local mainscrollpanel = vgui.Create("DCategoryList",frame)
    mainscrollpanel:Dock( FILL )
    mainscrollpanel.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(64,64,64))
    end
    menu_addcheckbox(mainscrollpanel,8,6,96,32,"Enabled",function(_,value)REALISTICVHSEFFECT2_CFG_enabled:SetBool(value) end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG_enabled:GetBool()) end)
    menu_addcheckbox(mainscrollpanel,8,28,96,32,"Disable on map load",function(_,value)REALISTICVHSEFFECT2_CFG_autodisable:SetBool(value) end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG_autodisable:GetBool()) end)
    menu_addbutton(mainscrollpanel,0,38,512,16,"SaveCFG",function()
        RunConsoleCommand("realisticvhseffect2_savecfg")
    end)
    menu_addbutton(mainscrollpanel,0,38,512,16,"Reset all",function()
        RunConsoleCommand("realisticvhseffect2_resetall")
    end)
    menu_addbutton(mainscrollpanel,0,70,512,16,"LoadCFG",function()
        RunConsoleCommand("realisticvhseffect2_loadcfg")
    end)
    local prerendercategory = menu_addcategory(mainscrollpanel,8,8,496,196,"Pre-Render",false)
        menu_addbutton(prerendercategory,8,28,128,16,"Set Test Table",function()
            RunConsoleCommand("realisticvhseffect2_testtablemenu","")
        end)
        local hookclasstbl = {"RenderScreenspaceEffects","PostDrawHUD","DrawOverlay"}
        menu_addcombobox(prerendercategory,8,60,96,64,16,"Hook class",REALISTICVHSEFFECT2_CFG.currenthookclass,hookclasstbl,function(_,ind) RunConsoleCommand("realisticvhseffect2_changehook",hookclasstbl[ind]) end)
        menu_addcheckbox(prerendercategory,8,76,96,16,"Equalize sound",function(_,value)REALISTICVHSEFFECT2_CFG_dspenabled:SetBool(value) end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG_dspenabled:GetBool()) end)
        menu_addcheckbox(prerendercategory,8,92,96,16,"Pre-size",function(_,value)REALISTICVHSEFFECT2_CFG.presize = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.presize) end)
        local prerendercategory_lensclr = menu_addcategory(prerendercategory,8,132,472,16,"Lens Colour Distortion",false)
            menu_addbutton(prerendercategory_lensclr,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.cameraclrdist = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.cameraclrdist)
            end)
            menu_addslider(prerendercategory_lensclr,16,52,448,32,"R Distance",-32,32,0,function(slider,value) REALISTICVHSEFFECT2_CFG.cameraclrdist.r = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.cameraclrdist.r) end)
            menu_addslider(prerendercategory_lensclr,16,84,448,32,"G Distance",-32,32,0,function(slider,value) REALISTICVHSEFFECT2_CFG.cameraclrdist.g = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.cameraclrdist.g) end)
            menu_addslider(prerendercategory_lensclr,16,116,448,32,"B Distance",-32,32,0,function(slider,value) REALISTICVHSEFFECT2_CFG.cameraclrdist.b = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.cameraclrdist.b) end)
    local mainrendercategory = menu_addcategory(mainscrollpanel,8,8,496,196,"Main-Render",false)
        menu_addbutton(mainrendercategory,8,28,128,16,"OSD Menu",function()
            RunConsoleCommand("realisticvhseffect2_osdmenu","")
        end)
        menu_addcheckbox(mainrendercategory,16,60,448,16,"Interlacing",function(_,value) REALISTICVHSEFFECT2_CFG.interlaced.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.interlaced.enabled) end)
        menu_addslider(mainrendercategory,16,76,448,16,"Interlacing blending",0.01,1,3,function(slider,value) REALISTICVHSEFFECT2_CFG.interlaced.blend = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.interlaced.blend) end)
        local mainrendercategory_comets = menu_addcategory(mainrendercategory,8,92,472,16,"Comets",false)
            menu_addbutton(mainrendercategory_comets,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.comets = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.comets)
            end)
            menu_addcheckbox(mainrendercategory_comets,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.comets.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.comets.enabled) end)
            menu_addslider(mainrendercategory_comets,16,84,448,32,"Factor",1,100000,0,function(slider,value) REALISTICVHSEFFECT2_CFG.comets.factor = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.comets.factor) end)
            menu_addslider(mainrendercategory_comets,16,116,448,32,"Size",0.125,1,3,function(slider,value) REALISTICVHSEFFECT2_CFG.comets.size = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.comets.size) end)
        local mainrendercategory_horizontalsync = menu_addcategory(mainrendercategory,8,132,472,16,"Horizontal Synchronization",false)
            menu_addbutton(mainrendercategory_horizontalsync,8,36,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.wave = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.wave)
                REALISTICVHSEFFECT2_CFG.lines = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.lines)
            end)
            local mainrendercategory_horizontalsync_wave = menu_addcategory(mainrendercategory_horizontalsync,8,52,472,16,"Wave",false)
                menu_addbutton(mainrendercategory_horizontalsync_wave,8,36,128,16,"Reset to defaults",function()
                    REALISTICVHSEFFECT2_CFG.wave = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.wave)
                end)
                menu_addcheckbox(mainrendercategory_horizontalsync_wave,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.wave.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wave.enabled) end)
                menu_addslider(mainrendercategory_horizontalsync_wave,16,84,448,32,"Frequency",1,500,0,function(slider,value) REALISTICVHSEFFECT2_CFG.wave.freq = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wave.freq) end)
                menu_addslider(mainrendercategory_horizontalsync_wave,16,116,448,32,"Detail",1,10,0,function(slider,value) REALISTICVHSEFFECT2_CFG.wave.detail = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wave.detail) end)
                menu_addslider(mainrendercategory_horizontalsync_wave,16,148,448,32,"Amplitude",0,25,6,function(slider,value) REALISTICVHSEFFECT2_CFG.wave.amp = value*2 end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wave.amp/2) end)
                menu_addslider(mainrendercategory_horizontalsync_wave,16,180,448,32,"Noise",0,50,0,function(slider,value) REALISTICVHSEFFECT2_CFG.wave.noise = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wave.noise) end)
            local mainrendercategory_horizontalsync_lines = menu_addcategory(mainrendercategory_horizontalsync,8,84,472,16,"Lines",false)
                menu_addbutton(mainrendercategory_horizontalsync_lines,8,36,128,16,"Reset to defaults",function()
                    REALISTICVHSEFFECT2_CFG.lines = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.lines)
                end)
                menu_addcheckbox(mainrendercategory_horizontalsync_lines,16,52,448,16,"Lines Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.lines.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.enabled) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,68,448,16,"Lines General Amplitude",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.amp = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.amp) end)
                menu_addcheckbox(mainrendercategory_horizontalsync_lines,16,84,448,16,"Upper Line Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.lines.upperline.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.upperline.enabled) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,100,448,16,"Upper Line Height",1,128,0,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.upperline.height = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.upperline.height) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,116,448,16,"Upper Line Scale",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.upperline.scale = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.upperline.scale) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,132,448,16,"Upper Line Noise",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.upperline.noise = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.upperline.noise) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,148,448,16,"Upper Line Random Amplitude",0,8,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.upperline.randamp = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.upperline.randamp) end)
                menu_addcheckbox(mainrendercategory_horizontalsync_lines,16,164,448,16,"Bottom Line Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.enabled) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,180,448,16,"Bottom Line Height",1,128,0,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.height = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.height) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,196,448,16,"Bottom Line Scale",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.amp = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.amp) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,212,448,16,"Bottom Line Noise",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.noise = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.noise) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,228,448,16,"Bottom Line Random Amplitude",0,8,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.randamp = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.randamp) end)
                    menu_addslider(mainrendercategory_horizontalsync_lines,32,244,448,16,"Bottom Line Random Colour",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.lines.bottomline.randclr = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.lines.bottomline.randclr) end)
        local mainrendercategory_sharpen = menu_addcategory(mainrendercategory,8,172,472,16,"Sharpen",false)
            menu_addbutton(mainrendercategory_sharpen,8,36,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.sharpen = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.sharpen)
            end)
            menu_addcheckbox(mainrendercategory_sharpen,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.sharpen.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.sharpen.enabled) end)
            menu_addslider(mainrendercategory_sharpen,16,84,448,32,"Size",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.sharpen.size = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.sharpen.size) end)
            menu_addslider(mainrendercategory_sharpen,16,116,448,32,"Value",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.sharpen.value = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.sharpen.value) end)
        local mainrendercategory_channelsettings = menu_addcategory(mainrendercategory,8,212,472,16,"Channel Settings",false)
            menu_addbutton(mainrendercategory_channelsettings,8,36,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.channelssettings = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings)
            end)
            menu_addslider(mainrendercategory_channelsettings,16,52,448,32,"General Blur X",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.general_blur = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.general_blur) end)
            menu_addslider(mainrendercategory_channelsettings,16,84,448,32,"Chroma Blur X",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_blur = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_blur) end)
            menu_addslider(mainrendercategory_channelsettings,16,116,448,32,"Chroma Offset X",-100,100,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_offsetx = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_offsetx) end)
            menu_addslider(mainrendercategory_channelsettings,16,148,448,32,"Chroma Offset Y",-100,100,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_offsety = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_offsety) end)
            local mainrendercategory_channelsettings_luma_noise = menu_addcategory(mainrendercategory_channelsettings,8,180,472,16,"Luma Noise",false)
                menu_addbutton(mainrendercategory_channelsettings_luma_noise,8,36,128,16,"Reset to defaults",function()
                    REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_alpha = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.luma_noise_alpha
                    REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_enabled = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.luma_noise_enabled
                    REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scalex = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.luma_noise_scalex
                    REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scaley = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.luma_noise_scaley
                end)
                menu_addcheckbox(mainrendercategory_channelsettings_luma_noise,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_enabled) end)
                menu_addslider(mainrendercategory_channelsettings_luma_noise,16,84,448,32,"Scale X",1,20,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scalex = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scalex) end)
                menu_addslider(mainrendercategory_channelsettings_luma_noise,16,100,448,32,"Scale Y",1,20,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scaley = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_scaley) end)
                menu_addslider(mainrendercategory_channelsettings_luma_noise,16,116,448,32,"Alpha",0,1,3,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_alpha = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.luma_noise_alpha) end)
            local mainrendercategory_channelsettings_chroma_noise = menu_addcategory(mainrendercategory_channelsettings,8,212,472,16,"Chroma Noise",false)
                menu_addbutton(mainrendercategory_channelsettings_chroma_noise,8,36,128,16,"Reset to defaults",function()
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_alpha = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_noise_alpha
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_noise_enabled
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scalex = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_noise_scalex
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scaley = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_noise_scaley
                end)
                menu_addcheckbox(mainrendercategory_channelsettings_chroma_noise,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_enabled) end)
                menu_addslider(mainrendercategory_channelsettings_chroma_noise,16,84,448,32,"Scale X",1,20,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scalex = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scalex) end)
                menu_addslider(mainrendercategory_channelsettings_chroma_noise,16,100,448,32,"Scale Y",1,20,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scaley = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_scaley) end)
                menu_addslider(mainrendercategory_channelsettings_chroma_noise,16,116,448,32,"Alpha",0,1,3,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_alpha = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_noise_alpha) end)
            local mainrendercategory_channelsettings_chroma_drops = menu_addcategory(mainrendercategory_channelsettings,8,244,472,16,"Chroma Drops",false)
                menu_addbutton(mainrendercategory_channelsettings_chroma_drops,8,36,128,16,"Reset to defaults",function()
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_line_drop
                    REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop_maxdrops = REALISTICVHSEFFECT2_CFG_DEFAULT.channelssettings.chroma_line_drop_maxdrops
                end)
                menu_addcheckbox(mainrendercategory_channelsettings_chroma_drops,16,52,448,32,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop) end)
                menu_addslider(mainrendercategory_channelsettings_chroma_drops,16,84,448,32,"Max Drops In Frame",1,20,2,function(slider,value) REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop_maxdrops = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.channelssettings.chroma_line_drop_maxdrops) end)
        local mainrendercategory_videofader = menu_addcategory(mainrendercategory,8,252,472,16,"Video Fader",false)
            menu_addbutton(mainrendercategory_videofader,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.videofader = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.videofader)
            end)
            menu_addcheckbox(mainrendercategory_videofader,16,52,448,16,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.videofader.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.enabled) end)
            local videofaderanimstbl = {"None","Fade-in","Fade-out"}
            menu_addcombobox(mainrendercategory_videofader,8,84,96,64,16,"Animation",videofaderanimstbl[REALISTICVHSEFFECT2_CFG.videofader.anim+1],videofaderanimstbl,function(_,ind) REALISTICVHSEFFECT2_CFG.videofader.anim = ind-1 end)
            menu_addslider(mainrendercategory_videofader,16,116,448,32,"Animation speed",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.videofader.animspeed = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.animspeed) end)
            menu_addslider(mainrendercategory_videofader,16,148,448,32,"Alpha",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.videofader.alpha = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.alpha) end)
            menu_addslider(mainrendercategory_videofader,16,180,448,32,"Colour R",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.videofader.r = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.r) end)
            menu_addslider(mainrendercategory_videofader,16,212,448,32,"Colour G",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.videofader.g = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.g) end)
            menu_addslider(mainrendercategory_videofader,16,244,448,32,"Colour B",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.videofader.b = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.videofader.b) end)
        local mainrendercategory_wrinkle = menu_addcategory(mainrendercategory,8,284,472,16,"Wrinkle",false)
            menu_addbutton(mainrendercategory_wrinkle,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.wrinkle = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.wrinkle)
            end)
            menu_addcheckbox(mainrendercategory_wrinkle,16,52,448,16,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.wrinkle.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wrinkle.enabled) end)
            menu_addcheckbox(mainrendercategory_wrinkle,16,84,448,16,"Animation enabled",function(_,value) REALISTICVHSEFFECT2_CFG.wrinkle.anim = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wrinkle.anim) end)
            menu_addslider(mainrendercategory_wrinkle,16,116,448,32,"Animation speed",0,10,2,function(slider,value) REALISTICVHSEFFECT2_CFG.wrinkle.animspeed = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wrinkle.animspeed) end)
            menu_addslider(mainrendercategory_wrinkle,16,148,448,32,"Position",-1,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.wrinkle.pos = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wrinkle.pos) end)
            menu_addslider(mainrendercategory_wrinkle,16,180,448,32,"Size",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.wrinkle.size = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.wrinkle.size) end)
        local mainrendercategory_noise_overlay = menu_addcategory(mainrendercategory,8,316,472,16,"Noise Overlay",false)
            menu_addbutton(mainrendercategory_noise_overlay,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.noise_overlay = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.noise_overlay)
            end)
            menu_addcheckbox(mainrendercategory_noise_overlay,16,52,448,16,"Enabled",function(_,value) REALISTICVHSEFFECT2_CFG.noise_overlay.enabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.noise_overlay.enabled) end)
            menu_addcheckbox(mainrendercategory_noise_overlay,16,68,448,16,"Gap enabled",function(_,value) REALISTICVHSEFFECT2_CFG.noise_overlay.gapenabled = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.noise_overlay.gapenabled) end)
            menu_addcheckbox(mainrendercategory_noise_overlay,16,84,448,16,"Gap animation enabled",function(_,value) REALISTICVHSEFFECT2_CFG.noise_overlay.gapanim = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.noise_overlay.gapanim) end)
            menu_addslider(mainrendercategory_noise_overlay,16,100,448,32,"Gap size",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.noise_overlay.gapsize = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.noise_overlay.gapsize) end)
            menu_addslider(mainrendercategory_noise_overlay,16,132,448,32,"Gap position",0,1,2,function(slider,value) REALISTICVHSEFFECT2_CFG.noise_overlay.gappos = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.noise_overlay.gappos) end)

    local postrendercategory = menu_addcategory(mainscrollpanel,8,204,496,196,"Post-Render",false)
        local viewtypetbl = {[0] = "Full-Screen",[1] = "ReSize-4:3",[2] = "Crop-4:3"}
        menu_addcombobox(postrendercategory,32,32,64,96,16,"ViewType",viewtypetbl[REALISTICVHSEFFECT2_CFG.viewtype],viewtypetbl,function(_,ind) REALISTICVHSEFFECT2_CFG.viewtype = ind-1 end)
        local postrendercategory_clrmod = menu_addcategory(postrendercategory,32,56,472,16,"Colour Mod",false)
            menu_addbutton(postrendercategory_clrmod,8,28,128,16,"Reset to defaults",function()
                REALISTICVHSEFFECT2_CFG.postclrmod = table.Copy(REALISTICVHSEFFECT2_CFG_DEFAULT.postclrmod)
            end)
            menu_addslider(postrendercategory_clrmod,8,48,448,32,"AddR",0,1,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addr = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addr)end)
            menu_addslider(postrendercategory_clrmod,8,80,448,32,"AddG",0,1,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addg = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addg)end)
            menu_addslider(postrendercategory_clrmod,8,112,448,32,"AddB",0,1,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addb = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_addb)end)
            menu_addslider(postrendercategory_clrmod,8,144,448,32,"Brightness",0,1,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_brightness = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_brightness)end)
            menu_addslider(postrendercategory_clrmod,8,176,448,32,"Colour",0,1,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_colour = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_colour)end)
            menu_addslider(postrendercategory_clrmod,8,208,448,32,"Invert",0,1,0,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_inv = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_inv)end)
            menu_addslider(postrendercategory_clrmod,8,240,448,32,"Contrast",0,2,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_contrast = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_contrast)end)
            menu_addslider(postrendercategory_clrmod,8,272,448,32,"MultiplyR",0,2,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulr = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulr)end)
            menu_addslider(postrendercategory_clrmod,8,304,448,32,"MultiplyG",0,2,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulg = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulg)end)
            menu_addslider(postrendercategory_clrmod,8,336,448,32,"MultiplyB",0,2,2,function(slider,value)REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulb = value end,function(self)self:SetValue(REALISTICVHSEFFECT2_CFG.postclrmod.pp_colour_mulb)end)
end)

hook.Add("AddToolMenuCategories","RealisticVHSEffect2Menu",function()
    spawnmenu.AddToolCategory("Utilities","RealisticVHSEffect2","#RealisticVHSEffect2")
end)
hook.Add("PopulateToolMenu","RealisticVHSEffect2Menu",function()
    spawnmenu.AddToolMenuOption("Utilities","RealisticVHSEffect2","Menu","#RealisticVHSEffect2 Menu","","",function(panel)
        panel:ClearControls()
        local button = vgui.Create("DButton",panel)
        button:Dock(TOP)
        button:SetText("Menu")
        button.DoClick = function()
            RunConsoleCommand("realisticvhseffect2_menu")
        end
    end)
end)



list.Set("PostProcess","Realistic VHS Effect 2",{
    icon = "gui/postprocess/realisticvhseffect2.png",
    convar = "realisticvhseffect2_enabled",
    category = "#effects_pp",
    onclick = function()
        RunConsoleCommand("realisticvhseffect2_menu")
    end
})
