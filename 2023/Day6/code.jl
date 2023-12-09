using DelimitedFiles
inputs = readdlm("2023/Day6/input.txt")

times = inputs[1,2:end]
dists = inputs[2,2:end]

# Part 1
num_ways_to_win(time,dist) = sum(map(x -> x*(time-x),1:time) .> dist)
prod([num_ways_to_win(x,y) for (x,y) in zip(times, dists)])

# Part 2
time = parse(Int, join(string.(times)))
dist = parse(Int, join(string.(dists)))
num_ways_to_win(time,dist)