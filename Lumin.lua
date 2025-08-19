local Lumin = {
    version = "4.0.0 - Web Engine",
    dom = {},
    styles = {},
    viewport = {},
    events = {},
    animations = {},
    storage = {}
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Element = {}
Element.__index = Element

function Element.new(tagName, attributes)
    local self = setmetatable({}, Element)
    self.tagName = tagName:lower()
    self.attributes = attributes or {}
    self.style = {}
    self.children = {}
    self.parent = nil
    self.classList = {}
    self.id = attributes and attributes.id or nil
    self.className = attributes and attributes.class or ""
    self.innerHTML = ""
    self.textContent = ""
    self.value = attributes and attributes.value or ""
    self.placeholder = attributes and attributes.placeholder or ""
    self.src = attributes and attributes.src or ""
    self.href = attributes and attributes.href or ""
    self.eventListeners = {}
    self.computedStyle = {}
    self._guiObject = nil
    return self
end

function Element:appendChild(child)
    table.insert(self.children, child)
    child.parent = self
    return child
end

function Element:removeChild(child)
    for i, c in ipairs(self.children) do
        if c == child then
            table.remove(self.children, i)
            child.parent = nil
            if child._guiObject then
                child._guiObject:Destroy()
            end
            break
        end
    end
end

function Element:setAttribute(name, value)
    self.attributes[name] = value
    if name == "id" then
        self.id = value
    elseif name == "class" then
        self.className = value
        self.classList = {}
        for class in value:gmatch("%S+") do
            table.insert(self.classList, class)
        end
    elseif name == "style" then
        self:_parseInlineStyle(value)
    end
end

function Element:getAttribute(name)
    return self.attributes[name]
end

function Element:addEventListener(event, callback)
    if not self.eventListeners[event] then
        self.eventListeners[event] = {}
    end
    table.insert(self.eventListeners[event], callback)
end

function Element:removeEventListener(event, callback)
    if self.eventListeners[event] then
        for i, cb in ipairs(self.eventListeners[event]) do
            if cb == callback then
                table.remove(self.eventListeners[event], i)
                break
            end
        end
    end
end

function Element:dispatchEvent(eventType, eventData)
    if self.eventListeners[eventType] then
        for _, callback in ipairs(self.eventListeners[eventType]) do
            callback(eventData or {})
        end
    end
end

function Element:querySelector(selector)
    return self:_findElement(selector, true)
end

function Element:querySelectorAll(selector)
    return self:_findElement(selector, false)
end

function Element:_findElement(selector, findFirst)
    local results = {}
    
    local function search(element)
        local matches = false
        
        if selector:match("^#") then
            matches = element.id == selector:sub(2)
        elseif selector:match("^%.") then
            local className = selector:sub(2)
            for _, cls in ipairs(element.classList) do
                if cls == className then
                    matches = true
                    break
                end
            end
        else
            matches = element.tagName == selector
        end
        
        if matches then
            if findFirst then
                return element
            else
                table.insert(results, element)
            end
        end
        
        for _, child in ipairs(element.children) do
            local result = search(child)
            if result and findFirst then
                return result
            end
        end
    end
    
    local result = search(self)
    return findFirst and result or results
end

function Element:_parseInlineStyle(styleText)
    for property in styleText:gmatch("[^;]+") do
        local key, value = property:match("([^:]+):([^:]+)")
        if key and value then
            key = key:gsub("^%s+", ""):gsub("%s+$", "")
            value = value:gsub("^%s+", ""):gsub("%s+$", "")
            self.style[key] = value
        end
    end
end

local Document = {}
Document.__index = Document

function Document.new()
    local self = setmetatable({}, Document)
    self.documentElement = Element.new("html")
    self.head = Element.new("head")
    self.body = Element.new("body")
    self.documentElement:appendChild(self.head)
    self.documentElement:appendChild(self.body)
    self.stylesheets = {}
    return self
end

function Document:createElement(tagName)
    return Element.new(tagName)
end

function Document:createTextNode(text)
    local textNode = Element.new("#text")
    textNode.textContent = text
    return textNode
end

function Document:getElementById(id)
    local function search(element)
        if element.id == id then
            return element
        end
        for _, child in ipairs(element.children) do
            local result = search(child)
            if result then return result end
        end
    end
    return search(self.documentElement)
end

function Document:getElementsByClassName(className)
    local results = {}
    local function search(element)
        for _, cls in ipairs(element.classList) do
            if cls == className then
                table.insert(results, element)
                break
            end
        end
        for _, child in ipairs(element.children) do
            search(child)
        end
    end
    search(self.documentElement)
    return results
end

function Document:getElementsByTagName(tagName)
    local results = {}
    local function search(element)
        if element.tagName == tagName:lower() then
            table.insert(results, element)
        end
        for _, child in ipairs(element.children) do
            search(child)
        end
    end
    search(self.documentElement)
    return results
end

function Document:querySelector(selector)
    return self.documentElement:querySelector(selector)
end

function Document:querySelectorAll(selector)
    return self.documentElement:querySelectorAll(selector)
end

local CSSEngine = {}

function CSSEngine.parseCSS(cssText)
    local rules = {}
    cssText = cssText:gsub("/%*.-%*/", "")
    
    for ruleText in cssText:gmatch("[^}]+{[^}]*}") do
        local selector, declarations = ruleText:match("([^{]+){([^}]*)}")
        if selector and declarations then
            selector = selector:gsub("^%s+", ""):gsub("%s+$", "")
            local rule = {
                selector = selector,
                declarations = {}
            }
            
            for declaration in declarations:gmatch("[^;]+") do
                local property, value = declaration:match("([^:]+):([^:]+)")
                if property and value then
                    property = property:gsub("^%s+", ""):gsub("%s+$", "")
                    value = value:gsub("^%s+", ""):gsub("%s+$", "")
                    rule.declarations[property] = value
                end
            end
            
            table.insert(rules, rule)
        end
    end
    
    return rules
end

function CSSEngine.computeStyle(element, stylesheets)
    local computedStyle = {}
    
    for _, stylesheet in ipairs(stylesheets) do
        for _, rule in ipairs(stylesheet) do
            if CSSEngine.matchesSelector(element, rule.selector) then
                for property, value in pairs(rule.declarations) do
                    computedStyle[property] = value
                end
            end
        end
    end
    
    for property, value in pairs(element.style) do
        computedStyle[property] = value
    end
    
    element.computedStyle = computedStyle
    return computedStyle
end

function CSSEngine.matchesSelector(element, selector)
    if selector:match("^#") then
        return element.id == selector:sub(2)
    elseif selector:match("^%.") then
        local className = selector:sub(2)
        for _, cls in ipairs(element.classList) do
            if cls == className then
                return true
            end
        end
        return false
    else
        return element.tagName == selector:lower()
    end
end

local RenderEngine = {}

function RenderEngine.createGuiObject(element)
    local obj
    local tag = element.tagName
    
    if tag == "div" or tag == "section" or tag == "main" or tag == "nav" or tag == "header" or tag == "footer" or tag == "article" then
        obj = Instance.new("Frame")
        obj.BackgroundColor3 = Color3.new(1, 1, 1)
        obj.BorderSizePixel = 0
        obj.Size = UDim2.new(1, 0, 0, 100)
        
    elseif tag == "p" or tag == "h1" or tag == "h2" or tag == "h3" or tag == "h4" or tag == "h5" or tag == "h6" or tag == "span" or tag == "label" then
        obj = Instance.new("TextLabel")
        obj.BackgroundTransparency = 1
        obj.Text = element.textContent
        obj.TextColor3 = Color3.new(0, 0, 0)
        obj.TextSize = tag:match("^h(%d)") and (32 - tonumber(tag:match("^h(%d)")) * 4) or 16
        obj.Font = Enum.Font.Gotham
        obj.Size = UDim2.new(1, 0, 0, 30)
        obj.TextXAlignment = Enum.TextXAlignment.Left
        obj.TextWrapped = true
        
    elseif tag == "button" then
        obj = Instance.new("TextButton")
        obj.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
        obj.BorderSizePixel = 0
        obj.Text = element.textContent
        obj.TextColor3 = Color3.new(1, 1, 1)
        obj.TextSize = 14
        obj.Font = Enum.Font.GothamMedium
        obj.Size = UDim2.new(0, 120, 0, 36)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = obj
        
        obj.MouseButton1Click:Connect(function()
            element:dispatchEvent("click")
        end)
        
    elseif tag == "input" then
        obj = Instance.new("TextBox")
        obj.BackgroundColor3 = Color3.new(1, 1, 1)
        obj.BorderColor3 = Color3.fromRGB(209, 213, 219)
        obj.BorderSizePixel = 1
        obj.PlaceholderText = element.placeholder
        obj.Text = element.value
        obj.TextColor3 = Color3.new(0, 0, 0)
        obj.TextSize = 14
        obj.Font = Enum.Font.Gotham
        obj.Size = UDim2.new(0, 200, 0, 36)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = obj
        
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            element.value = obj.Text
            element:dispatchEvent("input", {target = element})
        end)
        
    elseif tag == "img" then
        obj = Instance.new("ImageLabel")
        obj.BackgroundTransparency = 1
        obj.Image = element.src
        obj.Size = UDim2.new(0, 100, 0, 100)
        obj.ScaleType = Enum.ScaleType.Fit
        
    elseif tag == "textarea" then
        obj = Instance.new("TextBox")
        obj.BackgroundColor3 = Color3.new(1, 1, 1)
        obj.BorderColor3 = Color3.fromRGB(209, 213, 219)
        obj.BorderSizePixel = 1
        obj.PlaceholderText = element.placeholder
        obj.Text = element.value
        obj.TextColor3 = Color3.new(0, 0, 0)
        obj.TextSize = 14
        obj.Font = Enum.Font.Gotham
        obj.Size = UDim2.new(0, 300, 0, 100)
        obj.MultiLine = true
        obj.TextYAlignment = Enum.TextYAlignment.Top
        
    elseif tag == "a" then
        obj = Instance.new("TextButton")
        obj.BackgroundTransparency = 1
        obj.Text = element.textContent
        obj.TextColor3 = Color3.fromRGB(59, 130, 246)
        obj.TextSize = 16
        obj.Font = Enum.Font.Gotham
        obj.Size = UDim2.new(1, 0, 0, 25)
        obj.TextXAlignment = Enum.TextXAlignment.Left
        
        obj.MouseButton1Click:Connect(function()
            element:dispatchEvent("click")
        end)
        
    else
        obj = Instance.new("Frame")
        obj.BackgroundTransparency = 1
        obj.Size = UDim2.new(1, 0, 0, 50)
    end
    
    obj.Name = element.id or element.tagName
    return obj
