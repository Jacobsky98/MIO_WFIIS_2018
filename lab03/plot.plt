unset key



set term windows 1
set title 'Average Fitness'
set ylabel 'fitness'
set xlabel 'epoch'
set datafile separator ","
plot "avg_fit.csv"

set term windows 2
set title 'Best Fitness'
set ylabel 'fitness'
set xlabel 'epoch'
set datafile separator ","
plot "fit_best.csv"




pause -1 "Hit any key to continue\n"