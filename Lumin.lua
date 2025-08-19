local Lumin = {
    version = "2.0.0",
    tailwind = {},
    bootstrap = {},
    fontawesome = {},
    globals = {},
    components = {}
}

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local tailwindClasses = {
    ["bg-blue-500"] = {background = "#3B82F6"},
    ["bg-red-500"] = {background = "#EF4444"},
    ["bg-green-500"] = {background = "#10B981"},
    ["bg-yellow-500"] = {background = "#F59E0B"},
    ["bg-purple-500"] = {background = "#8B5CF6"},
    ["bg-pink-500"] = {background = "#EC4899"},
    ["bg-indigo-500"] = {background = "#6366F1"},
    ["bg-gray-100"] = {background = "#F3F4F6"},
    ["bg-gray-200"] = {background = "#E5E7EB"},
    ["bg-gray-300"] = {background = "#D1D5DB"},
    ["bg-gray-400"] = {background = "#9CA3AF"},
    ["bg-gray-500"] = {background = "#6B7280"},
    ["bg-gray-600"] = {background = "#4B5563"},
    ["bg-gray-700"] = {background = "#374151"},
    ["bg-gray-800"] = {background = "#1F2937"},
    ["bg-gray-900"] = {background = "#111827"},
    ["bg-white"] = {background = "#FFFFFF"},
    ["bg-black"] = {background = "#000000"},
    
    ["text-white"] = {color = "#FFFFFF"},
    ["text-black"] = {color = "#000000"},
    ["text-gray-500"] = {color = "#6B7280"},
    ["text-blue-500"] = {color = "#3B82F6"},
    ["text-red-500"] = {color = "#EF4444"},
    ["text-green-500"] = {color = "#10B981"},
    
    ["text-xs"] = {fontSize = 12},
    ["text-sm"] = {fontSize = 14},
    ["text-base"] = {fontSize = 16},
    ["text-lg"] = {fontSize = 18},
    ["text-xl"] = {fontSize = 20},
    ["text-2xl"] = {fontSize = 24},
    ["text-3xl"] = {fontSize = 30},
    ["text-4xl"] = {fontSize = 36},
    
    ["w-4"] = {width = 16},
    ["w-8"] = {width = 32},
    ["w-16"] = {width = 64},
    ["w-32"] = {width = 128},
    ["w-64"] = {width = 256},
    ["w-full"] = {width = "100%"},
    ["w-1/2"] = {width = "50%"},
    ["w-1/3"] = {width = "33%"},
    ["w-2/3"] = {width = "66%"},
    
    ["h-4"] = {height = 16},
    ["h-8"] = {height = 32},
    ["h-16"] = {height = 64},
    ["h-32"] = {height = 128},
    ["h-64"] = {height = 256},
    ["h-full"] = {height = "100%"},
    ["h-screen"] = {height = "100vh"},
    
    ["p-1"] = {padding = 4},
    ["p-2"] = {padding = 8},
    ["p-4"] = {padding = 16},
    ["p-6"] = {padding = 24},
    ["p-8"] = {padding = 32},
    
    ["m-1"] = {margin = 4},
    ["m-2"] = {margin = 8},
    ["m-4"] = {margin = 16},
    ["m-6"] = {margin = 24},
    ["m-8"] = {margin = 32},
    ["m-auto"] = {margin = "auto"},
    
    ["rounded"] = {cornerRadius = 4},
    ["rounded-md"] = {cornerRadius = 6},
    ["rounded-lg"] = {cornerRadius = 8},
    ["rounded-xl"] = {cornerRadius = 12},
    ["rounded-2xl"] = {cornerRadius = 16},
    ["rounded-full"] = {cornerRadius = 9999},
    
    ["shadow-sm"] = {shadow = 1},
    ["shadow"] = {shadow = 2},
    ["shadow-md"] = {shadow = 3},
    ["shadow-lg"] = {shadow = 4},
    ["shadow-xl"] = {shadow = 5},
    
    ["flex"] = {layout = "flex"},
    ["flex-col"] = {layout = "flex", direction = "column"},
    ["flex-row"] = {layout = "flex", direction = "row"},
    ["items-center"] = {alignItems = "center"},
    ["justify-center"] = {justifyContent = "center"},
    ["justify-between"] = {justifyContent = "space-between"},
    
    ["absolute"] = {position = "absolute"},
    ["relative"] = {position = "relative"},
    ["fixed"] = {position = "fixed"},
    
    ["opacity-0"] = {opacity = 0},
    ["opacity-25"] = {opacity = 0.25},
    ["opacity-50"] = {opacity = 0.5},
    ["opacity-75"] = {opacity = 0.75},
    ["opacity-100"] = {opacity = 1},
    
    ["hover:bg-blue-600"] = {hoverBackground = "#2563EB"},
    ["hover:bg-red-600"] = {hoverBackground = "#DC2626"},
    ["hover:scale-105"] = {hoverScale = 1.05},
    ["transition"] = {transition = true}
}

