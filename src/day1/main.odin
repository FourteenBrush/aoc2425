package aoc

import "core:fmt"
import "core:time"
import "core:slice"
import "core:strings"

input := #load("input.txt", string)
input_copy := input

main :: proc() {
    part1()
    part2()
}

Pair :: struct {
    left, right: int,
}

part1 :: proc() {
    start := time.tick_now()
    pairs := make_soa(#soa[dynamic]Pair, 0, 1000)

    for line in strings.split_lines_iterator(&input) {
        left, len := parse_int(line)
        num_spaces :: 3
        right, _ := parse_int(line[len + num_spaces:]) 
        append(&pairs, Pair { left, right })
    }

    npairs := len(pairs)
    slice.sort(pairs.left[:npairs])
    slice.sort(pairs.right[:npairs])

    sum := 0
    for pair in pairs {
        sum += abs(pair.left - pair.right)
    }
    
    fmt.println("part1:", sum, time.tick_since(start))
}

part2 :: proc() {
    start := time.tick_now()
    pairs := make_soa(#soa[dynamic]Pair, 0, 1000)
    scores := make(map[int]int, 1000)

    for line in strings.split_lines_iterator(&input_copy) {
        left, len := parse_int(line)
        num_spaces :: 3
        right, _ := parse_int(line[len + num_spaces:]) 

        append(&pairs, Pair { left, right })
        scores[right] += 1
    }

    npairs := len(pairs)
    slice.sort(pairs.left[:npairs])
    slice.sort(pairs.right[:npairs])

    total_score := 0
    for num, n in scores {
        _ = slice.binary_search(pairs.left[:npairs], num) or_continue
        total_score += num * n
    }
    fmt.println("part2:", total_score, time.tick_since(start))
}

parse_int :: proc(s: string) -> (res, n: int) #no_bounds_check {
    for n < len(s) {
        b := s[n]
        if b < '0' || b > '9' do break
        res = res * 10 + int(b - '0')
        n += 1
    }
    return
}
