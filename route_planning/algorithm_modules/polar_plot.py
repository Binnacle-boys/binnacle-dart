"""
Used to work with polar plots of sail boats
in order to compute optimal headings
How to use
polar = PolarPlot('data/test_plot.csv')
angle = polar.find_optimal_angle(0, 8, 180)
print("Test angle", angle)
"""
import csv
import math
# Gets angle difference preserving sign
# Doesn't use modulo in order to preserve negative sign of angle difference
def angle_difference(firstangle, secondangle):
    """
    Args:
        firstagle (double)
        secondangle (double)
    Returns:
        (double) secondangle - first angle
    Gets angle difference preserving sign (double, double) -> double
    """
    difference = secondangle - firstangle
    while difference < -180:
        difference += 360
    while difference > 180:
        difference -= 360
    return difference

class PolarPlot:
    """Plot class used to interpret boat polar plots to determine optimal headings"""
    def __init__(self, csv_file):
        self.update_plot(csv_file)

    # updates plot with csv file
    def update_plot(self, csv_file):
        """
        Args:
            csv_file (string) - file path to csv file
        Returns:
            nothing - updates internal plot
        Change csv file to modify data model
        """
        with open(csv_file, newline='') as csvfile:
            plotreader = csv.reader(csvfile, delimiter=';', quotechar='|')
            header = next(plotreader)
            self.plot = dict()
            for row in plotreader:
                angle = float(0)
                for (label, value) in zip(header, row):
                    if label == "twa/tws":
                        # label of angle, not speed
                        angle = float(value)
                        self.plot[angle] = dict()
                    else:
                        self.plot[angle][label] = float(value)
    
    # Gets closest speed to actual wind speed
    def _closest_speed(self, wind_speed) :
        wind_speeds = [key for key in next(iter(self.plot.values()))]
        # Gets closest match for speed
        closest_speed = min(
            wind_speeds, key=lambda speed: abs(
                wind_speed - float(speed)))
        return closest_speed
    
    # Gets closest angle boat can go to into the wind
    def tightest_heading (self, wind_speed) :
        closest_speed =  self._closest_speed(wind_speed)
        tightest_angle = min(angle for angle in self.plot.keys() if self.plot[angle][closest_speed] != 0)
        return tightest_angle
    
    # Returns true or false of whether or not the direction is in the nogo zone
    def in_nogo_zone(self, direction, wind_direction, wind_speed) :
        closest_heading = self.tightest_heading(wind_speed)
        plot_angle = abs(angle_difference((wind_direction + 180) % 360, direction))
        if plot_angle < closest_heading : 
            return True
        return False

    # Gets best angle based on relative ideal heading from wind heading
    def __best_angle(self, ideal_angle, wind_speed):
        closest_speed = self._closest_speed(wind_speed)
        print('Closest wind speed', closest_speed)
        # Checks max cosine of angle difference for ideal and plot entry
        best_angle = max(
            self.plot.keys(),
            key=lambda angle: self.plot[angle][closest_speed] *
            math.cos(
                math.radians(
                    angle_difference(
                        ideal_angle,
                        angle))))
        return best_angle

    # Finds optimal angle from ideal heading and wind info
    # Only returns angles in plot
    # Probably better to simply choose the ideal heading, if only small
    # difference
    def find_optimal_angle(self, wind_heading, wind_speed, ideal_heading):
        """
        Finds optimal angle in plot given wind heading,
        speed and ideal heading: (double, double, double) -> double
        Args:
            wind_heading (double) - direction of wind in degrees from north
            wind_speed (double) - speed of wind in knots
            ideal_heading (double) - direction of ideal heading in degrees from north, 
                where the boat wants to go idealy
        Returns:
            (double) - optimal heading in degrees from north from various polar plot entries
                Only returns possible polar plot angles. 
        """
        # Plot transform to compute in plot space
        plotideal_angle = angle_difference(
            ideal_heading, (wind_heading + 180) % 360)
        print("Plot ideal angle", plotideal_angle)
        direction = 1
        if plotideal_angle >= 0:
            direction = -1
        # Gets optimal relative plot angle
        optimal_plot_angle = self.__best_angle(
            abs(plotideal_angle), wind_speed)
        print("Optimal plot angle", optimal_plot_angle)
        # Reverses plot transform
        optimal_angle = ( (optimal_plot_angle * direction) +
                          ((wind_heading - 180) % 360) % 360)
        optimal_diff = optimal_plot_angle - abs(plotideal_angle)
        print("Optimal difference: ", optimal_diff)
        optimal_angle = (direction * optimal_diff + ideal_heading) % 360
        return optimal_angle
