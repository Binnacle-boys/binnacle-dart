import csv

with open('data/test_plot.csv', newline='') as csvfile:
    plotreader = csv.reader(csvfile, delimiter=';', quotechar='|')
    header = next(plotreader)
    plot = dict()
    for row in plotreader:
        print(', '.join(row))
        angle = float(0)
        for (label, value) in zip(header, row):
            print(label, ": ", value)
            if(label == "twa/tws"):
                print("special label")
                angle = float(value)
                plot[angle] = dict()
            else:
                print(label, "Not special")
                plot[angle][label] = float(value)
    for entry, value in plot.items():
        print(entry, ": ", value)

