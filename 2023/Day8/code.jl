using DataFrames
input = readlines("2023/Day8/input.txt");

instructions = collect(input[1]);


input_split = split.(input[3:end], " = ");
nodes = map(x -> x[1], input_split);
LR = map(x -> x[2], input_split);
L = map(x->x[1], split.(replace.(LR, r"[\(\)]" => ""),", "));
R = map(x->x[2], split.(replace.(LR, r"[\(\)]" => ""),", "));
df = DataFrame(node = nodes, L = L, R = R);

function compute_steps(instructions, df)
    ix = 1
    steps = 1
    node = "AAA"
    while true
        if ix > size(instructions,1)
            ix = 1
        end
        x = instructions[ix]
        new_node = df[df.node .== node, Symbol(x)][1]
        if new_node == "ZZZ"
            break
            print(steps)
        else
            node = new_node
            steps += 1
            ix += 1
        end
    end
    return steps
end

compute_steps(instructions, df)

df.node