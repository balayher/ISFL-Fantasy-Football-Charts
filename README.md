# ISFL-Fantasy-Football-Charts

Takes a CSV file of ISFL Fantasy Football scoring data and converts it into position-based top 10 charts utilizing R (RStudio).

Created using:
RStudio 2025.09.0+387 "Cucumberleaf Sunflower" Release (af5fc22a687c0f462ee27c6afeeee38ee46507b9, 2025-09-11) for windows


## RStudio Setup

Adjust the following variables on lines 6-8 & 26-27 to use properly:
- mainDir: the file folder location of your CSV data file
- plotDir: the file folder location for your output graphs (set to mainDir if you do not want a separate folder for the graphs)
- fanFile: the name of your CSV data file.
- outFigSzn: the Season number of your data (recommended to add a _ at the end for output file readability)
- outFigWeek: the Week number of your data (recommended to add a _ at the end for output file readability)

The output graphs will end in "<Position>.jpg", where <Position> is one of QB, OL, K, DL, LB, DB, RB1, RB2, WR1, WR2, or WR3.

## CSV Setup

To work properly, the CSV must have the following columns:
- Player (Name of the player)
- Pos (Position of the player; QB, RB, WR, TE, OL, K, DT, DE, LB, CB, S are accepted positions)
- Score (Total fantasy points of the player)
- Increase (Fantasy points scored since previous update)
- Rank (Rank of player by position 1-10 (1-20 for RB, 1-30 for WR; WR + TE are considered the same position as are DT + DE and CB + S)
- Prev (Previous rank of player, typically the rank from the previous update or pre-season predicted rank. N/A or NR may be used if the player was not ranked before)

Requires exactly one player of each rank 1-10 (1-20 for RB, 1-30 for WR) for each position to function properly. WR + TE are considered the same position, as are DT + DE and CB + S. 
Players ranked above these values will be removed automatically.
