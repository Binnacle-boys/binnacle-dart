import sys
import math as m
from planar import Vec2
from polar_plot import PolarPlot
from polar_plot import angle_difference


print(dir(sys))
# Angle of error, best to change based on largest difference in polar plot
# interval. However it is really an experimental value
PLOT_ERROR_ANGLE = 20

def find_intersection(p1, p2, p3, p4):
    """ find_intersection finds the intersection between two lines.
            Line1 goes through p1 and p2 while Line2 goes through p3, p4.
            Args:
        p1 (tuple): Cartesian coordinates of on Line1
        p2 (tuple): Cartesian coordinates of on Line1
        p3 (tuple): Cartesian coordinates of on Line2
        p3 (tuple): Cartesian coordinates of on Line2
    Returns:
        (px, py) (tuple): Cartesian coordinates of intersection.
    """
    x1, y1 = p1
    x2, y2 = p2
    x3, y3 = p3
    x4, y4 = p4
    px_numer = ((x1 * y2 - y1 * x2) * (x3 - x4) -
                (x1 - x2) * (x3 * y4 - y3 * x4))
    px_denom = ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    px = px_numer / px_denom

    py_numer = ((x1 * y2 - y1 * x2) * (y3 - y4) -
                (y1 - y2) * (x3 * y4 - y3 * x4))
    py_denom = ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    py = py_numer / py_denom

    return [px, py]

def cardinal_transform (angle) :
    """
    Converts cardinal degrees to polar angle degrees and vice versa
    """
    return (90 + (360 - angle)) % 360

def radians_to_cardinal (angle) :
    """ 
    Converts radians to degrees then returns the cardinal transform
    """
    return cardinal_transform(angle * 180 / m.pi)
 
def get_route(start_pt, end_pt, wind_direction, speed, plot_file) :
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
    desired_angle = m.atan2(end_pt[1] - start_pt[1], end_pt[0] - start_pt[0])
    # Makes it a cardinal direction (bearings)
    desired_direction = radians_to_cardinal(desired_angle)
    # Finds vmg for route to destination
    vmg_direction = plot.find_optimal_angle(wind_direction, speed, desired_direction)
    # Route always includes start point
    route = [start_pt]
    # Evaluates if vmg is within degree of error in the plot
    # Also, if desired route is in no go zone, you must tack
    desired_diff = abs(angle_difference(vmg_direction, desired_direction)) 
    if desired_diff > PLOT_ERROR_ANGLE or plot.in_nogo_zone(desired_direction, wind_direction, speed):
        # Construct vectors
        start = Vec2(start_pt[0], start_pt[1])
        end = Vec2(end_pt[0], end_pt[1])
        # Taking a Tack is optimal
        # Convert back to unit circle to get vector
        vmg_angle = cardinal_transform(vmg_direction)
        wind_angle = cardinal_transform(wind_direction)

        # Getting vectors
        vmg_vec = Vec2.polar(vmg_angle, 1.0)
        wind_vec = Vec2.polar(wind_angle, 1.0)
        # Needed for reflection
        perpwind_vec = wind_vec.perpendicular()

        # Reflect vmg along wind to get second tack line
        reflectvmg_vec = vmg_vec.reflect(perpwind_vec)
        #reflectvmg_vec = vmg_vec.reflect(reverse_wind)
        reflectvmg_vec = reflectvmg_vec.normalized()

        # Get another point on each line
        start2 = Vec2(start.x + vmg_vec.x, start.y + vmg_vec.y)
        end2 = Vec2(end.x + reflectvmg_vec.x, end.y + reflectvmg_vec.y)
        # Get intersection
        intersect_pt = find_intersection(start_pt, [start2.x, start2.y], end_pt, [end2.x, end2.y])
        # Push to route
        route.append(intersect_pt)
        # The line from planar is trash, isn't useful at all
        # first_line = Line(reflectvmg_vec, start)
        # second_line = Line(reflectvmg_vec, end)
    
    # Return end point
    route.append(end_pt)
    return route
    
        
    


    