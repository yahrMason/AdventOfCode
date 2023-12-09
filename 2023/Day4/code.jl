inputs = readlines("2023/Day4/input.txt")

# Part 1
card_points = function(input)
    input_split = split(input, '|');
    # Winning Numbers
    winning_numbers = split(strip(split(input_split[1], ':')[2]),' ');
    filter!(x->x!="",winning_numbers);
    winning_numbers = parse.(Int, winning_numbers);
    # Our Numbers
    our_numbers = split(strip(input_split[2]),' ');
    filter!(x->x!="",our_numbers);
    our_numbers = parse.(Int, our_numbers);

    n_nums = length(intersect(winning_numbers, our_numbers))
    points = 0
    if n_nums > 0
        points = 2^(n_nums-1)
    end
    return(points)
end

sum(card_points.(inputs))