end

function RenderEngine.applyStyles(obj, element)
    local style = element.computedStyle
    
    for property, value in pairs(style) do
        if property == "width" then
            obj.Size = UDim2.new(RenderEngine.parseSize(value), obj.Size.Y)
        elseif property == "height" then
            obj.Size = UDim2.new(obj.Size.X, RenderEngine.parseSize(value))
        elseif property == "background-color" or property == "background" then
            obj.BackgroundColor3 = RenderEngine.parseColor(value)
        elseif property == "color" and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            obj.TextColor3 = RenderEngine.parseColor(value)
        elseif property == "font-size" and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            obj.TextSize = tonumber(value:match("(%d+)")) or 16
        elseif property == "border-radius" then
            local corner = obj:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, tonumber(value:match("(%d+)")) or 0)
            corner.Parent = obj
        elseif property == "padding" then
            local padding = obj:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding")
            local val = tonumber(value:match("(%d+)")) or 0
            padding.PaddingTop = UDim.new(0, val)
            padding.PaddingRight = UDim.new(0, val)
            padding.PaddingBottom = UDim.new(0, val)
            padding.PaddingLeft = UDim.new(0, val)
            padding.Parent = obj
        elseif property == "display" then
            if value == "none" then
                obj.Visible = false
            elseif value == "flex" then
                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.Parent = obj
            elseif value == "block" then
                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.FillDirection = Enum.FillDirection.Vertical
                layout.Parent = obj
            end
        elseif property == "position" then
            if value == "absolute" then
                obj.Position = UDim2.new(0, 0, 0, 0)
            end
        elseif property == "opacity" then
            local alpha = tonumber(value) or 1
            obj.BackgroundTransparency = 1 - alpha
        end
    end
