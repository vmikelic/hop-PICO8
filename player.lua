scale_ = 23.0;

player_vars=
{
    location_x = 1.0,
    location_y = 62.0,
    delta_x = 0,
    delta_y = 0,
    velocity_x=0.0,
    velocity_y=0.0,
    player_speed = 1200.0/scale_,
    player_width = 4.0,
    player_height = 4.0,
    player_status = 0, -- 0 = grounded, 1 = jumping, 2 = slash
    slash_time = 0,
    slash_speed = 0,
    invuln_time = 0,
    slash_hitbox = {}
}

function player_level_collision()
    y_basis = vector(0,1)
    x_basis = vector(1,0)
    movement_unit = vector_norm(vector(player_vars.delta_x,player_vars.delta_y))
    t_min = 0
    t_max = 99999999
    side_hit = 0
    for i in all(occupied_slots) do
        box_x = 12+i.x*16
        box_y = 12+i.y*16
        if(box_y+9 > player_vars.location_y+player_vars.delta_y) then
            if(box_x+9 > player_vars.location_x+player_vars.delta_x) then
                if(box_y < player_vars.location_y+player_vars.delta_y+4) then
                    if(box_x < player_vars.location_x+player_vars.delta_x+4) then
                        delta = vector((box_x+4.5) - (player_vars.location_x+2),(box_y+4.5) - (player_vars.location_y+2))             
                        E = vector_inner(x_basis,delta) --based on https://www.opengl-tutorial.org/miscellaneous/clicking-on-objects/picking-with-custom-ray-obb-function/
                        F = vector_inner(movement_unit,x_basis)
                        T1 = (E-6.5)/F
                        T2 = (E+6.5)/F
                        if (T1>T2) then
                            w=T1
                            T1=T2
                            T2=w
                        end
                        if (T1>=t_min) then
                            t_min = T1
                            if(F<0) then
                                side_hit = bor(side_hit,0x2)
                                side_hit = bor(side_hit,0x4) --xaxis is min bit
                            elseif(F>0) then
                                side_hit = bor(side_hit,0x1)
                                side_hit = bor(side_hit,0x4) --xaxis is min bit
                            end
                        end
                        if (T2<t_max) then
                            t_max = T2
                        end
                        E = vector_inner(y_basis,delta)
                        F = vector_inner(movement_unit,y_basis)
                        T1 = (E-6.5)/F
                        T2 = (E+6.5)/F
                        if (T1>T2) then
                            w=T1
                            T1=T2
                            T2=w
                        end
                        if (T1>=t_min) then
                            t_min = T1
                            if(F<0) then
                                side_hit = bor(side_hit,0x10)
                                side_hit = bor(side_hit,0x20)
                                side_hit = band(side_hit,~0x4) 
                            elseif(F>0) then
                                side_hit = bor(side_hit,0x8)
                                side_hit = bor(side_hit,0x20) 
                                side_hit = band(side_hit,~0x4)
                            end
                        end
                        if (T2<t_max) then
                            t_max = T2
                        end

                        reflection_normal = vector(0,0)

                        if(band(side_hit,0x4) != 0) then
                            if(band(side_hit,0x1) != 0) then--left
                                reflection_normal  = vector(-1,0)
                            elseif(band(side_hit,0x2) != 0) then--right
                                reflection_normal  = vector(1,0)
                            end
                        elseif(band(side_hit,0x20) != 0) then
                            if(band(side_hit,0x8) != 0) then--top
                                reflection_normal  = vector(0,1)
                            elseif(band(side_hit,0x10) != 0) then--bottom
                                reflection_normal  = vector(0,-1)
                            end
                        end

                        velocity_adjust = vector_scale(reflection_normal,vector_inner(vector(player_vars.velocity_x,player_vars.velocity_y),reflection_normal));
                        player_vars.velocity_x = player_vars.velocity_x - velocity_adjust.x
                        player_vars.velocity_y = player_vars.velocity_y - velocity_adjust.y

                        movement_adjust = vector_scale(reflection_normal,vector_inner(vector(player_vars.delta_x,player_vars.delta_y),reflection_normal));
                        vector_add(movement_adjust,vector_scale(reflection_normal,1.01))

                        player_vars.delta_x = player_vars.delta_x - movement_adjust.x
                        player_vars.delta_y = player_vars.delta_y - movement_adjust.y
                    end
                end
            end
        end
    end
end

