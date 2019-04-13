import sys
import math as m
from .polar_plots.polar_plot import PolarPlot
from .polar_plots.polar_plot import angle_difference

print(dir(sys))
PLOT_ERROR_ANGLE = 10

def cardinal_transform (angle) :
    return (90 + (360 - angle)) % 360

def radians_to_cardinal (angle) :
    return cardinal_transform(angle * 180 / m.pi)
 
def main(start_pt, end_pt, wind_direction, speed, plot_file) :
    """ Polar OST algorithm caller.
            Args:
        start_pt (tuple): Cartesian coordinates of start
        end_pt (tuple): Cartesian coordinates of end
        wind_direction (double) : Cardinal direction in degrees
        plot_file (string) : path to csv file of a polar plot
    Returns:
        route (list): List of tuples representing the fastest route from start_pt -> end_pt!!
	"""
    
    plot = PolarPlot(plot_file)
    # Gets the unit circle direction of the desired direction
    desired_angle = m.atan2(end_pt[0] - start_pt[0], end_pt[1] - start_pt[1])
    # Makes it a cardinal direction (bearings)
    desired_direction = radians_to_cardinal(desired_angle)

    vmg_direction = plot.find_optimal_angle(wind_direction, speed, desired_direction)
    route = [start_pt]
    if abs(vmg_direction - desired_direction) >= PLOT_ERROR_ANGLE:
        # Taking a Tack is optimal
        # Convert back to unit circle to get vector
        vmg_angle = cardinal_transform(vmg_direction)

    route.append(end_pt)
        
    


    