end

function RenderEngine.parseSize(value)
    if value:match("%%$") then
        return UDim.new(tonumber(value:match("(.-)%%")) / 100, 0)
    elseif value:match("px$") then
        return UDim.new(0, tonumber(value:match("(.-)px")))
    elseif value:match("vw$") then
        local vw = tonumber(value:match("(.-)vw")) / 100
        return UDim.new(0, workspace.CurrentCamera.ViewportSize.X * vw)
    elseif value:match("vh$") then
        local vh = tonumber(value:match("(.-)vh")) / 100
        return UDim.new(0, workspace.CurrentCamera.ViewportSize.Y * vh)
    else
        return UDim.new(0, tonumber(value) or 100)
    end
end

function RenderEngine.parseColor(color)
    if color:match("^#") then
        local hex = color:sub(2)
        if #hex == 3 then hex = hex:gsub("(.)", "%1%1") end
        local r = tonumber(hex:sub(1,2), 16) / 255
        local g = tonumber(hex:sub(3,4), 16) / 255
        local b = tonumber(hex:sub(5,6), 16) / 255
        return Color3.new(r, g, b)
    elseif color:match("^rgb") then
        local r, g, b = color:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
        return Color3.new(r/255, g/255, b/255)
    else
        return Color3.new(1, 1, 1)
    end
