inputs = readlines("Day3/input.txt")

input_matrix = hcat([collect(s) for s in inputs]...)
input_matrix = permutedims(input_matrix)

# coordinates
n = range(1,stop=size(input_matrix,1))
m = range(1,stop=size(input_matrix,2))
coords = vec(collect(Iterators.product(n,m)))

# Part 1
is_valid_coord = function(coord, matrix)
    return(all([
        1 <= coord[1] <= size(matrix,1),
        1 <= coord[2] <= size(matrix,2)
    ]))
end
is_number = function(coord, input_matrix)
    if is_valid_coord(coord, input_matrix)
        entry_value = input_matrix[coord...]
        # is this entry a number?
        return(isdigit(entry_value))
    else
        return false
    end
end
is_symbol = function(coord, input_matrix)
    if is_valid_coord(coord, input_matrix)
        entry_value = input_matrix[coord...]
        # is this entry a number?
        return(!(isdigit(entry_value) || entry_value == '.'))
    else
        return false
    end
end
get_neighbor_values = function(coord, input_matrix)
    offsets = sort(vec(collect(Iterators.product([-1,0,1],[-1,0,1]))))
    return([
        input_matrix[(coord .+ off)...] 
        for off in offsets 
        if is_valid_coord((coord .+ off),input_matrix)
    ])
end
symbol_in_neighbors = function(coord, input_matrix)
    neighbors = get_neighbor_values(coord, input_matrix)
    symbol_neighbors = filter(x -> !(isdigit(x) || x == '.'), neighbors)
    return(length(symbol_neighbors) > 0)
end
is_part_number = function(coord, input_matrix)
    return(all([
        is_valid_coord(coord, input_matrix),
        is_number(coord, input_matrix),
        symbol_in_neighbors(coord, input_matrix)
    ]))
end
coord_is_part_number = function(coord, input_matrix)

    entry_is_number = is_number(coord, input_matrix)
    entry_is_part_number = is_part_number(coord, input_matrix)

    # is one of the side neighbors a part number?
    if (entry_is_number & !entry_is_part_number)
        offsets = [(0,-1), (0,1)]
        for off in offsets
            off_side_is_number = true
            off_coord = coord
            while off_side_is_number
                off_coord = off_coord.+off
                off_side_is_number = is_number(off_coord, input_matrix)
                if is_part_number(off_coord, input_matrix)
                    entry_is_part_number = true
                    break
                end
            end
        end
    end

    return entry_is_part_number
end

row_nums = Vector{Int}[]
numbers_in_row = function(n, row)
    nums = Vector{Int}() 
    seq = Vector{Int}()
    for (m, value) in enumerate(row)
        coord = (n,m)
        is_end_of_row = (m == length(row))
        value_is_part_number = coord_is_part_number(coord, input_matrix)
        # if its a valid part, add to sequence
        if value_is_part_number
            push!(seq, parse(Int, value))
        end
        if !value_is_part_number | is_end_of_row
            # if there is anything in the sequence
            if length(seq) > 0
                # compute the number
                num = 0
                for digit in copy(seq)
                    num = num * 10 + digit
                end 
                # add the number to nums
                push!(nums, num)
                # clear the sequence
                empty!(seq)
            end
        end
    end
    return(nums)
end

for (n,row) in enumerate(eachrow(input_matrix))
    nums = numbers_in_row(n, row)
    push!(row_nums, nums)
end

print(sum(sum.(row_nums)))

# Part 2
is_star = function(coord, input_matrix)
    if is_valid_coord(coord, input_matrix)
        entry_value = input_matrix[coord...]
        # is this entry a number?
        return(entry_value == '*')
    else
        return false
    end
end

symbols = Dict(
    coord => Dict(
        "symbol" => input_matrix[coord...],
        "numbers" => []
    )
    for coord in coords
    if is_star(coord, input_matrix)
)

nums = Vector{Int}()
ixs = []
for (n,row) in enumerate(eachrow(input_matrix))
    ix = Vector{Int}()
    seq = Vector{Int}()
    for (m, value) in enumerate(row)
        is_end_of_row = (m == length(row))
        value_is_digit = isdigit(value)
        # if its a valid part, add to sequence
        if value_is_digit
            push!(seq, parse(Int, value))
            push!(ix, m)
        end
        if !value_is_digit | is_end_of_row
            # if there is anything in the sequence
            if length(seq) > 0
                # compute the number
                num = 0
                for digit in copy(seq)
                    num = num * 10 + digit
                end 
                # add the number to nums
                push!(nums, num)
                push!(ixs, [(n,ixm) for ixm in ix])
                # clear the sequence
                empty!(seq)
                empty!(ix)
            end
        end
    end
end
numbers = [
    Dict(
        "value" => x,
        "index" => y
    )
    for (x,y) in zip(nums, ixs)
];

for (coord, value) in symbols
    number = numbers[1]
    for number in numbers
        offsets = sort(vec(collect(Iterators.product([-1,0,1],[-1,0,1]))))
        edges = [coord .+ off for off in offsets]
        num_in_symbol = length(intersect(Set(number["index"]), Set(edges))) > 0
        if num_in_symbol
            push!(symbols[coord]["numbers"], number["value"])
        end
    end
end

sum_of_prods = 0
for (coord, value) in symbols
    if value["symbol"] == '*'
        len_nums = length(value["numbers"])
        if len_nums == 2
            
            sum_of_prods += Base.prod(value["numbers"]) 
        end
    end
end

sum_of_prods
# 36696397 to low