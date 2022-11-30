
num_of_enemies = 0
enemy_list = {}

enemy = {
    pos_x = 0,
    pos_y = 0,
    enemy_bounce = 0,
    follow_type = 0, -- 0 = PLAYER, 1 = LEVEL, 2 = PREDICTIVE
    follow_target = {},
    timer = -121
}

function enemy:new(pos_x_,pos_y_,enemy_bounce_)
    self.__index = self
    return setmetatable
    ({
    pos_x = pos_x_, pos_y = pos_y_, enemy_bounce = enemy_bounce_},
    self)
end

function update_poi(e)
    e.follow_target = {x=11+(flr(rnd(7))*16),y=11+(flr(rnd(7)*16))}
end

function update_enemy()
    for i in all(enemy_list) do
        if(i.timer) < 0 then
            goto update_continue
        end
        for b in all(slash_hitbox) do
            if(i.pos_y+8 > b.y) then
                if(i.pos_x+8 > b.x) then
                    if(i.pos_y < b.y+8) then
                        if(i.pos_x < b.x+8) then
                                animate_once(i.pos_x,i.pos_y,{64,65,66,67,68,69},1,1,5,1)
                                sfx(20)
                                del(enemy_list,i)
                                num_of_enemies = num_of_enemies - 1
                                enemies_killed = enemies_killed + 1
                                break
                        end
                    end
                end
            end
        end

        move_vector = vector(0,0)

        if(i.timer % 150 == 0) then
            move_choice = flr(rnd(100))
            if (move_choice < 50) then
                i.follow_type = 1
                update_poi(i)
            elseif (move_choice < 80) then
                i.follow_type = 2
            else 
                i.follow_type = 0
            end
        end

        if (i.follow_type == 1) then --follow level
            if(abs(i.follow_target.x - i.pos_x) < 3 or abs(i.follow_target.y - i.pos_y) < 3) then
                update_poi(i)
            end
            move_vector.x = i.follow_target.x - i.pos_x
            move_vector.y = i.follow_target.y - i.pos_y
        elseif (i.follow_type == 2) then --follow predict player
            move_vector.x = (player_vars.location_x+player_vars.velocity_x) - i.pos_x
            move_vector.y = (player_vars.location_y+player_vars.velocity_y) - i.pos_y
        else --follow player
            move_vector.x = player_vars.location_x - i.pos_x
            move_vector.y = player_vars.location_y - i.pos_y
        end

        if(i.enemy_bounce > 1 ) then
            i.enemy_bounce = 0
        end
        move_vector = vector_norm(move_vector)
        move_vector = vector_scale(move_vector,.6)

        if(abs(move_vector.x) > 3 or abs(move_vector.y) > 3) then
            move_vector.x = 0
            move_vector.y = 0
        end

        i.pos_x = i.pos_x+move_vector.x+(sin(i.enemy_bounce)/10)
        i.pos_y = i.pos_y+move_vector.y+(sin(i.enemy_bounce)/10)
        i.enemy_bounce = i.enemy_bounce + 0.01

        ::update_continue::
        i.timer = i.timer + 1
    end
end

function update_boss()

    if(boss_timer > 600) then
        boss_animation = {134}
        sfx(24)
        boss_eye = 8
        boss_timer = boss_timer + 1
        if(boss_timer > 900) then
            boss_animation= {128,131}
            boss_eye = 6
            boss_timer = -120
            sfx( 24,-2)
            return
        end
        return
    end

    if(boss_timer < 0) then
        boss_speed = .7
    end
    if(boss_timer == 0) then
        boss_speed = .2
    end

    for b in all(slash_hitbox) do
        if(boss_pos.y+24 > b.y) then
            if(boss_pos.x+24 > b.x) then
                if(boss_pos.y < b.y+24) then
                    if(boss_pos.x < b.x+24) then
                            animate_once(boss_pos.x,boss_pos.y,{64,65,66,67,68,69},1,1,5,1)
                            boss_health = boss_health - 1
                            if(boss_health <= 0) then
                                boss_win = 1
                            end
                            sfx(20)
                    end
                end
            end
        end
    end

    move_vector = vector(0,0)

    move_vector.x = player_vars.location_x - boss_pos.x
    move_vector.y = player_vars.location_y - boss_pos.y

    if(boss_bounce > 1 ) then
        boss_bounce = 0
    end
    move_vector = vector_norm(move_vector)
    move_vector = vector_scale(move_vector,boss_speed)

    if(abs(move_vector.x) > 1 or abs(move_vector.y) > 1) then
        move_vector.x = 0
        move_vector.y = 0
    end

    boss_pos.x = boss_pos.x+move_vector.x+(sin(boss_bounce)/10)
    boss_pos.y = boss_pos.y+move_vector.y+(sin(boss_bounce)/10)
    boss_bounce = boss_bounce + 0.01

    boss_timer = boss_timer + 1
end

function draw_boss()
    animate(boss_animation,boss_pos.x,boss_pos.y,boss_animation,3,3,60)
    player_vector = vector(0,0)

    player_vector.x = player_vars.location_x - boss_pos.x
    player_vector.y = player_vars.location_y - boss_pos.y

    eye_size = 0
    if(boss_eye == 8)then
        eye_size = 1
        player_vector = vector(0,0)
    end

    player_vector = vector_norm(player_vector)
    player_vector = vector_scale(player_vector,1)
    rectfill( boss_pos.x+8+player_vector.x, boss_pos.y+7+player_vector.y, boss_pos.x+8+player_vector.x+eye_size, boss_pos.y+8+player_vector.y, boss_eye )
    rectfill( boss_pos.x+8+10+player_vector.x, boss_pos.y+7+player_vector.y-1, boss_pos.x+8+10+player_vector.x+eye_size, boss_pos.y+8+player_vector.y-1, boss_eye )
end

function draw_enemy()
    for i in all(enemy_list) do
        if(i.timer) >= 0 then
            sspr( 10*8, 8, 8, 8, i.pos_x,i.pos_y)
            spr(70,i.pos_x-6,i.pos_y+(sin(i.enemy_bounce))-1)
        elseif(i.timer == -120) then
            sfx(23)
            animate_once(i.pos_x,i.pos_y,{52,53,54,55,56,57,55,56,57,55,56,57,46},1,1,3,1)
            animate_once(i.pos_x,i.pos_y,{27,27,28,28,29,29,28,28,29,29,29,29,28,28,29,29,27,27,15,15,27,30,31,31,31,42,42,42,42,43,43,43,43,43,44,44,44,45,45,26,26},1,1,3,1)
            animate_once(i.pos_x,i.pos_y,{32,33,34,35,36,37,38},1,1,3,2)
            animate_once(i.pos_x,i.pos_y,{48,49,50,51},1,1,6,1)
        else
            spr(70,i.pos_x-6,i.pos_y+(i.timer*2)-1)
        end
    end
end