import csv
import math

# Used to work with polar plots of sail boats
# in order to compute optimal headings
# How to use   
# polar = PolarPlot('data/test_plot.csv')
# angle = polar.findOptimalAngle(0, 8, 180)
# print("Test angle", angle)
class PolarPlot:
    
    def __init__(self, csv_file):
        self.updatePlot(csv_file)    
    
    # updates plot with csv file
    def updatePlot(self, csv_file):
        with open(csv_file, newline='') as csvfile:
            plotreader = csv.reader(csvfile, delimiter=';', quotechar='|')
            header = next(plotreader)
            self.plot = dict()
            for row in plotreader:
                angle = float(0)
                for (label, value) in zip(header, row):
                    if(label == "twa/tws"):
                        # label of angle, not speed
                        angle = float(value)
                        self.plot[angle] = dict()
                    else:
                        self.plot[angle][label] = float(value)
    
    # Gets angle difference preserving sign
    # Doesn't use modulo in order to preserve negative sign of angle difference
    def __angleDifference(self, firstangle, secondangle):
        difference = secondangle - firstangle
        while difference < -180:
            difference += 360
        while difference > 180:
            difference -= 360
        return difference
    
    # Gets best angle based on relative ideal heading from wind heading
    def __bestAngle(self, ideal_angle, windSpeed):
        windSpeeds = [key for key in next(iter(self.plot.values()))]
        # Gets closest match for speed
        closestSpeed = min(windSpeeds, key=lambda speed: abs(windSpeed - float(speed)))
        # Checks max cosine of angle difference for ideal and plot entry
        bestAngle = max(self.plot.keys(), key=lambda angle: self.plot[angle][closestSpeed] * math.cos(math.radians(self.__angleDifference(ideal_angle, angle))))
        return bestAngle
    
    # Finds optimal angle from ideal heading and wind info
    # Only returns angles in plot
    # Probably better to simply choose the ideal heading, if only small difference
    def findOptimalAngle(self, wind_heading, wind_speed, ideal_heading):
        # Plot transform to compute in plot space
        plotideal_angle = self.__angleDifference(ideal_heading, (wind_heading + 180) % 360)
        direction = 1
        if (plotideal_angle < 0):
            direction = -1
        # Gets optimal relative plot angle
        optimal_plot_angle = self.__bestAngle(abs(plotideal_angle), wind_speed)
        # Reverses plot transform
        optimal_angle = (optimal_plot_angle + direction * (wind_heading + 180)) % 360
        return optimal_angle
    




    



