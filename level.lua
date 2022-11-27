occupied_slots = {}
num_of_obstacles = 0

function reset_level()
    player_vars.location_x = 1.0
    player_vars.location_y = 62.0
    player_vars.player_status = 0
    player_vars.velocity_x = 0
    player_vars.velocity_y = 0
    occupied_slots = {}
    enemy_list = {}
    num_of_enemies = 0
    enemies_killed = 0
    animation_data_once = {}
    reset_player()
    make_level()
end

function make_level()
    obstacles_created = 0
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
    if(enemies_killed >= enemy_requirement) then
        animate_once(128-8,52,{9},1,3,40,2)
        if(game_timer%30 ==0)then
            animate_once(128-8,52,{72,73,74,75,76,77,76,75,74,73},1,3,3,1)
        end
    else
        animate_once(128-8,52,{71},1,3,1,1)
    end

    for i in all(occupied_slots) do
        sspr( 11*8, 0, 8, 8, 11+i.x*16, 11+i.y*16,10,10)
    end
end