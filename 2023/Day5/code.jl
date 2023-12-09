inputs = readlines("2023/Day5/input.txt")

seeds = parse.(Int, split(replace(inputs[1], "seeds: " => "")," "))

seed_to_soil = inputs[4:51]
soil_to_fertalizer = inputs[54:76]
fertalizer_to_water = inputs[79:113]
water_to_light = inputs[116:138]
light_to_temperature = inputs[141:155]
temperature_to_humidity = inputs[158:168]
humidity_to_location = inputs[171:197]
maps = [
    seed_to_soil, soil_to_fertalizer, fertalizer_to_water, 
    water_to_light, light_to_temperature, temperature_to_humidity,
    humidity_to_location
]


# Part 1
src_to_dest = function(input, mp)
    m = hcat(map(x -> parse.(Int, split(x," ")), mp)...)'
    cond = (m[:,2] .<= input .<= m[:,2] + m[:,3])
    if sum(cond) == 1
        rng = m[cond,:]
        output = rng[1] + (input - rng[2])
    else
        output = input
    end
    return(output)
end

get_location = function(seed)
    x = seed
    for mp in maps
        x = src_to_dest(x, mp)
    end
    return(x)
end
minimum(get_location.(seeds))

# Part 2
seeds2 = vcat(seeds[1:2:19]', seeds[2:2:20]')'

minimum(get_location.(seeds2[1,:][1]:sum(seeds2[1,:])))
