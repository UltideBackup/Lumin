local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LuminUI = {}
LuminUI.__index = LuminUI

local Themes = {
    Dark = {
        Background = Color3.fromRGB(12, 12, 16),
        Surface = Color3.fromRGB(20, 20, 28),
        SurfaceVariant = Color3.fromRGB(28, 28, 38),
        Primary = Color3.fromRGB(99, 102, 241),
        PrimaryHover = Color3.fromRGB(129, 132, 255),
        Secondary = Color3.fromRGB(45, 45, 58),
        Accent = Color3.fromRGB(244, 63, 94),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(186, 189, 201),
        TextTertiary = Color3.fromRGB(124, 127, 140),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(239, 68, 68),
        Border = Color3.fromRGB(38, 38, 48),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Light = {
        Background = Color3.fromRGB(248, 250, 252),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceVariant = Color3.fromRGB(241, 245, 249),
        Primary = Color3.fromRGB(59, 130, 246),
        PrimaryHover = Color3.fromRGB(37, 99, 235),
        Secondary = Color3.fromRGB(226, 232, 240),
        Accent = Color3.fromRGB(244, 63, 94),
        Text = Color3.fromRGB(15, 23, 42),
        TextSecondary = Color3.fromRGB(71, 85, 105),
        TextTertiary = Color3.fromRGB(148, 163, 184),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(239, 68, 68),
        Border = Color3.fromRGB(226, 232, 240),
        Shadow = Color3.fromRGB(30, 41, 59)
    }
}

local Config = {
    Theme = Themes.Dark,
    Animation = {
        Fast = 0.12,
        Normal = 0.2,
        Slow = 0.35,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out,
        Spring = Enum.EasingStyle.Back
    },
    Sizes = {
        Corner = UDim.new(0, 12),
        SmallCorner = UDim.new(0, 6),
        ButtonHeight = 40,
        SmallButtonHeight = 32,
        Padding = 20,
        Spacing = 12,
        SectionSpacing = 20
    },
    Effects = {
        GlowIntensity = 0.5,
        ShadowOpacity = 0.25,
        BlurSize = 8
    }
}

local function tween(object, properties, duration, style, direction)
    duration = duration or Config.Animation.Normal
    style = style or Config.Animation.Style
    direction = direction or Config.Animation.Direction
    local info = TweenInfo.new(duration, style, direction)
    return TweenService:Create(object, info, properties)
end

local function springTween(object, properties, duration)
    duration = duration or Config.Animation.Normal
    local info = TweenInfo.new(duration, Config.Animation.Spring, Config.Animation.Direction)
    return TweenService:Create(object, info, properties)
end

local function corner(radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Config.Sizes.Corner
    return c
end

local function glow(parent, color, intensity)
    local g = Instance.new("ImageLabel")
    g.Name = "Glow"
    g.Parent = parent
    g.BackgroundTransparency = 1
    g.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    g.ImageColor3 = color or Config.Theme.Primary
    g.ImageTransparency = 1 - (intensity or Config.Effects.GlowIntensity)
    g.ScaleType = Enum.ScaleType.Slice
    g.SliceCenter = Rect.new(49, 49, 450, 450)
    g.Size = UDim2.new(1, 50, 1, 50)
    g.Position = UDim2.new(0, -25, 0, -25)
    g.ZIndex = parent.ZIndex - 1
    return g
end

local function shadow(parent, intensity)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.Parent = parent
    s.BackgroundTransparency = 1
    s.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    s.ImageColor3 = Config.Theme.Shadow
    s.ImageTransparency = intensity or Config.Effects.ShadowOpacity
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.Size = UDim2.new(1, 40, 1, 40)
    s.Position = UDim2.new(0, -20, 0, -20)
    s.ZIndex = parent.ZIndex - 1
    return s
end

local function gradient(parent, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Parent = parent
    g.Color = colors or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Config.Theme.Primary),
        ColorSequenceKeypoint.new(1, Config.Theme.Accent)
    }
    g.Rotation = rotation or 45
    return g
end

local function stroke(parent, thickness, color)
    local s = Instance.new("UIStroke")
    s.Parent = parent
    s.Thickness = thickness or 1
    s.Color = color or Config.Theme.Border
    s.Transparency = 0.4
    return s
end

local function padding(parent, amount)
    local p = Instance.new("UIPadding")
    p.Parent = parent
    p.PaddingTop = UDim.new(0, amount or 10)
    p.PaddingBottom = UDim.new(0, amount or 10)
    p.PaddingLeft = UDim.new(0, amount or 12)
    p.PaddingRight = UDim.new(0, amount or 12)
    return p
end

function LuminUI:CreateWindow(options)
    options = options or {}
    local window = {}
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "LuminUI"
    gui.Parent = PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    local blur = Instance.new("BlurEffect")
    blur.Parent = game.Lighting
    blur.Size = 0
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = gui
    main.BackgroundColor3 = Config.Theme.Background
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.Size = options.Size or UDim2.new(0, 560, 0, 440)
    main.Position = UDim2.new(0.5, -280, 0.5, -220)
    main.ZIndex = 10
    corner(main)
    shadow(main, 0.15)
    stroke(main, 1, Config.Theme.Border)
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = main
    titleBar.BackgroundColor3 = Config.Theme.Surface
    titleBar.BackgroundTransparency = 0.02
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.ZIndex = 11
    corner(titleBar)
    stroke(titleBar, 1, Config.Theme.Border)
    
    local titleGrad = Instance.new("Frame")
    titleGrad.Name = "Gradient"
    titleGrad.Parent = titleBar
    titleGrad.BackgroundColor3 = Config.Theme.Primary
    titleGrad.BackgroundTransparency = 0.92
    titleGrad.BorderSizePixel = 0
    titleGrad.Size = UDim2.new(1, 0, 1, 0)
    titleGrad.ZIndex = 12
    corner(titleGrad)
    gradient(titleGrad)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = options.Title or "LuminUI"
    title.TextColor3 = Config.Theme.Text
    title.TextSize = 17
    title.Position = UDim2.new(0, 20, 0, 0)
    title.Size = UDim2.new(1, -100, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 13
    
    if options.Subtitle then
        local subtitle = Instance.new("TextLabel")
        subtitle.Name = "Subtitle"
        subtitle.Parent = titleBar
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.Text = options.Subtitle
        subtitle.TextColor3 = Config.Theme.TextSecondary
        subtitle.TextSize = 11
        subtitle.Position = UDim2.new(0, 20, 0, 25)
        subtitle.Size = UDim2.new(1, -100, 0, 18)
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.ZIndex = 13
    end
    
    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.Parent = titleBar
    close.BackgroundColor3 = Config.Theme.Error
    close.BackgroundTransparency = 0.85
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.Text = "×"
    close.TextColor3 = Config.Theme.Text
    close.TextSize = 18
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -44, 0.5, -16)
    close.ZIndex = 13
    corner(close, Config.Sizes.SmallCorner)
    
    close.MouseEnter:Connect(function()
        tween(close, {BackgroundTransparency = 0.25}, Config.Animation.Fast):Play()
        tween(close, {Size = UDim2.new(0, 34, 0, 34)}, Config.Animation.Fast):Play()
    end)
    
    close.MouseLeave:Connect(function()
        tween(close, {BackgroundTransparency = 0.85}, Config.Animation.Fast):Play()
        tween(close, {Size = UDim2.new(0, 32, 0, 32)}, Config.Animation.Fast):Play()
    end)
    
    close.MouseButton1Click:Connect(function()
        window:Hide()
    end)
    
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Parent = main
    tabs.BackgroundColor3 = Config.Theme.SurfaceVariant
    tabs.BackgroundTransparency = 0.25
    tabs.BorderSizePixel = 0
    tabs.Size = UDim2.new(0, 180, 1, -55)
    tabs.Position = UDim2.new(0, 0, 0, 55)
    tabs.ZIndex = 11
    corner(tabs)
    stroke(tabs, 1, Config.Theme.Border)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = tabs
    tabList.Padding = UDim.new(0, 6)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    padding(tabs, 14)
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = main
    content.BackgroundColor3 = Config.Theme.Surface
    content.BackgroundTransparency = 0.05
    content.BorderSizePixel = 0
    content.Size = UDim2.new(1, -180, 1, -55)
    content.Position = UDim2.new(0, 180, 0, 55)
    content.ZIndex = 11
    corner(content)
    stroke(content, 1, Config.Theme.Border)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.Parent = content
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Size = UDim2.new(1, -28, 1, -20)
    scroll.Position = UDim2.new(0, 14, 0, 10)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Config.Theme.Primary
    scroll.ScrollBarImageTransparency = 0.25
    scroll.ZIndex = 12
    
    local scrollList = Instance.new("UIListLayout")
    scrollList.Parent = scroll
    scrollList.Padding = UDim.new(0, Config.Sizes.Spacing)
    scrollList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        tween(main, {Position = newPos}, 0.08):Play()
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            tween(main, {Size = main.Size * 1.015}, Config.Animation.Fast):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            tween(main, {Size = options.Size or UDim2.new(0, 560, 0, 440)}, Config.Animation.Fast):Play()
        end
    end)
    
    window.tabs = {}
    window.currentTab = nil
    
    function window:CreateTab(name, icon)
        local tab = {}
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. name
        tabBtn.Parent = tabs
        tabBtn.BackgroundColor3 = Config.Theme.Secondary
        tabBtn.BackgroundTransparency = 0.25
        tabBtn.BorderSizePixel = 0
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.Text = (icon or "•") .. "  " .. name
        tabBtn.TextColor3 = Config.Theme.TextSecondary
        tabBtn.TextSize = 13
        tabBtn.Size = UDim2.new(1, 0, 0, Config.Sizes.ButtonHeight)
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.ZIndex = 12
        corner(tabBtn, Config.Sizes.SmallCorner)
        padding(tabBtn, 10)
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "TabContent_" .. name
        tabContent.Parent = scroll
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Config.Theme.Primary
        tabContent.ScrollBarImageTransparency = 0.4
        tabContent.Visible = false
        tabContent.ZIndex = 12
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Parent = tabContent
        tabLayout.Padding = UDim.new(0, Config.Sizes.Spacing)
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        tabBtn.MouseEnter:Connect(function()
            if window.currentTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 0.08}, Config.Animation.Fast):Play()
                tween(tabBtn, {TextColor3 = Config.Theme.Text}, Config.Animation.Fast):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if window.currentTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 0.25}, Config.Animation.Fast):Play()
                tween(tabBtn, {TextColor3 = Config.Theme.TextSecondary}, Config.Animation.Fast):Play()
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            window:SelectTab(tab)
        end)
        
        function tab:AddSection(name)
            local section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "Section_" .. name
            sectionFrame.Parent = tabContent
            sectionFrame.BackgroundColor3 = Config.Theme.SurfaceVariant
            sectionFrame.BackgroundTransparency = 0.35
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.ZIndex = 13
            corner(sectionFrame)
            stroke(sectionFrame, 1, Config.Theme.Border)
            padding(sectionFrame, 14)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Parent = sectionFrame
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Config.Theme.Text
            sectionTitle.TextSize = 15
            sectionTitle.Size = UDim2.new(1, 0, 0, 28)
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.ZIndex = 14
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Parent = sectionFrame
            sectionLayout.Padding = UDim.new(0, Config.Sizes.Spacing)
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            function section:AddLabel(text, desc)
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = sectionFrame
                label.BackgroundColor3 = Config.Theme.SurfaceVariant
                label.BackgroundTransparency = 0.35
                label.BorderSizePixel = 0
                label.Font = Enum.Font.Gotham
                label.Text = text
                label.TextColor3 = Config.Theme.TextSecondary
                label.TextSize = 13
                label.Size = UDim2.new(1, 0, 0, desc and 45 or 28)
                label.ZIndex = 14
                label.LayoutOrder = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                corner(label, Config.Sizes.SmallCorner)
                stroke(label, 1, Config.Theme.Border)
                padding(label, 10)
                
                if desc then
                    label.TextYAlignment = Enum.TextYAlignment.Top
                    local d = Instance.new("TextLabel")
                    d.Parent = label
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 0, 0, 18)
                    d.Size = UDim2.new(1, 0, 0, 18)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return label
            end
            
            function section:AddButton(text, desc, callback)
                local button = Instance.new("TextButton")
                button.Name = "Button"
                button.Parent = sectionFrame
                button.BackgroundColor3 = Config.Theme.Secondary
                button.BackgroundTransparency = 0.15
                button.BorderSizePixel = 0
                button.Font = Enum.Font.GothamMedium
                button.Text = text
                button.TextColor3 = Config.Theme.Text
                button.TextSize = 14
                button.Size = UDim2.new(1, 0, 0, Config.Sizes.ButtonHeight)
                button.ZIndex = 14
                button.LayoutOrder = 1
                corner(button, Config.Sizes.SmallCorner)
                stroke(button, 1, Config.Theme.Border)
                glow(button, Config.Theme.Primary, 0)
                
                if desc then
                    button.Size = UDim2.new(1, 0, 0, Config.Sizes.ButtonHeight + 18)
                    local d = Instance.new("TextLabel")
                    d.Parent = button
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 14, 0, 25)
                    d.Size = UDim2.new(1, -28, 0, 18)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                local g = button.Glow
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Config.Theme.Primary}, Config.Animation.Fast):Play()
                    tween(button, {BackgroundTransparency = 0.08}, Config.Animation.Fast):Play()
                    springTween(button, {Size = button.Size + UDim2.new(0, 3, 0, 1)}, Config.Animation.Fast):Play()
                    tween(g, {ImageTransparency = 0.35}, Config.Animation.Fast):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = Config.Theme.Secondary}, Config.Animation.Fast):Play()
                    tween(button, {BackgroundTransparency = 0.15}, Config.Animation.Fast):Play()
                    local originalSize = UDim2.new(1, 0, 0, desc and Config.Sizes.ButtonHeight + 18 or Config.Sizes.ButtonHeight)
                    springTween(button, {Size = originalSize}, Config.Animation.Fast):Play()
                    tween(g, {ImageTransparency = 1}, Config.Animation.Fast):Play()
                end)
                
                if callback then
                    button.MouseButton1Click:Connect(callback)
                end
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return button
            end
            
            function section:AddToggle(text, desc, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "Toggle"
                toggleFrame.Parent = sectionFrame
                toggleFrame.BackgroundColor3 = Config.Theme.Secondary
                toggleFrame.BackgroundTransparency = 0.15
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Size = UDim2.new(1, 0, 0, desc and 58 or Config.Sizes.ButtonHeight)
                toggleFrame.ZIndex = 14
                toggleFrame.LayoutOrder = 1
                corner(toggleFrame, Config.Sizes.SmallCorner)
                stroke(toggleFrame, 1, Config.Theme.Border)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = toggleFrame
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamMedium
                label.Text = text
                label.TextColor3 = Config.Theme.Text
                label.TextSize = 14
                label.Position = UDim2.new(0, 14, 0, 0)
                label.Size = UDim2.new(1, -70, 0, desc and 22 or Config.Sizes.ButtonHeight)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = desc and Enum.TextYAlignment.Bottom or Enum.TextYAlignment.Center
                label.ZIndex = 15
                
                if desc then
                    local d = Instance.new("TextLabel")
                    d.Parent = toggleFrame
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 14, 0, 25)
                    d.Size = UDim2.new(1, -70, 0, 18)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                local toggleBg = Instance.new("Frame")
                toggleBg.Name = "ToggleBg"
                toggleBg.Parent = toggleFrame
                toggleBg.BackgroundColor3 = default and Config.Theme.Success or Config.Theme.Border
                toggleBg.BorderSizePixel = 0
                toggleBg.Size = UDim2.new(0, 44, 0, 22)
                toggleBg.Position = UDim2.new(1, -58, 0.5, -11)
                toggleBg.ZIndex = 15
                corner(toggleBg, UDim.new(0, 11))
                glow(toggleBg, default and Config.Theme.Success or Config.Theme.Border, 0.25)
                
                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "Knob"
                toggleKnob.Parent = toggleBg
                toggleKnob.BackgroundColor3 = Config.Theme.Text
                toggleKnob.BorderSizePixel = 0
                toggleKnob.Size = UDim2.new(0, 18, 0, 18)
                toggleKnob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                toggleKnob.ZIndex = 16
                corner(toggleKnob, UDim.new(0, 9))
                shadow(toggleKnob, 0.3)
                
                local isToggled = default or false
                
                local click = Instance.new("TextButton")
                click.Name = "Click"
                click.Parent = toggleFrame
                click.BackgroundTransparency = 1
                click.Text = ""
                click.Size = UDim2.new(1, 0, 1, 0)
                click.ZIndex = 17
                
                click.MouseEnter:Connect(function()
                    tween(toggleFrame, {BackgroundTransparency = 0.08}, Config.Animation.Fast):Play()
                    springTween(toggleBg, {Size = UDim2.new(0, 46, 0, 24)}, Config.Animation.Fast):Play()
                end)
                
                click.MouseLeave:Connect(function()
                    tween(toggleFrame, {BackgroundTransparency = 0.15}, Config.Animation.Fast):Play()
                    springTween(toggleBg, {Size = UDim2.new(0, 44, 0, 22)}, Config.Animation.Fast):Play()
                end)
                
                click.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    
                    local bgColor = isToggled and Config.Theme.Success or Config.Theme.Border
                    local knobPos = isToggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                    local glowColor = isToggled and Config.Theme.Success or Config.Theme.Border
                    
                    springTween(toggleBg, {BackgroundColor3 = bgColor}, Config.Animation.Normal):Play()
                    springTween(toggleKnob, {Position = knobPos}, Config.Animation.Normal):Play()
                    tween(toggleBg.Glow, {ImageColor3 = glowColor}, Config.Animation.Normal):Play()
                    
                    if callback then
                        callback(isToggled)
                    end
                end)
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return {Frame = toggleFrame, GetValue = function() return isToggled end}
            end
            
            function section:AddSlider(text, desc, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "Slider"
                sliderFrame.Parent = sectionFrame
                sliderFrame.BackgroundColor3 = Config.Theme.Secondary
                sliderFrame.BackgroundTransparency = 0.15
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, desc and 72 or 58)
                sliderFrame.ZIndex = 14
                sliderFrame.LayoutOrder = 1
                corner(sliderFrame, Config.Sizes.SmallCorner)
                stroke(sliderFrame, 1, Config.Theme.Border)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = sliderFrame
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamMedium
                label.Text = text
                label.TextColor3 = Config.Theme.Text
                label.TextSize = 14
                label.Position = UDim2.new(0, 14, 0, 6)
                label.Size = UDim2.new(1, -80, 0, 18)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 15
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.Parent = sliderFrame
                valueLabel.BackgroundTransparency = 1
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Config.Theme.Primary
                valueLabel.TextSize = 14
                valueLabel.Position = UDim2.new(1, -74, 0, 6)
                valueLabel.Size = UDim2.new(0, 60, 0, 18)
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.ZIndex = 15
                
                if desc then
                    local d = Instance.new("TextLabel")
                    d.Parent = sliderFrame
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 14, 0, 28)
                    d.Size = UDim2.new(1, -80, 0, 14)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                local track = Instance.new("Frame")
                track.Name = "Track"
                track.Parent = sliderFrame
                track.BackgroundColor3 = Config.Theme.Border
                track.BorderSizePixel = 0
                track.Size = UDim2.new(1, -28, 0, 5)
                track.Position = UDim2.new(0, 14, 1, desc and -18 or -16)
                track.ZIndex = 15
                corner(track, UDim.new(0, 2))
                
                local fill = Instance.new("Frame")
                fill.Name = "Fill"
                fill.Parent = track
                fill.BackgroundColor3 = Config.Theme.Primary
                fill.BorderSizePixel = 0
                fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                fill.Position = UDim2.new(0, 0, 0, 0)
                fill.ZIndex = 16
                corner(fill, UDim.new(0, 2))
                glow(fill, Config.Theme.Primary, 0.3)
                
                local knob = Instance.new("Frame")
                knob.Name = "Knob"
                knob.Parent = track
                knob.BackgroundColor3 = Config.Theme.Text
                knob.BorderSizePixel = 0
                knob.Size = UDim2.new(0, 14, 0, 14)
                knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
                knob.ZIndex = 17
                corner(knob, UDim.new(0, 7))
                shadow(knob, 0.25)
                
                local currentValue = default
                local dragging = false
                
                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        springTween(knob, {Size = UDim2.new(0, 18, 0, 18)}, Config.Animation.Fast):Play()
                        tween(fill.Glow, {ImageTransparency = 0.15}, Config.Animation.Fast):Play()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        springTween(knob, {Size = UDim2.new(0, 14, 0, 14)}, Config.Animation.Fast):Play()
                        tween(fill.Glow, {ImageTransparency = 0.5}, Config.Animation.Fast):Play()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativePos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                        
                        currentValue = min + (max - min) * relativePos
                        if max - min > 1 then
                            currentValue = math.floor(currentValue)
                        else
                            currentValue = math.floor(currentValue * 100) / 100
                        end
                        
                        valueLabel.Text = tostring(currentValue)
                        tween(fill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.08):Play()
                        tween(knob, {Position = UDim2.new(relativePos, -7, 0.5, -7)}, 0.08):Play()
                        
                        if callback then
                            callback(currentValue)
                        end
                    end
                end)
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return {Frame = sliderFrame, GetValue = function() return currentValue end}
            end
            
            function section:AddDropdown(text, desc, options, default, callback)
                local dropFrame = Instance.new("Frame")
                dropFrame.Name = "Dropdown"
                dropFrame.Parent = sectionFrame
                dropFrame.BackgroundColor3 = Config.Theme.Secondary
                dropFrame.BackgroundTransparency = 0.15
                dropFrame.BorderSizePixel = 0
                dropFrame.Size = UDim2.new(1, 0, 0, desc and 58 or Config.Sizes.ButtonHeight)
                dropFrame.ZIndex = 14
                dropFrame.LayoutOrder = 1
                corner(dropFrame, Config.Sizes.SmallCorner)
                stroke(dropFrame, 1, Config.Theme.Border)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = dropFrame
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamMedium
                label.Text = text
                label.TextColor3 = Config.Theme.Text
                label.TextSize = 14
                label.Position = UDim2.new(0, 14, 0, 0)
                label.Size = UDim2.new(1, -35, 0, desc and 22 or Config.Sizes.ButtonHeight)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = desc and Enum.TextYAlignment.Bottom or Enum.TextYAlignment.Center
                label.ZIndex = 15
                
                if desc then
                    local d = Instance.new("TextLabel")
                    d.Parent = dropFrame
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 14, 0, 25)
                    d.Size = UDim2.new(1, -35, 0, 18)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                local selectedValue = default or options[1] or "None"
                local isOpen = false
                
                local dropBtn = Instance.new("TextButton")
                dropBtn.Name = "Button"
                dropBtn.Parent = dropFrame
                dropBtn.BackgroundColor3 = Config.Theme.SurfaceVariant
                dropBtn.BackgroundTransparency = 0.25
                dropBtn.BorderSizePixel = 0
                dropBtn.Font = Enum.Font.Gotham
                dropBtn.Text = selectedValue .. "  ▼"
                dropBtn.TextColor3 = Config.Theme.Text
                dropBtn.TextSize = 13
                dropBtn.Size = UDim2.new(1, -28, 0, 28)
                dropBtn.Position = UDim2.new(0, 14, 1, desc and -36 or -32)
                dropBtn.TextXAlignment = Enum.TextXAlignment.Left
                dropBtn.ZIndex = 15
                corner(dropBtn, Config.Sizes.SmallCorner)
                padding(dropBtn, 6)
                
                local dropList = Instance.new("ScrollingFrame")
                dropList.Name = "List"
                dropList.Parent = dropFrame
                dropList.BackgroundColor3 = Config.Theme.Surface
                dropList.BorderSizePixel = 0
                dropList.Size = UDim2.new(1, -28, 0, math.min(#options * 32, 128))
                dropList.Position = UDim2.new(0, 14, 1, desc and -6 or -2)
                dropList.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
                dropList.ScrollBarThickness = 3
                dropList.ScrollBarImageColor3 = Config.Theme.Primary
                dropList.Visible = false
                dropList.ZIndex = 20
                corner(dropList, Config.Sizes.SmallCorner)
                shadow(dropList, 0.08)
                stroke(dropList, 1, Config.Theme.Border)
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropList
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                for i, option in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Name = "Option_" .. option
                    optBtn.Parent = dropList
                    optBtn.BackgroundColor3 = Config.Theme.Surface
                    optBtn.BackgroundTransparency = 1
                    optBtn.BorderSizePixel = 0
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.Text = option
                    optBtn.TextColor3 = Config.Theme.TextSecondary
                    optBtn.TextSize = 13
                    optBtn.Size = UDim2.new(1, 0, 0, 32)
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.ZIndex = 21
                    optBtn.LayoutOrder = i
                    padding(optBtn, 6)
                    
                    optBtn.MouseEnter:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 0.75}, Config.Animation.Fast):Play()
                        tween(optBtn, {TextColor3 = Config.Theme.Text}, Config.Animation.Fast):Play()
                    end)
                    
                    optBtn.MouseLeave:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 1}, Config.Animation.Fast):Play()
                        tween(optBtn, {TextColor3 = Config.Theme.TextSecondary}, Config.Animation.Fast):Play()
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        selectedValue = option
                        dropBtn.Text = selectedValue .. "  ▼"
                        isOpen = false
                        tween(dropList, {Size = UDim2.new(1, -28, 0, 0)}, Config.Animation.Normal):Play()
                        wait(Config.Animation.Normal)
                        dropList.Visible = false
                        
                        if callback then
                            callback(selectedValue)
                        end
                    end)
                end
                
                dropBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        dropList.Visible = true
                        tween(dropList, {Size = UDim2.new(1, -28, 0, math.min(#options * 32, 128))}, Config.Animation.Normal):Play()
                        dropBtn.Text = selectedValue .. "  ▲"
                    else
                        tween(dropList, {Size = UDim2.new(1, -28, 0, 0)}, Config.Animation.Normal):Play()
                        dropBtn.Text = selectedValue .. "  ▼"
                        wait(Config.Animation.Normal)
                        dropList.Visible = false
                    end
                end)
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return {Frame = dropFrame, GetValue = function() return selectedValue end}
            end
            
            function section:AddTextBox(text, desc, placeholder, callback)
                local textFrame = Instance.new("Frame")
                textFrame.Name = "TextBox"
                textFrame.Parent = sectionFrame
                textFrame.BackgroundColor3 = Config.Theme.Secondary
                textFrame.BackgroundTransparency = 0.15
                textFrame.BorderSizePixel = 0
                textFrame.Size = UDim2.new(1, 0, 0, desc and 72 or 58)
                textFrame.ZIndex = 14
                textFrame.LayoutOrder = 1
                corner(textFrame, Config.Sizes.SmallCorner)
                stroke(textFrame, 1, Config.Theme.Border)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = textFrame
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamMedium
                label.Text = text
                label.TextColor3 = Config.Theme.Text
                label.TextSize = 14
                label.Position = UDim2.new(0, 14, 0, 6)
                label.Size = UDim2.new(1, -28, 0, 18)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 15
                
                if desc then
                    local d = Instance.new("TextLabel")
                    d.Parent = textFrame
                    d.BackgroundTransparency = 1
                    d.Font = Enum.Font.Gotham
                    d.Text = desc
                    d.TextColor3 = Config.Theme.TextTertiary
                    d.TextSize = 11
                    d.Position = UDim2.new(0, 14, 0, 28)
                    d.Size = UDim2.new(1, -28, 0, 14)
                    d.TextXAlignment = Enum.TextXAlignment.Left
                    d.ZIndex = 15
                end
                
                local textBox = Instance.new("TextBox")
                textBox.Name = "Input"
                textBox.Parent = textFrame
                textBox.BackgroundColor3 = Config.Theme.SurfaceVariant
                textBox.BackgroundTransparency = 0.25
                textBox.BorderSizePixel = 0
                textBox.Font = Enum.Font.Gotham
                textBox.PlaceholderText = placeholder or "Enter text..."
                textBox.PlaceholderColor3 = Config.Theme.TextTertiary
                textBox.Text = ""
                textBox.TextColor3 = Config.Theme.Text
                textBox.TextSize = 13
                textBox.Size = UDim2.new(1, -28, 0, 28)
                textBox.Position = UDim2.new(0, 14, 1, desc and -36 or -32)
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.ZIndex = 15
                corner(textBox, Config.Sizes.SmallCorner)
                stroke(textBox, 1, Config.Theme.Border)
                padding(textBox, 6)
                
                textBox.Focused:Connect(function()
                    tween(textBox, {BackgroundTransparency = 0.08}, Config.Animation.Fast):Play()
                    tween(textBox.UIStroke, {Color = Config.Theme.Primary}, Config.Animation.Fast):Play()
                    tween(textBox.UIStroke, {Thickness = 2}, Config.Animation.Fast):Play()
                end)
                
                textBox.FocusLost:Connect(function()
                    tween(textBox, {BackgroundTransparency = 0.25}, Config.Animation.Fast):Play()
                    tween(textBox.UIStroke, {Color = Config.Theme.Border}, Config.Animation.Fast):Play()
                    tween(textBox.UIStroke, {Thickness = 1}, Config.Animation.Fast):Play()
                    
                    if callback then
                        callback(textBox.Text)
                    end
                end)
                
                tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
                end)
                
                return {Frame = textFrame, GetValue = function() return textBox.Text end, SetValue = function(value) textBox.Text = value end}
            end
            
            return section
        end
        
        tab.button = tabBtn
        tab.content = tabContent
        window.tabs[name] = tab
        
        if not window.currentTab then
            window:SelectTab(tab)
        end
        
        return tab
    end
    
    function window:SelectTab(tab)
        if window.currentTab then
            tween(window.currentTab.button, {BackgroundTransparency = 0.25}, Config.Animation.Normal):Play()
            tween(window.currentTab.button, {TextColor3 = Config.Theme.TextSecondary}, Config.Animation.Normal):Play()
            window.currentTab.content.Visible = false
        end
        
        window.currentTab = tab
        tween(tab.button, {BackgroundTransparency = 0.08}, Config.Animation.Normal):Play()
        tween(tab.button, {BackgroundColor3 = Config.Theme.Primary}, Config.Animation.Normal):Play()
        tween(tab.button, {TextColor3 = Config.Theme.Text}, Config.Animation.Normal):Play()
        tab.content.Visible = true
    end
    
    function window:Show()
        main.Size = UDim2.new(0, 0, 0, 0)
        main.BackgroundTransparency = 1
        tween(blur, {Size = Config.Effects.BlurSize}, Config.Animation.Slow):Play()
        tween(main, {BackgroundTransparency = 0.05}, Config.Animation.Normal):Play()
        springTween(main, {Size = options.Size or UDim2.new(0, 560, 0, 440)}, Config.Animation.Slow):Play()
    end
    
    function window:Hide()
        tween(blur, {Size = 0}, Config.Animation.Normal):Play()
        tween(main, {BackgroundTransparency = 1}, Config.Animation.Normal):Play()
        springTween(main, {Size = UDim2.new(0, 0, 0, 0)}, Config.Animation.Normal):Play()
        wait(Config.Animation.Normal)
        gui:Destroy()
        blur:Destroy()
    end
    
    return window
end

function LuminUI:Notify(options)
    if type(options) == "string" then
        options = {Title = "Notification", Text = options}
    end
    
    options = options or {}
    local title = options.Title or "Notification"
    local text = options.Text or ""
    local duration = options.Duration or 3.5
    local notifType = options.Type or "info"
    
    spawn(function()
        local gui = PlayerGui:FindFirstChild("LuminNotifications")
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "LuminNotifications"
            gui.Parent = PlayerGui
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.ResetOnSpawn = false
            
            local container = Instance.new("Frame")
            container.Name = "Container"
            container.Parent = gui
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(0, 350, 1, 0)
            container.Position = UDim2.new(1, -370, 0, 15)
            container.ZIndex = 100
            
            local layout = Instance.new("UIListLayout")
            layout.Parent = container
            layout.Padding = UDim.new(0, 10)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.VerticalAlignment = Enum.VerticalAlignment.Top
        end
        
        local container = gui.Container
        
        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.Parent = container
        notif.BackgroundColor3 = Config.Theme.Surface
        notif.BackgroundTransparency = 0.05
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(1, 0, 0, 80)
        notif.Position = UDim2.new(1, 0, 0, 0)
        notif.ZIndex = 101
        corner(notif)
        shadow(notif, 0.15)
        stroke(notif, 1, Config.Theme.Border)
        
        local colors = {
            info = Config.Theme.Primary,
            success = Config.Theme.Success,
            warning = Config.Theme.Warning,
            error = Config.Theme.Error
        }
        local accentColor = colors[notifType] or Config.Theme.Primary
        
        local accent = Instance.new("Frame")
        accent.Name = "Accent"
        accent.Parent = notif
        accent.BackgroundColor3 = accentColor
        accent.BorderSizePixel = 0
        accent.Size = UDim2.new(0, 4, 1, 0)
        accent.Position = UDim2.new(0, 0, 0, 0)
        accent.ZIndex = 102
        corner(accent)
        glow(accent, accentColor, 0.4)
        
        local icons = {
            info = "ℹ",
            success = "✓",
            warning = "⚠",
            error = "✕"
        }
        
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Parent = notif
        icon.BackgroundTransparency = 1
        icon.Font = Enum.Font.GothamBold
        icon.Text = icons[notifType] or "ℹ"
        icon.TextColor3 = accentColor
        icon.TextSize = 20
        icon.Position = UDim2.new(0, 16, 0, 10)
        icon.Size = UDim2.new(0, 28, 0, 28)
        icon.ZIndex = 102
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Parent = notif
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Config.Theme.Text
        titleLabel.TextSize = 15
        titleLabel.Position = UDim2.new(0, 52, 0, 10)
        titleLabel.Size = UDim2.new(1, -70, 0, 22)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 102
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Text"
        textLabel.Parent = notif
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.Gotham
        textLabel.Text = text
        textLabel.TextColor3 = Config.Theme.TextSecondary
        textLabel.TextSize = 13
        textLabel.Position = UDim2.new(0, 52, 0, 35)
        textLabel.Size = UDim2.new(1, -70, 0, 35)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.TextWrapped = true
        textLabel.ZIndex = 102
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "Close"
        closeBtn.Parent = notif
        closeBtn.BackgroundTransparency = 1
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Config.Theme.TextSecondary
        closeBtn.TextSize = 16
        closeBtn.Size = UDim2.new(0, 20, 0, 20)
        closeBtn.Position = UDim2.new(1, -28, 0, 6)
        closeBtn.ZIndex = 103
        
        closeBtn.MouseEnter:Connect(function()
            tween(closeBtn, {TextColor3 = Config.Theme.Text}, Config.Animation.Fast):Play()
        end)
        
        closeBtn.MouseLeave:Connect(function()
            tween(closeBtn, {TextColor3 = Config.Theme.TextSecondary}, Config.Animation.Fast):Play()
        end)
        
        local function closeNotif()
            tween(notif, {Position = UDim2.new(1, 0, 0, 0)}, Config.Animation.Normal):Play()
            tween(notif, {BackgroundTransparency = 1}, Config.Animation.Normal):Play()
            wait(Config.Animation.Normal)
            if notif and notif.Parent then
                notif:Destroy()
            end
        end
        
        closeBtn.MouseButton1Click:Connect(closeNotif)
        
        springTween(notif, {Position = UDim2.new(0, 0, 0, 0)}, Config.Animation.Slow):Play()
        
        if duration > 0 then
            wait(duration)
            closeNotif()
        end
    end)
end

function LuminUI:NotifySuccess(title, text, duration)
    self:Notify({Title = title, Text = text, Duration = duration or 2.5, Type = "success"})
end

function LuminUI:NotifyWarning(title, text, duration)
    self:Notify({Title = title, Text = text, Duration = duration or 3.5, Type = "warning"})
end

function LuminUI:NotifyError(title, text, duration)
    self:Notify({Title = title, Text = text, Duration = duration or 4.5, Type = "error"})
end

function LuminUI:NotifyInfo(title, text, duration)
    self:Notify({Title = title, Text = text, Duration = duration or 3.5, Type = "info"})
end

function LuminUI:SetTheme(themeName)
    if Themes[themeName] then
        Config.Theme = Themes[themeName]
    end
end

function LuminUI:GetThemes()
    local names = {}
    for name, _ in pairs(Themes) do
        table.insert(names, name)
    end
    return names
end

function LuminUI:AddTheme(name, data)
    Themes[name] = data
end

return LuminUI
