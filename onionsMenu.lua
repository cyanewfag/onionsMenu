--
-- Variables
--

-- Colors
local buttonOutline = { 45, 45, 45, 255 }
local buttonBackground = { 105, 105, 105, 255 }
local buttonHover = { 82, 82, 82, 255 }
local buttonDown = { 51, 51, 51, 255 }
local buttonText = { 255, 255, 255, 255 }

-- Window
local onion_window = gui.Tab(gui.Reference("Settings"), 'onion_window', "Onion's Menu")

-- Groupboxes
local onion_window_groupbox_1 = gui.Groupbox(onion_window, 'Gradient Settings', 15, 15)
local onion_window_groupbox_2 = gui.Groupbox(onion_window, 'Menu Settings', 15, 295)

-- Checkboxes
local onion_gradient_enabled = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_enabled', 'Enabled', false)
local onion_gradient_vertical = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_vertical', 'Vertical Gradient (Clowns Only)', false)

-- Color Pickers
local onion_gradient_col_1 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_1', 'Gradient Color 1', 59, 175, 222, 255)
local onion_gradient_col_2 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_2', 'Gradient Color 2', 202, 70, 205, 255)
local onion_gradient_col_3 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_3', 'Gradient Color 3', 201, 227, 58, 255)

-- Sliders
local onion_gradient_height = gui.Slider(onion_window_groupbox_1,'onion_gradient_height', 'Gradient Height', 5, 1, 50)

-- Fonts
local tabFont = draw.CreateFont( "Tahoma", 60 )
local textFont = draw.CreateFont( "Tahoma", 24 )

-- Misc Variables
local scrW, scrH = 0, 0
local initialize = false
local mouseX, mouseY = 0, 0
local mouseState = "none"
local pressed = "";

--
-- Misc Functions
--

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

--
-- Drawing Functions
--

function drawFilledRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.FilledRect(x, y, x + width, y + height)
end

function drawOutlinedRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.OutlinedRect(x, y, x + width, y + height)
end

function drawText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	draw.Text(x, y, str)
end

function drawCenteredText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	local textW, textH = draw.GetTextSize(str)
	draw.Text(x - (textW / 2), y - (textH / 2), str)
end

function drawGradient( color1, color2, x, y, w, h, vertical )
	local r2, g2, b2 = color1[1], color1[2], color1[3]
	local r, g, b = color2[1], color2[2], color2[3]
	
    drawFilledRect( r2, g2, b2, 255, x, y, w, h )

    if vertical then
        for i = 1, h do
            local a = i / h * 255
            drawFilledRect( r, g, b, a, x, y + i, w, 1)
        end
    else
        for i = 1, w do
            local a = i / w * 255
            drawFilledRect( r, g, b, a, x + i, y, 1, h)
        end
    end
end

function drawOutlineGradient( outlineColor, color1, color2, x, y, w, h, vertical, thickness )
	local r, g, b, a = outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4]

	drawFilledRect(r, g, b, a, x, y, w, h)
	drawGradient( color1, color2, x + thickness, y + thickness, w - (thickness * 2), h - (thickness * 2), vertical )
end

--
-- Controls Drawing
--

function drawButton(borderColor, backColor, hoverColor, downColor, textColor, x, y, w, h, text, font, borderWidth)
	local a1, a2, a3, a4 = backColor[1], backColor[2], backColor[3], backColor[4]
	local b1, b2, b3, b4 = hoverColor[1], hoverColor[2], hoverColor[3], hoverColor[4]
	local c1, c2, c3, c4 = downColor[1], downColor[2], downColor[3], downColor[4]
	
	local r, g, b, a = borderColor[1], borderColor[2], borderColor[3], borderColor[4]
	local textR, textG, textB, textA = textColor[1], textColor[2], textColor[3], textColor[4]
	
	drawFilledRect(r, g, b, a, x, y, w, h)
	
	if (x < mouseX and mouseX < (x + w) and y < mouseY and mouseY < (y + h)) then
		if (mouseState == "none") then
			drawFilledRect(b1, b2, b3, b4, x + borderWidth, y + borderWidth, w - (borderWidth * 2), h - (borderWidth * 2))
		else
			drawFilledRect(c1, c2, c3, c4, x + borderWidth, y + borderWidth, w - (borderWidth * 2), h - (borderWidth * 2))
		end
	else
		drawFilledRect(a1, a2, a3, a4, x + borderWidth, y + borderWidth, w - (borderWidth * 2), h - (borderWidth * 2))
	end
	
	drawCenteredText(textR, textG, textB, textA, x + (w / 2), y + (h / 2), font, text)
end

--
-- Drawing Functions
--

function gatherVariables()
	if (initialize == false) then
		initialize = true
		scrW, scrH = draw.GetScreenSize()
	end
	
	mouseX, mouseY = input.GetMousePos()
	if (input.IsButtonDown("Mouse1")) then
		mouseState = "down"
	else
		mouseState = "none"
	end
	
	if (input.IsButtonReleased("Mouse1")) then
		mouseState = "released"
	end
end

function drawMenu()
	if (onion_gradient_enabled:GetValue() == true) then
		local a, b, c, d = onion_gradient_col_1:GetValue()
		local e, f, g, h = onion_gradient_col_2:GetValue()
		local i, j, k, l = onion_gradient_col_3:GetValue()
	
		drawGradient( { a, b, c, d }, { e, f, g, h }, 0, 0, draw.GetScreenSize() / 2, onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue() );
		drawGradient( { e, f, g, h }, { i, j, k, l }, draw.GetScreenSize() / 2,  0 , draw.GetScreenSize() / 2 , onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue());
	end
	
	drawButton(buttonOutline, buttonBackground, buttonHover, buttonDown, buttonText, 20, 20, 200, 50, "Click!", textFont, 2)
end

--
-- Callbacks
--

callbacks.Register('Draw', gatherVariables);
callbacks.Register('Draw', drawMenu);
