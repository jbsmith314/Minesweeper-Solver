# Minesweeper-Solver

This is my minesweeper solver that uses the free scripting software AutoHotkey, found at https://www.autohotkey.com/.

To run it, you would need to download AutoHotkey, download the minesweeper.ahk file, run the script, and press insert. It works with the easy version of minesweeper at https://g.co/kgs/TvMcLAi.

I'm working on getting the code to work for the medium and hard modes too. Here is a 4x sped up video of it solving 8 puzzles in a row:

https://github.com/jbsmith314/Minesweeper-Solver/assets/123589888/7d6a2830-2d48-4472-8532-c2332a9aa3fe

It still fails in the case where there are no obvious flags to place or obvious safe squares to uncover. In that case, it guesses a square and then reanalyzes. I'm working on the advanced logic right now so it can figure out the more complicated situations too.

Also, this solver was designed for the display of Minesweeper on my personal computer. Because the solver uses specific pixel coordinates, which could vary based on the monitor it is being run on, the code would have to be adjusted for it to work on other computers.
