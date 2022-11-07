
num_of_enemies = 0
enemy_list = {}

enemy = {
    pos_x = 0,
    pos_y = 0,
    enemy_bounce = 0,
}

function enemy:new(pos_x_,pos_y_,enemy_bounce_)
    self.__index = self
    return setmetatable
    ({
    pos_x = pos_x_, pos_y = pos_y_, enemy_bounce = enemy_bounce_},
    self)
end

function update_enemy()
    for i in all(enemy_list) do
        for b in all(slash_hitbox) do
            if(i.pos_y+8 > b.y) then
                if(i.pos_x+8 > b.x) then
                    if(i.pos_y < b.y+8) then
                        if(i.pos_x < b.x+8) then
                                animate_once(player_vars.location_x-2,player_vars.location_y-2,{12,15},1,1,5,2)
                                animate_once(i.pos_x,i.pos_y,{13},1,1,60,2)
                                del(enemy_list,i)
                                num_of_enemies = num_of_enemies - 1
                                enemies_killed = enemies_killed + 1
                                break
                        end
                    end
                end
            end
        end
        if(i.enemy_bounce > 1 ) then
            i.enemy_bounce = 0
        end
        move_vector = vector_norm(vector(player_vars.location_x-i.pos_x,player_vars.location_y-i.pos_y))
        move_vector = vector_scale(move_vector,.3)
        i.pos_x = i.pos_x+move_vector.x+(sin(i.enemy_bounce)/10)
        i.pos_y = i.pos_y+move_vector.y+(sin(i.enemy_bounce)/10)
        i.enemy_bounce = i.enemy_bounce + 0.01
    end
end

function draw_enemy()
    for i in all(enemy_list) do
        sspr( 10*8, 8, 8, 8, i.pos_x,i.pos_y)
    end
end