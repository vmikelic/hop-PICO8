occupied_slots = {}
num_of_obstacles = 0

function reset_level()
    player_vars.location_x = 1.0
    player_vars.location_y = 62.0
    player_vars.player_status = 0
    player_vars.velocity_x = 0
    player_vars.velocity_y = 0
    occupied_slots = {}
end

function make_level()
    --0 to 48
end

function draw_level()
    animate_once(0,52,{8},1,3,1,1)
    animate_once(128-8,52,{9},1,3,1,1)
    for x = 16,127,16 do 
        for y = 16,127,16 do
          pset(x, y, 8)
        end
    end
end