end

function RenderEngine.render(element, parent, stylesheets)
    CSSEngine.computeStyle(element, stylesheets)
    
    local obj = RenderEngine.createGuiObject(element)
    RenderEngine.applyStyles(obj, element)
    
    element._guiObject = obj
    obj.Parent = parent
    
    for _, child in ipairs(element.children) do
        if child.tagName ~= "#text" then
            RenderEngine.render(child, obj, stylesheets)
        end
    end
    
    return obj
end

local JavaScriptEngine = {}

function JavaScriptEngine.createGlobalEnvironment(document, window)
    return {
        document = document,
        window = window,
        console = {
            log = function(...) print("[Console]", ...) end,
            warn = function(...) warn("[Console]", ...) end,
            error = function(...) error("[Console] " .. tostring(...)) end
        },
        setTimeout = function(callback, delay)
            spawn(function()
                wait((delay or 0) / 1000)
                callback()
            end)
        end,
        setInterval = function(callback, interval)
            spawn(function()
                while true do
                    wait((interval or 1000) / 1000)
                    callback()
                end
            end)
        end,
        alert = function(message)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Alert";
                Text = tostring(message);
                Duration = 5;
            })
        end,
        confirm = function(message)
            return true
        end,
        JSON = {
            stringify = function(obj)
                return game:GetService("HttpService"):JSONEncode(obj)
            end,
            parse = function(str)
                return game:GetService("HttpService"):JSONDecode(str)
            end
        }
    }
end

function Lumin.createWebPage(html, css, js, parent)
    local document = Document.new()
    local window = {
        document = document,
        location = {href = "roblox://lumin"},
        history = {},
        navigator = {userAgent = "Lumin/4.0"}
    }
    
    if html then
        document.body.innerHTML = html
        local htmlElements = Lumin._parseHTML(html)
        for _, element in ipairs(htmlElements) do
            document.body:appendChild(element)
        end
    end
    
    local stylesheets = {}
    if css then
        table.insert(stylesheets, CSSEngine.parseCSS(css))
    end
    
    local jsEnv = JavaScriptEngine.createGlobalEnvironment(document, window)
    
    if js then
        local jsFunc = loadstring(js)
        if jsFunc then
            setfenv(jsFunc, jsEnv)
            pcall(jsFunc)
        end
    end
    
    local renderedObjects = {}
    for _, element in ipairs(document.body.children) do
        table.insert(renderedObjects, RenderEngine.render(element, parent, stylesheets))
    end
    
    return {
        document = document,
        window = window,
        objects = renderedObjects,
        refresh = function()
            for _, obj in ipairs(renderedObjects) do
                obj:Destroy()
            end
            renderedObjects = {}
            for _, element in ipairs(document.body.children) do
                table.insert(renderedObjects, RenderEngine.render(element, parent, stylesheets))
            end
        end
    }
end

function Lumin._parseHTML(html)
    local elements = {}
    local stack = {}
    
    for tag in html:gmatch("<[^>]+>") do
        if tag:match("^</") then
            table.remove(stack)
        else
            local tagName = tag:match("<([%w%-]+)")
            local attrs = {}
            
            for attr, quote, value in tag:gmatch('([%w%-]+)=(["\'])(.-)["\']') do
                attrs[attr] = value
            end
            
            local element = Element.new(tagName, attrs)
            
            if #stack > 0 then
                stack[#stack]:appendChild(element)
            else
                table.insert(elements, element)
            end
            
            if not tag:match("/>$") and not tagName:match("^(br|hr|img|input)$") then
                table.insert(stack, element)
            end
        end
    end
    
    return elements
end

return Lumin
