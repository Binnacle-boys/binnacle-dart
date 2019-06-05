'''-------------------------------------
super_duper.py
/route_planning/algorithm_modules

First iteration of the algorithm.

--------------------------------------
'''
import math
import numpy as np


no_go = (0.57357643, 0.81915204428)  # Unit circle values for 55 degrees
ng_slope = no_go[1] / no_go[0]


def euc_dist(a, b):
    """ Find euclidean distance between points """
    return math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)


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

    return (px, py)


def check_viable_tack(p1, p2):
    """ check_viable_tack just checks if a tack from
            p1 -> p2 is makable (not directly upwind).
            Args:
        p1 (tuple): Cartesian coordinates of start
        p2 (tuple): Cartesian coordinates of end
    Returns:
        Boolean
    """
    delta = np.subtract(p2, p1)
    print("DELTA = ", delta)
    if p2[1] <= 0 or delta[0] == 0:
        return False
    delta_slope = delta[1] / delta[0]
    return ng_slope > abs(delta_slope)


def main(start_pt, end_pt):
    """ Main OST algorithm caller.
            Args:
        start_pt (tuple): Cartesian coordinates of start
        end_pt (tuple): Cartesian coordinates of end
    Returns:
        route (list): List of tuples representing the fastest route from start_pt -> end_pt!!
	"""
    dist = 0
    route = [start_pt]

    if not check_viable_tack(start_pt, end_pt):
        start_pt2 = (start_pt[0] + 1, start_pt[1] + ng_slope)
        end_pt2 = (end_pt[0] + 1, end_pt[1] - ng_slope)
        intersect = find_intersection(start_pt, start_pt2, end_pt, end_pt2)
        dist += euc_dist(start_pt, intersect)
        dist += euc_dist(end_pt, intersect)

        route.append(start_pt2)
        route.append(intersect)
        route.append(end_pt2)
    else:
        dist += euc_dist(start_pt, end_pt)
    route.append(end_pt)
    print("Dist = ", dist)

    return route


if __name__ == '__main__':
    print(main((0, 0), (10, 1)))
