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

    # Gets best angle based on relative ideal heading from wind heading
    def __best_angle(self, ideal_angle, wind_speed):
        wind_speeds = [key for key in next(iter(self.plot.values()))]
        # Gets closest match for speed
        closest_speed = min(
            wind_speeds, key=lambda speed: abs(
                wind_speed - float(speed)))
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
        """
        # Plot transform to compute in plot space
        plotideal_angle = angle_difference(
            ideal_heading, (wind_heading + 180) % 360)
        direction = 1
        if plotideal_angle < 0:
            direction = -1
        # Gets optimal relative plot angle
        optimal_plot_angle = self.__best_angle(
            abs(plotideal_angle), wind_speed)
        # Reverses plot transform
        optimal_angle = (optimal_plot_angle + direction *
                         (wind_heading + 180)) % 360
        return optimal_angle
