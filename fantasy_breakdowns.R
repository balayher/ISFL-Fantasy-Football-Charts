rm(list = ls()) # clear environment
require(ggplot2)
require(dplyr)
library(ggtext)

mainDir <- 'D:\\RStudio\\isfl\\' # file folder location
plotDir <- paste0(mainDir, 'Charts\\') # name of output folder
fanFile <- paste0(mainDir, 'S61 Fantasy Breakdowns - Export W4.csv') # name of data csv

if (!file.exists(fanFile)) { 
  stop('MISSING FILE: ', fanFile)
} # check if file exists, stops if not

# graph parameters
fDim <- c(3, 2) # plot dimensions: width, height (conditions bar plot)
fR <- 300 # image resolution (DPI)
xLim <- c(0.5, 11) # x-axis range
barAlpha <- 0.8 # alpha level of mean bars  

# graph text
szTtl <- 7 # size of title
szAxi <- 4.5 # size of axis titles
szTxt <- 4 # size of axis text

# output figure name, adjust as needed
outFigSzn <- 'S61_'
outFigWeek <- 'Week_4_'
outFigEnd <- '.jpg'

dfBase <- read.csv(fanFile, header = TRUE) # convert csv to data frame

# assign color based on team
dfBase$colors <- case_when( 
  dfBase$Team == 'BAL' ~ '#E9AB00',
  dfBase$Team == 'BFB' ~ '#51075F',
  dfBase$Team == 'COL' ~ '#BF0A30',
  dfBase$Team == 'CTC' ~ '#6807DE',
  dfBase$Team == 'OSK' ~ '#1C3994',
  dfBase$Team == 'SAR' ~ '#38A6FA',
  dfBase$Team == 'YKW' ~ '#040404',
  dfBase$Team == 'AZ' ~ '#C21111',
  dfBase$Team == 'AUS' ~ '#008080',
  dfBase$Team == 'HON' ~ '#0B52DB',
  dfBase$Team == 'NOLA' ~ '#412879',
  dfBase$Team == 'NYS' ~ '#C0C0C0',
  dfBase$Team == 'OCO' ~ '#E75900',
  dfBase$Team == 'SJS' ~ '#8F825F',
  TRUE ~ '#000000')

# assign score color based on if player is doing good (50+) or bad (<40)
dfBase$Previous <- case_when(
  dfBase$Increase < 40 ~ '#FF0000',
  dfBase$Increase >= 50 ~ '#009900',
  TRUE ~ '#000000')

dfSort <- arrange(dfBase, Rank) # Sorts the dataframe by rank to ensure proper order when graphing

dfQB <- subset(dfSort, Pos == 'QB' & Rank < 11) # Separate out Quarterbacks
dfRB <- subset(dfSort, Pos == 'RB' & Rank < 21) # Separate out Running Backs
dfRBOne <- subset(dfRB, Rank < 11) # Limit to top 10 RBs
dfRBTwo <- subset(dfRB, Rank > 10) # Limit to 11-20 RBs
dfRBTwo$Rank <- dfRBTwo$Rank - 10 # Adjust rank on 11-20 RBs for graphing purposes
dfWR <- subset(dfSort, (Pos == 'WR' | Pos == 'TE') & Rank < 31) # Separate out Wide Receivers & Tight Ends
dfWROne <- subset(dfWR, Rank < 11) # Limit to top 10 WR/TEs
dfWRTwo <- subset(dfWR, Rank > 10 & Rank < 21) # Limit to 11-20 WR/TEs
dfWRThree <- subset(dfWR, Rank > 20) # Limit to 21-30 WR/TEs
dfWRTwo$Rank <- dfWRTwo$Rank - 10 # Adjust rank on 11-20 WR/TEs for graphing purposes
dfWRThree$Rank <- dfWRThree$Rank - 20 # Adjust rank on 21-30 WR/TEs for graphing purposes
dfOL <- subset(dfSort, Pos == 'OL' & Rank < 11) # Separate out Offensive Line
dfK <- subset(dfSort, Pos == 'K' & Rank < 11) # Separate out Kickers
dfDL <- subset(dfSort, (Pos == 'DT' | Pos == 'DE') & Rank < 11) # Separate out Defensive Line
dfLB <- subset(dfSort, Pos == 'LB') # Separate out Linebackers
dfDB <- subset(dfSort, (Pos == 'CB' | Pos == 'S') & Rank < 11) # Separate out Defensive Backs

