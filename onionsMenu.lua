--
-- Variables
--

-- Window
local onion_window = gui.Tab(gui.Reference("Settings"), 'onion_window', "Onion's Menu");

-- Groupboxes
local onion_window_groupbox_1 = gui.Groupbox(onion_window, 'Gradient Settings', 15, 15);
local onion_window_groupbox_2 = gui.Groupbox(onion_window, 'Menu Settings', 15, 295);

-- Checkboxes
local onion_gradient_enabled = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_enabled', 'Enabled', false);
local onion_gradient_vertical = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_vertical', 'Vertical Gradient (Wack ATM)', false);

-- Color Pickers
local onion_gradient_col_1 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_1', 'Gradient Color 1', 59, 175, 222, 255);
local onion_gradient_col_2 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_2', 'Gradient Color 2', 202, 70, 205, 255);
local onion_gradient_col_3 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_3', 'Gradient Color 3', 201, 227, 58, 255);

-- Sliders
local onion_gradient_height = gui.Slider(onion_window_groupbox_1,'onion_gradient_height', 'Gradient Height', 5, 1, 50);

-- Fonts
local tabFont = draw.CreateFont( "Tahoma", 60 );
local textFont = draw.CreateFont( "Tahoma", 24 );

-- Misc Variables
local scrW, scrH = 0, 0
local initialize = false;

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

local drawGradient = function( color1, color2, x, y, w, h, vertical )
	local r2, g2, b2 = color1[1], color1[2], color1[3];
	local r, g, b = color2[1], color2[2], color2[3];
	
    drawFilledRect( r2, g2, b2, 255, x, y, w, h );

    if vertical then
        for i = 1, h do
            local a = i / h * 255;
            drawFilledRect( r, g, b, a, x, y + i, w, 1);
        end
    else
        for i = 1, w do
            local a = i / w * 255;
            drawFilledRect( r, g, b, a, x + i, y, 1, h);
        end
    end
end

--
-- Controls Drawing
--

function drawButton(backColor, hoverColor, downColor)

end

--
-- Drawing Functions
--

function gatherVariables()
	if (initialize == false) then
		initialize = true
		scrW, scrH = draw.GetScreenSize()
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
	
	
end

--
-- Callbacks
--

callbacks.Register('Draw', gatherVariables);
callbacks.Register('Draw', drawMenu);
