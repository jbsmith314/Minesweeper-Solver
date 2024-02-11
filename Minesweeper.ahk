#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;easy mode is an 8x10 grid
;625, 335
;685, 395
;1235, 810
;red flag pixel color: 0x0736F2
;blue 1 pixel color: 0xD27619
;green 2 pixel color: 0x3C8E38
;red 3 pixel color: 0x2F2FD3

Esc::ExitApp

Ins::

Top_Code:

flag_counter := 0
SetBatchLines, -1
pause := 100
SetDefaultMouseSpeed, 0
CoordMode, Pixel, Screen
field := []
MouseClick, L, 928, 645
sleep 250

rows := 8
cols := 10
square_offset := 68
dont_rescan := 0

Scan:
updated := 0
row_num := 1
col_num := 1
CoordMode, Pixel, Screen
Loop % rows {
	Loop % cols {
		if (old_field[(row_num - 1) * 10 + col_num] > -2) {
			field.Push(old_field[(row_num - 1) * 10 + col_num])
			Goto, NextSquare
		}
		top_left_x := 623 + (col_num - 1) * square_offset + 10
		top_left_y := 338 + (row_num - 1) * square_offset + 10
		bottom_right_x := top_left_x + 40
		bottom_right_y := top_left_y + 40
		;search for blue 1
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0xD27619,, FAST
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := 1
			Goto, NextSquare
		}
		;search for green 2
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x3C8E38,, FAST
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := 2
			Goto, NextSquare
		}
		;search for red 3
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x2F2FD3,, FAST
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := 3
			Goto, NextSquare
		}
		;search for 4
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0xA21F7B,, FAST ;0xA2237D
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := 4
			Goto, NextSquare
		}
		;search for yellow 5
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x008FFF,, FAST
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := 5
			Goto, NextSquare
		}
		;search for red flag
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x0736F2,, FAST
		if (xPos > 0) {
			field[(row_num - 1) * 10 + col_num] := -1
			Goto, NextSquare
		}
		;search for two green colors
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x51D7AA,, FAST  ;lighter green
		PixelSearch, xPos2, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x49D1A2,, FAST ;darker green
		if (xPos > 0 or xPos2 > 0) {
			field[(row_num - 1) * 10 + col_num] := -2
			Goto, NextSquare
		}
		;search for two tan colors
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x9FC2E5,, FAST ;lighter tan
		PixelSearch, xPos2, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x99B8D7,, FAST ;darker tan
		if (xPos > 0 or xPos2 > 0) {
			field[(row_num - 1) * 10 + col_num] := 0
			Goto, NextSquare
		}
		;search for game over screen sky color
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0xF9C14D,, FAST
		if (xPos > 0) {
			flag_counter := 10
			;Goto, Exittt2
		}
		field[(row_num - 1) * 10 + col_num] := 99
		NextSquare:
		col_num++
	}
	col_num = 1
	row_num++
}
dont_rescan := 0

;counter := 1
;Loop % rows * cols {
	;MsgBox % field[counter]
	;counter++
;}

;for every square
	;if is a number (field[index] > 0)
		;count flags and open spots around
		;if flags == number:
			;click all -2 neighbors
			;Goto Scan
		;else if flags + open spots == number:
			;right click all -2 neighbors
			;change all -2 neighbors to -1
	;counter++

