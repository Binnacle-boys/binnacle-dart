import csv
import math

class PolarPlot:
    
    def __init__(self, csv_file):
        self.updatePlot(csv_file)    
    
    def updatePlot(self, csv_file):
        with open(csv_file, newline='') as csvfile:
            plotreader = csv.reader(csvfile, delimiter=';', quotechar='|')
            header = next(plotreader)
            self.plot = dict()
            for row in plotreader:
                print(', '.join(row))
                angle = float(0)
                for (label, value) in zip(header, row):
                    print(label, ": ", value)
                    if(label == "twa/tws"):
                        print("special label")
                        angle = float(value)
                        self.plot[angle] = dict()
                    else:
                        print(label, "Not special")
                        self.plot[angle][label] = float(value)
            print('printing plot items')
            for entry, value in self.plot.items():
            
                print(entry, ": ", value)
        
    def __angleDifference(self, firstangle, secondangle):
        # Doesn't use modulo in order to preserve negative sign of angle difference
        difference = secondangle - firstangle
        while difference < -180:
            difference += 360
        while difference > 180:
            difference -= 360
        return difference
    
    def __bestAngle(self, ideal_angle, windSpeed):
        windSpeeds = [key for key in next(iter(self.plot.values()))]
        print("Wind speeds: ", windSpeeds)
        print('ideal angle', ideal_angle)
        closestSpeed = min(windSpeeds, key=lambda speed: abs(windSpeed - float(speed)))
        print("Closest speed: ", closestSpeed)
        bestAngle = max(self.plot.keys(), key=lambda angle: self.plot[angle][closestSpeed] * math.cos(math.radians(self.__angleDifference(ideal_angle, angle))))
        return bestAngle
    
    def findOptimalAngle(self, wind_heading, wind_speed, ideal_heading):
        plotideal_angle = self.__angleDifference(ideal_heading, (wind_heading + 180) % 360)
        print("plot ideal angle: ", plotideal_angle)
        direction = 1
        if (plotideal_angle < 0):
            direction = -1
        optimal_plot_angle = self.__bestAngle(abs(plotideal_angle), wind_speed)
        print("Optimal plot angle: ", optimal_plot_angle)
        optimal_angle = (optimal_plot_angle + direction * (wind_heading + 180)) % 360
        return optimal_angle
    
    
polar = PolarPlot('data/test_plot.csv')
angle = polar.findOptimalAngle(0, 8, 180)
print("Test angle", angle)


    



