import csv

with open('data/test_plot.csv', newline='') as csvfile:
    plotreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    for row in plotreader:
        print(', '.join(row))