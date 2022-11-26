-- vector
-- based on PICO-8 Vector Calculation Library from https://www.lexaloffle.com/bbs/?tid=42625
function vector(sx,sy)
    return {
        x=(sx and sx or 0),
        y=(sy and sy or 0),
    }
end

function vector_inner(v1,v2)
    return ( (v1.x*v2.x) + (v1.y*v2.y) )
end

function vector_add(v1,v2)
    return vector(v1.x+v2.x,v1.y+v2.y)
end

function vector_minus(v1,v2)
    return vector(v1.x-v2.x,v1.y-v2.y)
end

function vector_multi(v1,v2)
    return vector(v1.x*v2.x,v1.y*v2.y)
end

function vector_scale(v1,scale)
    return vector(v1.x*scale,v1.y*scale)
end

function vector_length(v)
    return sqrt(v.x^2+v.y^2)
end

function vector_norm(v)
    local mag=vector_length(v)
    if mag != 0 then
        return vector(v.x/mag,v.y/mag)
    end
    return vector(0,0)
end

function vector_dist(v1,v2)
    local x=abs(abs(v1.x)-abs(v2.x))
    local y=abs(abs(v1.y)-abs(v2.y))
    return x+y
end