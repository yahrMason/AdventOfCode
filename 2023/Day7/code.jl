using DelimitedFiles, DataFrames
df = DataFrame(readdlm("2023/Day7/input.txt"),[:hand,:bid])
df.hand = string.(df.hand)

cards = ['A','K','Q','J','T','9','8','7','6','5','4','3','2']

# Part 1
function compute_hand_value(hand)
    x = collect(hand)
    counts = sort([sum(x .== y) for y in unique(x)])

    value = 1
    if counts == [5]
        value = 7
    elseif counts == [1,4]
        value = 6
    elseif counts == [2,3]
        value = 5
    elseif counts == [1,1,3]
        value = 4
    elseif counts == [1,2,2]
        value = 3
    elseif counts == [1,1,1,2]
        value = 2
    end
    return(value)
end

function compute_card_value(card, cards)
    findall(x -> x == card, cards)[1]
end

df.hand_value = compute_hand_value.(df.hand)
for i in 1:5
    df[!,Symbol(string("card",i,"_value"))] = map(x -> compute_card_value(collect(x)[i], cards), df.hand)
end
sort_cols = [order(:hand_value,rev=true), :card1_value, :card2_value, :card3_value, :card4_value, :card5_value]
sort!(df, sort_cols);
df.rank = reverse(1:size(df,1))
df.winnings = df.rank.*df.bid
sum(df.winnings)

# Part 2
df2 = df
new_cards = ['A','K','Q','T','9','8','7','6','5','4','3','2','J']
function compute_hand_value_joker(hand)
    alt_hands = map(x -> replace(hand, 'J' => x), new_cards[1:(end-1)])
    value = maximum(compute_hand_value.(alt_hands))
    return(value)
end

df2.hand_value = compute_hand_value_joker.(df2.hand)
for i in 1:5
    df[!,Symbol(string("card",i,"_value"))] = map(x -> compute_card_value(collect(x)[i], new_cards), df2.hand)
end
sort_cols = [order(:hand_value,rev=true), :card1_value, :card2_value, :card3_value, :card4_value, :card5_value]
sort!(df2, sort_cols);
df2.rank = reverse(1:size(df2,1))
df2.winnings = df2.rank.*df2.bid
sum(df2.winnings)