Poopypants:
done_something := 0
new_clicks := []
counter := 1
Loop % rows * cols {
	if (field[counter] > 0) {
		neighbors := []
		;left neighbor
		if (Mod(counter, 10) != 1) {
			neighbors.Push(counter - 1)
		}
		;top left neighbor
		if (Mod(counter, 10) != 1 && counter > 10) {
			neighbors.Push(counter - 11)
		}
		;top neighbor
		if (counter > 10) {
			neighbors.Push(counter - 10)
		}
		;top right neighbor
		if (Mod(counter, 10) != 0 && counter > 10) {
			neighbors.Push(counter - 9)
		}
		;right neighbor
		if (Mod(counter, 10) != 0) {
			neighbors.Push(counter + 1)
		}
		;bottom right neighbor
		if (Mod(counter, 10) != 0 && counter < 71) {
			neighbors.Push(counter + 11)
		}
		;bottom neighbor
		if (counter < 71) {
			neighbors.Push(counter + 10)
		}
		;bottom left neighbor
		if (Mod(counter, 10) != 1 && counter < 71) {
			neighbors.Push(counter + 9)
		}
		neighbor_flags := []
		neighbor_greens := []
		neighbor_counter := 1
		Loop % neighbors.Length() {
			if (field[neighbors[neighbor_counter]] == -1) {
				neighbor_flags.Push(neighbors[neighbor_counter])
			} else if (field[neighbors[neighbor_counter]] == -2) {
				neighbor_greens.Push(neighbors[neighbor_counter])
			}
			neighbor_counter++
		}
		if (neighbor_flags.Length() == field[counter]) {
			if (neighbor_greens.Length() > 0) {
				click_counter := 1
				Loop % neighbor_greens.Length() {
					if (Mod(neighbor_greens[click_counter], 10) == 0) {
						x_coord := 625 + 9 * square_offset + 32
						y_coord := 335 + ((neighbor_greens[click_counter] - 10) / 10) * square_offset + 30
					} else {
						x_coord := 625 + (Mod(neighbor_greens[click_counter], 10) - 1) * square_offset + 32
						y_coord := 335 + ((neighbor_greens[click_counter] - Mod(neighbor_greens[click_counter], 10)) / 10) * square_offset + 30
					}
					CoordMode, Mouse, Screen
					MouseClick, L, x_coord, y_coord
					field[neighbor_greens[click_counter]] := 0
					new_clicks.Push(neighbor_greens[click_counter])
					done_something := 1
					sleep pause
					click_counter++
				}
				MouseMove, 928, 645
			}
		} else if (neighbor_flags.Length() + neighbor_greens.Length() == field[counter]) {
			if (neighbor_greens.Length() > 0) {
				click_counter := 1
				Loop % neighbor_greens.Length() {
					if (Mod(neighbor_greens[click_counter], 10) == 0) {
						x_coord := 625 + 9 * square_offset + 32
							y_coord := 335 + ((neighbor_greens[click_counter] - 10) / 10) * square_offset + 30
					} else {
						x_coord := 625 + (Mod(neighbor_greens[click_counter], 10) - 1) * square_offset + 32
						y_coord := 335 + ((neighbor_greens[click_counter] - Mod(neighbor_greens[click_counter], 10)) / 10) * square_offset + 30
					}
					CoordMode, Mouse, Screen
					MouseClick, R, x_coord, y_coord
					flag_counter++
					done_something := 1
					sleep pause
					field[neighbor_greens[click_counter]] := -1
					click_counter++
				}
				MouseMove, 928, 645
				dont_rescan := 1
			}
		}
	}
	counter++
}

