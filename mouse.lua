function init_mouse()
    poke(0x5f2d, 1) -- enable mouse
    mouse_x = 0
    mouse_y = 0
    mouse_left_init = false
    mouse_left_hold = false
end

function update_mouse()
    mouse_x,mouse_y,mouse_click = stat(32),stat(33),stat(34)

    if(mouse_left_hold == false) then
        if(band(mouse_click,0x1) == 1) then
            mouse_left_init = true
        end
    else
        mouse_left_init = false
    end

    if(band(mouse_click,0x1) == 1) then
        mouse_left_hold = true
    else
        mouse_left_hold = false
    end
end

function draw_mouse()
    spr(7,mouse_x-1,mouse_y-1)
end