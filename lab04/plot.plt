unset key

set term windows 1
set title 'Najlepsze przystosowanie'
set ylabel 'przystosowanie'
set xlabel 'ewaluacja'
set datafile separator ","
plot "bestTable.csv" with boxes lc 3

set term windows 2
plot "bestTable2.csv" with boxes lc 4

set term windows 3
set title 'Srednie przystosowanie'
set ylabel 'przystosowanie'
set xlabel 'ewaluacja'
plot "sredniePrzystosowanie.csv" with boxes lc 3

set term windows 4
plot "sredniePrzystosowanie2.csv" with boxes lc 4

set term windows 5
set title 'Odchylenie standardowe'
set ylabel 'odchylenie standardowe'
set xlabel 'ewaluacja'
plot "odchylenieStandardowe.csv" with boxes lc 3

set term windows 6
plot "odchylenieStandardowe2.csv" with boxes lc 4


pause -1 "Hit any key to continue\n"