if (done_something == 1) {
	updated := 1
	sleep 250
	expand_upon := 0
	new_to_scan := []
	Expanddd:
	if (expand_upon == 1) {
		expand_upon := 0
		new_clicks := new_to_scan
	}
	index := 1
	Loop % new_clicks.Length() {
		if (Mod(new_clicks[index], 10) == 0) {
			x_coord := 625 + 9 * square_offset + 32
			y_coord := 335 + ((new_clicks[index] - 10) / 10) * square_offset + 30
		} else {
			x_coord := 625 + (Mod(new_clicks[index], 10) - 1) * square_offset + 32
			y_coord := 335 + ((new_clicks[index] - Mod(new_clicks[index], 10)) / 10) * square_offset + 30
		}
		top_left_x := x_coord - 20
		top_left_y := y_coord - 20
		bottom_right_x := top_left_x + 40
		bottom_right_y := top_left_y + 40
		try_again := 1
		TanTryAgain:
		;search for blue 1
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0xD27619,, FAST
		if (xPos > 0) {
			field[new_clicks[index]] := 1
			;MsgBox % "Read " . new_clicks[index] . " as a 1"
			Goto, NextSquare2
		}
		;search for green 2
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x3C8E38,, FAST
		if (xPos > 0) {
			field[new_clicks[index]] := 2
			;MsgBox % "Read " . new_clicks[index] . " as a 2"
			Goto, NextSquare2
		}
		;search for red 3
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x2F2FD3,, FAST
		if (xPos > 0) {
			field[new_clicks[index]] := 3
			;MsgBox % "Read " . new_clicks[index] . " as a 3"
			Goto, NextSquare2
		}
		;search for 4
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0xA21F7B,, FAST ;0xA2237D
		if (xPos > 0) {
			field[new_clicks[index]] := 4
			;MsgBox % "Read " . new_clicks[index] . " as a 4"
			Goto, NextSquare2
		}
		;search for yellow 5
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x008FFF,, FAST
		if (xPos > 0) {
			field[new_clicks[index]] := 5
			;MsgBox % "Read " . new_clicks[index] . " as a 5"
			Goto, NextSquare2
		}
		;search for red flag
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x0736F2,, FAST
		if (xPos > 0) {
			field[new_clicks[index]] := -1
			;MsgBox % "Read " . new_clicks[index] . " as a flag"
			Goto, NextSquare2
		}
		;search for two green colors
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x51D7AA,, FAST  ;lighter green
		PixelSearch, xPos2, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x49D1A2,, FAST ;darker green
		if (xPos > 0 or xPos2 > 0) {
			field[new_clicks[index]] := -2
			;MsgBox % "Read " . new_clicks[index] . " as a green"
			Goto, NextSquare2
		}
		;search for two tan colors
		PixelSearch, xPos, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x9FC2E5,, FAST ;lighter tan
		PixelSearch, xPos2, yPos, top_left_x, top_left_y, bottom_right_x, bottom_right_y, 0x99B8D7,, FAST ;darker tan
		if (xPos > 0 or xPos2 > 0) {
			;MsgBox % "Read " . new_clicks[index] . " as a tan (searched from (" . top_left_x . ", " . top_left_y . ") to (" . bottom_right_x . ", " . bottom_right_y . "))"
			if (try_again == 1) {
				try_again := 0
				;MsgBox, Trying again
				Goto, TanTryAgain
			}
			field[new_clicks[index]] := 0
			;left neighbor
			if (Mod(new_clicks[index], 10) != 1 && field[new_clicks[index] - 1] < -1) {
				new_to_scan.Push(new_clicks[index] - 1)
				field[new_clicks[index] - 1] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] - 1
			}
			;top neighbor
			if (new_clicks[index] > 10 && field[new_clicks[index] - 10] < -1) {
				new_to_scan.Push(new_clicks[index] - 10)
				field[new_clicks[index] - 10] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] - 10
			}
			;right neighbor
			if (Mod(new_clicks[index], 10) != 0 && field[new_clicks[index] + 1] < -1) {
				new_to_scan.Push(new_clicks[index] + 1)
				field[new_clicks[index] + 1] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] + 1
			}
			;bottom neighbor
			if (new_clicks[index] < 71 && field[new_clicks[index] + 10] < -1) {
				new_to_scan.Push(new_clicks[index] + 10)
				field[new_clicks[index] + 10] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] + 10
			}
			;top left neighbor
			if (Mod(new_clicks[index], 10) != 1 && new_clicks[index] > 10 && field[new_clicks[index] - 11] < -1) {
				new_to_scan.Push(new_clicks[index] - 11)
				field[new_clicks[index] - 11] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] - 11
			}
			;top right neighbor
			if (Mod(new_clicks[index], 10) != 0 && new_clicks[index] > 10  && field[new_clicks[index] - 9] < -1) {
				new_to_scan.Push(new_clicks[index] - 9)
				field[new_clicks[index] - 9] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] - 9
			}
			;bottom right neighbor
			if (Mod(new_clicks[index], 10) != 0 && new_clicks[index] < 71 && field[new_clicks[index] + 11] < -1) {
				new_to_scan.Push(new_clicks[index] + 11)
				field[new_clicks[index] + 11] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] + 11
			}
			;bottom left neighbor
			if (Mod(new_clicks[index], 10) != 1 && new_clicks[index] < 71 && field[new_clicks[index] + 9] < -1) {
				new_to_scan.Push(new_clicks[index] + 9)
				field[new_clicks[index] + 9] := 0
				expand_upon := 1
				;MsgBox % "expanding to" . new_clicks[index] + 9
			}
			Goto, NextSquare2
		}
		field[new_clicks[index]] := 99
		;MsgBox % "Read " . new_clicks[index] . " as nothing"
		NextSquare2:
		index++
	}
	if (expand_upon == 1) {
		Goto, Expanddd
	}
	;MsgBox, Reanalyzing
	Goto, Poopypants
}

if (flag_counter == 10) {
	Exittt2:
	sleep 2500
	MouseClick, L, 605, 866
	sleep 500
	MouseClick, L, 605, 866
	sleep 500
	Goto, Top_Code
}

if (updated == 1) {
	;MsgBox, rescanning
	Goto, Scan
} else { ;guess
	index := 1
	Loop % rows * cols {
		if (field[index] == -2) {
			if (Mod(index, 10) == 0) {
				x_coord := 625 + 9 * square_offset + 32
				y_coord := 335 + ((index - 10) / 10) * square_offset + 30
			} else {
				x_coord := 625 + (Mod(index, 10) - 1) * square_offset + 32
				y_coord := 335 + ((index - Mod(index, 10)) / 10) * square_offset + 30
			}
			CoordMode, Mouse, Screen
			MouseClick, L, x_coord, y_coord
			Goto, Scan
		}
		index++
	}
}