local bootstrapClasses = {
    ["btn"] = {
        background = "#007BFF",
        color = "#FFFFFF",
        padding = {8, 12},
        cornerRadius = 4,
        fontSize = 14
    },
    ["btn-primary"] = {background = "#007BFF"},
    ["btn-secondary"] = {background = "#6C757D"},
    ["btn-success"] = {background = "#28A745"},
    ["btn-danger"] = {background = "#DC3545"},
    ["btn-warning"] = {background = "#FFC107"},
    ["btn-info"] = {background = "#17A2B8"},
    ["btn-light"] = {background = "#F8F9FA", color = "#212529"},
    ["btn-dark"] = {background = "#343A40"},
    
    ["card"] = {
        background = "#FFFFFF",
        cornerRadius = 8,
        shadow = 2,
        padding = 16
    },
    ["card-header"] = {
        background = "#F8F9FA",
        padding = 12,
        borderBottom = true
    },
    ["card-body"] = {padding = 16},
    
    ["container"] = {width = "100%", padding = {0, 15}},
    ["container-fluid"] = {width = "100%"},
    
    ["row"] = {layout = "flex", direction = "row"},
    ["col"] = {flex = 1},
    ["col-1"] = {width = "8.33%"},
    ["col-2"] = {width = "16.66%"},
    ["col-3"] = {width = "25%"},
    ["col-4"] = {width = "33.33%"},
    ["col-6"] = {width = "50%"},
    ["col-8"] = {width = "66.66%"},
    ["col-12"] = {width = "100%"},
    
    ["text-center"] = {textAlign = "center"},
    ["text-left"] = {textAlign = "left"},
    ["text-right"] = {textAlign = "right"},
    
    ["d-flex"] = {layout = "flex"},
    ["justify-content-center"] = {justifyContent = "center"},
    ["align-items-center"] = {alignItems = "center"}
}

local fontAwesomeIcons = {
    ["fa-home"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-user"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-cog"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-heart"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-star"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-search"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-plus"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-minus"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-times"] = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ["fa-check"] = "rbxasset://textures/ui/GuiImagePlaceholder.png"
}

local function parseClasses(classString)
    local styles = {}
    if not classString then return styles end
    
    for class in classString:gmatch("%S+") do
        if tailwindClasses[class] then
            for k, v in pairs(tailwindClasses[class]) do
                styles[k] = v
            end
        elseif bootstrapClasses[class] then
            for k, v in pairs(bootstrapClasses[class]) do
                styles[k] = v
            end
        end
    end
    
    return styles
end