for (i in 1:11) { # QB, OL, K, DL, LB, DB, RB1, RB2, WR1-3
  dfPlot <- switch(i, dfQB, dfOL, dfK, dfDL, dfLB, dfDB, 
                      dfRBOne, dfRBTwo, dfWROne, dfWRTwo, dfWRThree) # determine which position group to use
  outFigPos <- switch(i, 'QB','OL', 'K', 'DL', 'LB', 'DB', 
                         'RB1', 'RB2', 'WR1', 'WR2', 'WR3') # adds position type to output file name
  outFig <- paste0(outFigSzn, outFigWeek, outFigPos, outFigEnd) # output file name
  outPath <- paste0(plotDir, outFig) # file path
  posTitle <- switch(i, 'Quarterbacks',' Offensive Line', 'Kickers',
                     'Defensive Line', 'Linebackers', 'Defensive Backs',
                     'Running Backs (1-10)', 'Running Backs (11-20)',
                     'Wide Receivers (1-10)', 'Wide Receivers (11-20)', 
                     'Wide Receivers (21-30)') # graph title
  yLim <- c(0, 100) # default y-axis values
  
  # adjust y-axis to fit the range of scores at each position (use numbers divisible by 10 for best results)
  yLim[2] <- switch(i, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100) # qb ol k dl lb db rb 1-2 wr 1-3
  yBreaks <- seq(yLim[1], yLim[2], yLim[2]/10)
  
  # create graph
  ggplot(dfPlot, aes(x = Rank, y = Score, color = Rank, fill = Rank)) +
    geom_bar(stat = 'identity', width = 0.9, color = 'black', 
             linewidth = 0.1, fill = dfPlot$colors) +
    coord_cartesian(ylim = yLim, xlim = xLim, clip = "off") +
    theme_minimal() +
    theme(plot.background = element_rect(fill = 'white', color = 'white'),
          plot.title = element_text(size = szTtl, hjust = '0.5', margin = margin(0,0,5,0), face = 'bold'), # format plot title (if any)
          axis.title.x = element_text(size = szAxi, color = 'black', margin = margin(5,0,0,0)), # format x-axis title margin (top, right, bottom, left)
          axis.title.y = element_text(size = szAxi, color = 'black', margin = margin(0,0,0,0)), # format y-axis title margin (top, right, bottom, left)
          axis.text.x = element_text(size = szTxt, color = 'black', margin = margin(1,0,1,0), vjust = 0.5, face = 'bold'), # format x-axis text 
          axis.text.y = element_text(size = szAxi, color = 'black', margin = margin(0,0,0,0), hjust = 0.5, face = 'bold'),
          axis.line = element_line(color = 'black', linewidth = 0.25),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(linewidth = 0.25), 
          panel.grid.minor = element_blank(),
          legend.position = "none"
    ) +
    annotate('richtext', # adds score to bottom of graph
             x = dfPlot$Rank,
             y = yLim[2] / 15,
             label = dfPlot$Score,
             hjust = 0.5,
             size = 1.4,
             label.padding = unit(0.1, "lines"),
             color = 'black',
             fill = 'white'
    ) +
    annotate('richtext', # adds score increase from previous recap
             x = dfPlot$Rank,
             y = yLim[2] / 7,
             label = paste0("+", dfPlot$Increase),
             hjust = 0.5,
             size = 1.4,
             label.padding = unit(0.1, "lines"),
             color = dfPlot$Previous,
             fill = 'white'
    ) +
    labs(title = posTitle, x = NULL, y = NULL) +
    scale_x_continuous(labels = paste0(dfPlot$Player, ' (', dfPlot$Prev, ')'), # 'player name (previous recap rank)'
                       breaks = seq(1, 10, 1), expand = expansion(), 
                       guide = guide_axis(n.dodge = 2)) + # vertical dodge to stagger names so they are more readable
    scale_y_continuous(expand = expansion(), breaks = yBreaks,
                       labels = function(x) ifelse(x == floor(x), as.character(floor(x)), as.character(x))) +
    scale_color_manual(values = dfPlot$colors, guide = NULL) +
    scale_fill_manual(values = dfPlot$colors, guide = NULL)
  
  ggsave(outPath, height = fDim[2], width = fDim[1], units = 'in', dpi = fR, bg = 'transparent')
  message('CREATED PLOT: ', outFig) # alert user when plot is created
} # for (i in 1:11)