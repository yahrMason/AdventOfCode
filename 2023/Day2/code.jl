inputs = readlines("Day2/input.txt")

# Part 1
valid_game_id = function(input)

    # Get the Input
    input_split = split(input, ": ")
    game_id = parse(Int, replace(input_split[1], "Game " => ""))
    sets = split(input_split[2], "; ")

    # Define Color Dict
    color_limit = Dict(
        "red" => 12,
        "green" => 13,
        "blue" => 14
    )

    valid = 1
    for set in sets
        # get all colors in set
        set_colors = split(set, ", ")
        # loop over color dict
        for (color, limit) in color_limit
            # grab the color from the set
            set_color = set_colors[occursin.(color, set_colors)]
            # compute how many of that color are in the set
            if length(set_color) > 0
                num = parse.(Int, join(filter(isdigit, collect(set_color[1]))))
            else
                num = 0
            end
            # if number exceeds limit -> not valid
            if num > limit
                valid = 0
                break
            end
        end
    end
    return(valid*game_id)
end

sum(valid_game_id.(inputs))


# Part 2
set_power = function(input)

    # Get the Input
    input_split = split(input, ": ")
    game_id = parse(Int, replace(input_split[1], "Game " => ""))
    sets = split(input_split[2], "; ")

    # Define Color Dict
    color_count = Dict(
        "red" => 0,
        "green" => 0,
        "blue" => 0
    )


    for set in sets
        # get all colors in set
        set_colors = split(set, ", ")
        # loop over color dict
        for (color, n) in color_count
            # grab the color from the set
            set_color = set_colors[occursin.(color, set_colors)]
            # compute how many of that color are in the set
            if length(set_color) > 0
                num = parse.(Int, join(filter(isdigit, collect(set_color[1]))))
            else
                num = 0
            end
            # if number exceeds limit -> not valid
            if num > n
            color_count[color] = num
            end
        end
    end

    power = prod(values(color_count))
    return(power)
end

sum(set_power.(inputs))