MsgBox, I'm not working

return













;advanced tactics in progress

;for each number
	;if it's greater than 0
		;if it has more flags + greens neighbors than its value
			;for each neighbor green (index i)
				;make array called hypothetical field
				;copy field to hypothetical field
				;change green with index i's value from -2 to -1
				;for all neighbors of this green
					;if neighboring flags equals value
						;set any neighboring greens to 0
					;else if neighboring flags plus neighboring greens is less than value
						;click green index i
						;goto Rescan

counter := 1
Loop % rows * cols {
	if (field[counter] > 0) {
		neighbors := []
		;left neighbor
		if (Mod(counter, 10) != 1) {
			neighbors.Push(counter - 1)
		}
		;top left neighbor
		if (Mod(counter, 10) != 1 && counter > 10) {
			neighbors.Push(counter - 11)
		}
		;top neighbor
		if (counter > 10) {
			neighbors.Push(counter - 10)
		}
		;top right neighbor
		if (Mod(counter, 10) != 0 && counter > 10) {
			neighbors.Push(counter - 9)
		}
		;right neighbor
		if (Mod(counter, 10) != 0) {
			neighbors.Push(counter + 1)
		}
		;bottom right neighbor
		if (Mod(counter, 10) != 0 && counter < 71) {
			neighbors.Push(counter + 11)
		}
		;bottom neighbor
		if (counter < 71) {
			neighbors.Push(counter + 10)
		}
		;bottom left neighbor
		if (Mod(counter, 10) != 1 && counter < 71) {
			neighbors.Push(counter + 9)
		}
		neighbor_flags := []
		neighbor_greens := []
		neighbor_counter := 1
		Loop % neighbors.Length() {
			if (field[neighbors[neighbor_counter]] == -1) {
				neighbor_flags.Push(neighbors[neighbor_counter])
			} else if (field[neighbors[neighbor_counter]] == -2) {
				neighbor_greens.Push(neighbors[neighbor_counter])
			}
			neighbor_counter++
		}
		if (neighbor_flags.Length() + neighbor_greens.Length() > field[counter]) {
			index := 1
			Loop % neighbor_greens.Length() {
				hypothetical_field := []
				field_counter := 1
				Loop % rows * cols {
					if (field_counter == neighbor_greens[index]) {
						hypothetical_field.Push(-1)
					} else {
						hypothetical_field.Push(field[field_counter])
					}
					field_counter++
				}
				neighbors2 := []
				;left neighbor
				if (Mod(neighbor_greens[index], 10) != 1) {
					neighbors2.Push(neighbor_greens[index] - 1)
				}
				;top left neighbor
				if (Mod(neighbor_greens[index], 10) != 1 && neighbor_greens[index] > 10) {
					neighbors2.Push(neighbor_greens[index] - 11)
				}
				;top neighbor
				if (neighbor_greens[index] > 10) {
					neighbors2.Push(neighbor_greens[index] - 10)
				}
				;top right neighbor
				if (Mod(neighbor_greens[index], 10) != 0 && neighbor_greens[index] > 10) {
					neighbors2.Push(neighbor_greens[index] - 9)
				}
				;right neighbor
				if (Mod(neighbor_greens[index], 10) != 0) {
					neighbors2.Push(neighbor_greens[index] + 1)
				}
				;bottom right neighbor
				if (Mod(neighbor_greens[index], 10) != 0 && neighbor_greens[index] < 71) {
					neighbors2.Push(neighbor_greens[index] + 11)
				}
				;bottom neighbor
				if (neighbor_greens[index] < 71) {
					neighbors2.Push(neighbor_greens[index] + 10)
				}
				;bottom left neighbor
				if (Mod(neighbor_greens[index], 10) != 1 && neighbor_greens[index] < 71) {
					neighbors2.Push(neighbor_greens[index] + 9)
				}
				neighbor_flags2 := []
				neighbor_greens2 := []
				neighbor_counter2 := 1
				Loop % neighbors2.Length() {
					if (hypothetical_field[neighbors2[neighbor_counter2]] == -1) {
						neighbor_flags2.Push(neighbors2[neighbor_counter2])
					} else if (hypothetical_field[neighbors2[neighbor_counter2]] == -2) {
						neighbor_greens2.Push(neighbors2[neighbor_counter2])
					}
					neighbor_counter2++
				}
				index++
			}
		}
	}
	index++
}