import csv
import math



def angleDifference(firstangle, secondangle):
    # Doesn't use modulo in order to preserve negative sign of angle difference
    difference = secondangle - firstangle
    while difference < -180:
        difference += 360
    while difference > 180:
        difference -= 360
    return difference

def bestAngle(plot, ideal_angle, windSpeed):
    windSpeeds = [key for key in next(iter(plot.values()))]
    print("Wind speeds: ", windSpeeds)
    closestSpeed = min(windSpeeds, key=lambda speed: abs(windSpeed - float(speed)))
    print("Closest speed: ", closestSpeed)
    bestAngle = max(plot.keys(), key=lambda angle: plot[angle][closestSpeed] * math.cos(math.radians(angleDifference(ideal_angle, angle))))
    return bestAngle
def findOptimalAngle(plot, wind_heading, wind_speed, ideal_heading):
    plotideal_angle = angleDifference(ideal_heading, (wind_heading + 180) % 360)
    print("plot ideal angle: ", plotideal_angle)
    direction = 1
    if (plotideal_angle < 0):
        direction = -1
    optimal_plot_angle = bestAngle(plot, abs(plotideal_angle), wind_speed)
    print("Optimal plot angle: ", optimal_plot_angle)
    optimal_angle = (optimal_plot_angle + direction * (wind_heading + 180)) % 360
    return optimal_angle

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
    #theAngle = bestAngle(plot, 39.8, 16)
    #print(theAngle)
    optimal_angle = findOptimalAngle(plot, 180, 6, 90)
    print(optimal_angle)


    
    


    



