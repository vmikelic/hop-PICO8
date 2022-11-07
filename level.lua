occupied_slots = {}
num_of_obstacles = 0

function reset_level()
    player_vars.location_x = 1.0
    player_vars.location_y = 62.0
    player_vars.player_status = 0
    player_vars.velocity_x = 0
    player_vars.velocity_y = 0
    occupied_slots = {}
    make_level()
end

function make_level()
    obstacles_created = 0
    num_of_obstacles = 10
    while(obstacles_created < num_of_obstacles) do
        obstacle_slot = {x=flr(rnd(7)),y=flr(rnd(7))}
        add_obstacle = true
        for i in all(occupied_slots) do
            if(obstacle_slot.x == i.x and obstacle_slot.y == i.y) then
                add_obstacle = false
                break
            end
        end
        if(add_obstacle == true) then
            add(occupied_slots,obstacle_slot)
            obstacles_created = obstacles_created + 1
        end
    end
end

function draw_level()
    animate_once(0,52,{8},1,3,1,1)
    animate_once(128-8,52,{9},1,3,1,1)
    ok_x = 0
    ok_y = 0
    for y = 16,127,16 do 
        for x = 16,127,16 do
          pset(x, y, 8)
        end
    end

    for i in all(occupied_slots) do
        sspr( 11*8, 0, 8, 8, 11+i.x*16, 11+i.y*16,10,10)
    end
end