local function parseHTML(html)
    local elements = {}
    local currentText = ""
    local i = 1
    local stack = {elements}
    
    while i <= #html do
        local tagStart = html:find("<", i)
        
        if not tagStart then
            if currentText ~= "" then
                table.insert(stack[#stack], {type = "text", content = currentText})
            end
            break
        end
        
        if tagStart > i then
            currentText = html:sub(i, tagStart - 1):gsub("^%s+", ""):gsub("%s+$", "")
            if currentText ~= "" then
                table.insert(stack[#stack], {type = "text", content = currentText})
            end
        end
        
        local tagEnd = html:find(">", tagStart)
        if not tagEnd then break end
        
        local tag = html:sub(tagStart + 1, tagEnd - 1)
        
        if tag:match("^/") then
            table.remove(stack)
        else
            local tagName = tag:match("^(%S+)")
            local attrs = {}
            
            for attr, value in tag:gmatch('(%w+)=(["\'])([^"\']*)["\']') do
                attrs[attr] = value
            end
            
            local element = {
                type = "element",
                tag = tagName,
                attributes = attrs,
                children = {}
            }
            
            table.insert(stack[#stack], element)
            
            if not tag:match("/$") and tagName ~= "br" and tagName ~= "img" then
                table.insert(stack, element.children)
            end
        end
        
        i = tagEnd + 1
        currentText = ""
    end
    
    return elements
end

local function createInstance(element)
    local instance
    
    if element.tag == "div" then
        instance = Instance.new("Frame")
        instance.BorderSizePixel = 0
        instance.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        instance.Size = UDim2.new(1, 0, 0, 100)
    elseif element.tag == "button" then
        instance = Instance.new("TextButton")
        instance.BackgroundColor3 = Color3.fromHex("#007BFF")
        instance.BorderSizePixel = 0
        instance.Text = element.content or "Button"
        instance.TextColor3 = Color3.fromHex("#FFFFFF")
        instance.TextSize = 14
        instance.Size = UDim2.new(0, 100, 0, 32)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = instance
        
    elseif element.tag == "input" then
        instance = Instance.new("TextBox")
        instance.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        instance.BorderColor3 = Color3.fromHex("#CED4DA")
        instance.BorderSizePixel = 1
        instance.PlaceholderText = element.attributes.placeholder or ""
        instance.Text = ""
        instance.TextSize = 14
        instance.Size = UDim2.new(0, 200, 0, 36)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = instance
        
    elseif element.tag == "p" or element.tag == "span" or element.tag == "h1" or element.tag == "h2" then
        instance = Instance.new("TextLabel")
        instance.BackgroundTransparency = 1
        instance.Text = element.content or ""
        instance.TextColor3 = Color3.fromHex("#000000")
        instance.TextSize = element.tag == "h1" and 24 or element.tag == "h2" and 20 or 16
        instance.Size = UDim2.new(1, 0, 0, 30)
        instance.TextXAlignment = Enum.TextXAlignment.Left
        
    elseif element.tag == "img" then
        instance = Instance.new("ImageLabel")
        instance.BackgroundTransparency = 1
        instance.Image = element.attributes.src or ""
        instance.Size = UDim2.new(0, 100, 0, 100)
        
    elseif element.tag == "i" then
        instance = Instance.new("ImageLabel")
        instance.BackgroundTransparency = 1
        local iconClass = element.attributes.class
        if iconClass and fontAwesomeIcons[iconClass] then
            instance.Image = fontAwesomeIcons[iconClass]
        end
        instance.Size = UDim2.new(0, 16, 0, 16)
        
    else
        instance = Instance.new("Frame")
        instance.BackgroundTransparency = 1
        instance.Size = UDim2.new(1, 0, 0, 50)
    end
    
    return instance
end

local function applyStyle(instance, styles)
    for prop, value in pairs(styles) do
        if prop == "background" then
            instance.BackgroundColor3 = Color3.fromHex(value)
        elseif prop == "color" then
            if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
                instance.TextColor3 = Color3.fromHex(value)
            end
        elseif prop == "fontSize" then
            if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
                instance.TextSize = value
            end
        elseif prop == "cornerRadius" then
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, value)
            corner.Parent = instance
        elseif prop == "padding" then
            local padding = Instance.new("UIPadding")
            if type(value) == "number" then
                padding.PaddingTop = UDim.new(0, value)
                padding.PaddingBottom = UDim.new(0, value)
                padding.PaddingLeft = UDim.new(0, value)
                padding.PaddingRight = UDim.new(0, value)
            elseif type(value) == "table" then
                padding.PaddingTop = UDim.new(0, value[1] or 0)
                padding.PaddingRight = UDim.new(0, value[2] or 0)
                padding.PaddingBottom = UDim.new(0, value[3] or 0)
                padding.PaddingLeft = UDim.new(0, value[4] or 0)
            end
            padding.Parent = instance
        elseif prop == "width" then
            if type(value) == "string" and value:match("%%") then
                local percent = tonumber(value:match("(%d+)%%")) / 100
                instance.Size = UDim2.new(percent, 0, instance.Size.Y.Scale, instance.Size.Y.Offset)
            elseif type(value) == "number" then
                instance.Size = UDim2.new(0, value, instance.Size.Y.Scale, instance.Size.Y.Offset)
            end
        elseif prop == "height" then
            if type(value) == "string" and value:match("%%") then
                local percent = tonumber(value:match("(%d+)%%")) / 100
                instance.Size = UDim2.new(instance.Size.X.Scale, instance.Size.X.Offset, percent, 0)
            elseif type(value) == "number" then
                instance.Size = UDim2.new(instance.Size.X.Scale, instance.Size.X.Offset, 0, value)
            end
        elseif prop == "layout" and value == "flex" then
            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = instance
        elseif prop == "direction" and value == "column" then
            local layout = instance:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout.FillDirection = Enum.FillDirection.Vertical
            end
        end
    end
end

local function renderElement(element, parent, jsEnv)
    if element.type == "text" then
        local textLabel = Instance.new("TextLabel")
        textLabel.BackgroundTransparency = 1
        textLabel.Text = element.content
        textLabel.TextColor3 = Color3.fromHex("#000000")
        textLabel.TextSize = 16
        textLabel.Size = UDim2.new(1, 0, 0, 20)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = parent
        return textLabel
    end
    
    local instance = createInstance(element)
    local styles = parseClasses(element.attributes.class)
    
    applyStyle(instance, styles)
    
    if element.attributes.onclick then
        local funcName = element.attributes.onclick:match("([%w_]+)")
        if funcName and jsEnv[funcName] then
            instance.MouseButton1Click:Connect(jsEnv[funcName])
        end
    end
    
    if element.children then
        for _, child in ipairs(element.children) do
            renderElement(child, instance, jsEnv)
        end
    end
    
    instance.Parent = parent
    return instance
end

function Lumin.render(html, css, js, parent)
    local jsEnv = {
        print = print,
        game = game,
        workspace = workspace,
        wait = wait,
        spawn = spawn,
        TweenService = TweenService
    }
    
    for name, func in pairs(Lumin.globals) do
        jsEnv[name] = func
    end
    
    if js then
        local jsFunc = loadstring(js)
        if jsFunc then
            setfenv(jsFunc, jsEnv)
            jsFunc()
        end
    end
    
    local elements = parseHTML(html)
    local instances = {}
    
    for _, element in ipairs(elements) do
        table.insert(instances, renderElement(element, parent, jsEnv))
    end
    
    return instances
end

function Lumin.registerGlobal(name, func)
    Lumin.globals[name] = func
end

function Lumin.animate(instance, properties, duration, easing)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easing or Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Lumin.addTailwindClass(className, styles)
    tailwindClasses[className] = styles
end

function Lumin.addBootstrapClass(className, styles)
    bootstrapClasses[className] = styles
end

function Lumin.addFontAwesome(iconName, imageId)
    fontAwesomeIcons[iconName] = imageId
end

Lumin.registerGlobal("animate", Lumin.animate)
Lumin.registerGlobal("HttpService", HttpService)

return Lumin