function handle_slash()
    if(player_vars.slash_time < 0) then
        player_vars.slash_time = player_vars.slash_time + 1
    end

    if(player_vars.invuln_time > 0) then
        player_vars.invuln_time = player_vars.invuln_time - 1
    end

    if(player_vars.slash_time > -40) then
        slash_hitbox = {}
    end

    if(player_vars.player_status != 2) then
        return
    end

    if(mouse_left_hold == false) then
        player_vars.invuln_time = 20
        mouse_vector = vector_norm(vector((mouse_x-1)-player_vars.location_x,(mouse_y-1)-player_vars.location_y))
        add_vel = vector_scale(mouse_vector,player_vars.slash_speed+135)
        x_begin = player_vars.location_x-2
        y_begin = player_vars.location_y-2
        x_end = x_begin
        y_end = y_begin
        slash_animation = {10,15}
        for x = 1,(player_vars.slash_speed+135)/20,1 do
            animate_once(x_end,y_end,slash_animation,1,1,3,1)
            add(slash_hitbox,{x=x_end,y=y_end})
            x_end = x_end + (mouse_vector.x*8)
            y_end = y_end + (mouse_vector.y*8)
            slash_animation = {}
            for z = 1,x+1,1 do
                add(slash_animation,15,z)
            end
            add(slash_animation,10,x+1)
        end
        slash_vector = vector(x_end-x_begin,y_end-y_begin)

        player_vars.velocity_x = add_vel.x;
        player_vars.velocity_y = add_vel.y
        player_vars.player_status = 0;
        player_vars.slash_time = -60;
    end
end

function player_enemy_collision()
    for i in all(enemy_list) do
        if(i.pos_y+8 > player_vars.location_y) then
            if(i.pos_x+8 > player_vars.location_x) then
                if(i.pos_y+1 < player_vars.location_y+4) then
                    if(i.pos_x+1 < player_vars.location_x+4) then
                            if(player_vars.invuln_time == 0) then
                                lost = true
                            end
                    end
                end
            end
        end
    end
end

function update_player_movement()
    --left shift
    if(player_vars.player_status != 2) then
        if (btn(4,1)) then
            player_vars.player_status = 1;
        else
            player_vars.player_status = 0;
        end
    end

    acceleration = vector(0,0)
    if (btn(0,1)) then 
            acceleration.x -= 1;
    end
    if (btn(1,1)) then 
            acceleration.x += 1;
    end
    if (btn(2,1)) then 
            acceleration.y -= 1;
    end
    if (btn(3,1)) then 
            acceleration.y += 1;
    end

    if (acceleration.x != 0) then 
            if (acceleration.y != 0) then 
                acceleration = vector_scale(acceleration,0.707106)
            end
    end

    if(player_vars.slash_time <= -50 or 
       player_vars.player_status == 2) then
        acceleration.x = 0
        acceleration.y = 0
    end

    --friction based on PM_Friction from halflife/pm_chared.c at https://github.com/ValveSoftware/halflife
    if((player_vars.player_status == 0 and player_vars.slash_time > -50 ) or 
       player_vars.player_status == 2) then

        speed = vector_length(vector(player_vars.velocity_x,player_vars.velocity_y)) 
        friction = 4;
        drop = 0;
        control = 0;
        if (speed < 100/scale_) then
            control = 100/scale_;
        else
            control = speed;
        end
        drop += (control*friction*delta_t);
        newspeed = speed - drop;
        if (newspeed < 0) then
            newspeed = 0;
        end
        if (newspeed != speed) then
            newspeed /= speed;
        end
        player_vars.velocity_x *= newspeed;
        player_vars.velocity_y *= newspeed;
        minus = vector_scale(vector(player_vars.velocity_x,player_vars.velocity_y),(1-newspeed));
        player_vars.velocity_x -= minus.x;
        player_vars.velocity_y -= minus.y;

    end

    --acceleration based on PM_Accelerate from halflife/pm_chared.c at https://github.com/ValveSoftware/halflife
    current_speed = vector_inner(vector(player_vars.velocity_x,player_vars.velocity_y),acceleration)
    addspeed = player_vars.player_speed - current_speed;

    if(addspeed > 0) then
        accel = 10.0;
        accel_speed = accel * delta_t * player_vars.player_speed;
        if(accel_speed > addspeed) then
            accel_speed = addspeed;
        end
        acceleration = vector_scale(acceleration,accel_speed)
        player_vars.velocity_x += acceleration.x;
        player_vars.velocity_y += acceleration.y;
    end

    --move x / collision
    player_vars.delta_x = player_vars.velocity_x * (delta_t);
    if(player_vars.location_x + player_vars.delta_x < 0) then
        player_vars.velocity_x = 0;
        player_vars.delta_x = 0;
    end
    if(player_vars.location_x + player_vars.delta_x > 125) then
        player_vars.velocity_x = 0;
        player_vars.delta_x = 0;
    end
    
    --move y / collision
    player_vars.delta_y = player_vars.velocity_y * (delta_t);
    if(player_vars.location_y + player_vars.delta_y < 0) then
        player_vars.velocity_y = 0;
        player_vars.delta_y = 0;
    end
    if(player_vars.location_y + player_vars.delta_y > 125) then
        player_vars.velocity_y = 0;
        player_vars.delta_y = 0;
    end

    player_level_collision()

    player_vars.location_x += player_vars.delta_x;
    player_vars.location_y += player_vars.delta_y;
end

function draw_player()
    if(player_vars.velocity_x>=0) then
        animate_once(player_vars.location_x,player_vars.location_y,{6},1,1,1,1)
    else
        animate_once(player_vars.location_x,player_vars.location_y,{5},1,1,1,1)
    end
end

function player_check_goal()
    if(player_vars.location_x+4 > 121) then
        if(player_vars.location_y+4 > 53) then
            if(player_vars.location_y < 53+23) then
                reset_level()
            end
        end
    end
end