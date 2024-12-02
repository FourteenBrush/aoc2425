package day2

import "core:fmt"
import "core:time"
import "core:strings"

import utils ".."

INT_BITS_MINUS_ONE :: size_of(int) * 8 - 1

input := #load("input.txt", string)
input_copy := input

main :: proc() {
    part1()
    part2()
}

part1 :: proc() {
	start := time.tick_now()
	safe := 0

	for levels in strings.split_lines_iterator(&input) {
		level_start := 0
		prev_level := 0
		prev_diff := 0
		bad := false

		for {
			level, n := utils.parse_int(levels[level_start:])
			level_start += n + 1

			if prev_level != 0 {
				diff := level - prev_level
				diff_abs := abs(diff)
				if diff_abs == 0 || diff_abs > 3 {
					bad = true
					break
				}

				if prev_diff != 0 {
					prev_diff_sign := (u64(prev_diff) >> INT_BITS_MINUS_ONE) & 1
					diff_sign := (u64(diff) >> INT_BITS_MINUS_ONE) & 1
					if prev_diff_sign != diff_sign {
						bad = true
						break
					}
				}
				prev_diff = diff
			}

			prev_level = level

			if level_start >= len(levels) do break
		}
		safe += int(!bad)
	}

	fmt.println(safe, time.tick_since(start))
}

part2 :: proc() {
	start := time.tick_now()
	safe := 0
    iteration := 0

	for levels in strings.split_lines_iterator(&input_copy) {
        defer iteration += 1
		level_start := 0
		prev_level := 0
		prev_diff := 0
        bad_levels := 0

		for {
			level, n := utils.parse_int(levels[level_start:])
			level_start += n + 1

			if prev_level != 0 {
				diff := level - prev_level
				diff_abs := abs(diff)
				if diff_abs == 0 || diff_abs > 3 {
                    //fmt.eprintfln("line %d: bad change from %d to %d", iteration + 1, prev_level, level)
                    bad_levels += 1
				}

				// check diff sign change
				if prev_diff != 0 {
					prev_diff_sign := (u64(prev_diff) >> INT_BITS_MINUS_ONE) & 1
					diff_sign := (u64(diff) >> INT_BITS_MINUS_ONE) & 1
					if prev_diff_sign != diff_sign {
                        //fmt.eprintfln("line %d: bad sign flip from %d to %d", iteration + 1, prev_level, level)
                        bad_levels += 1
					}
				}
				prev_diff = diff
			}

			prev_level = level

			if level_start >= len(levels) do break
		}
        //fmt.println(bad_levels)
        safe += int(bad_levels <= 1)
	}

	fmt.println(safe, time.tick_since(start))
}

abs :: proc(x: int) -> int {
	mask := x >> INT_BITS_MINUS_ONE // 0xfffffff if negative, else 0
	return (x + mask) ~ mask
}
