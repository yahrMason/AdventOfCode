inputs = readlines("Day1/input.txt")

## Part 1
get_number = function(input)
    nums = parse.(Int, filter(isdigit, collect(input)))
    return(10*first(nums) + last(nums))
end

sum(get_number.(inputs))

## Part 2
digit_map = Dict(
    "one" => "o1e",
    "two" => "t2o",
    "three" => "t3e",
    "four" => "f4r",
    "five" => "f5e",
    "six" => "s6x",
    "seven" => "s7n",
    "eight" => "e8t",
    "nine" => "n9e"
)

replace_map = function(s, map)
    for (old, new) in map
        s = replace(s, old => new)
    end
    return(s)
end

inputs2 = map(x -> replace_map(x, digit_map), inputs)
sum(get_number.(inputs2))