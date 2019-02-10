'''-------------------------------------
generate_bogus_input.py
/Binnacle-dart/route_planning

Currently does regular start and end point creation e.g. if n=36,
it would make start and end points that are seperated by 10 degrees
for each input (this is easier to see than explain)

The wind speed and direction are random (for now??)

See '-h' for usage.

    created on 1-17-2019
--------------------------------------
'''
from optparse import OptionParser
import random
import pprint
import matplotlib.pyplot as plt
import yaml

pp = pprint.PrettyPrinter(indent=4)
verbose_flag = False

def show_vizual(x_arr, y_arr, wind_direction, wind_speed):
    """ plot start, end, wind speed and direction """
    ax = plt.axes()
    plt.grid(True)
    ax.set_axisbelow(True)
    # Draw start and end, I know the dimentions are weired in matplot
    plt.scatter(x_arr[0], y_arr[0], s=300, c='g')
    plt.scatter(x_arr[1], y_arr[1], s=300, c='r')

    label_txt = "Wind speed: " + \
      str(wind_speed) + "\nWind Direction: " + \
      str(wind_direction) + "deg"
    plt.legend([label_txt,])
    plt.show()
    plt.close("all")


def main(case_count, output_path):
    """ Main data generation function """
    output_data = {}
    width = 100
    step = 2*(width//(case_count-1))
    pts = [[x, width-x] for x in range(0, width, step)]
    stand = [[0, width]] * (width//step)

    zipd_forward = list(zip(stand, pts))
    zipd_back = list(zip(pts, stand))

    all_pts = zipd_forward + zipd_back
    print("all_pts len = ", len(all_pts))
    n = 0
    for x, y in all_pts[0:case_count]:
        case = {}
        case["start"] = [x[0], y[0]]
        case["end"] = [x[1], y[1]]
        case["wind_direction"] = random.randrange(360)
        case["wind_speed"] = random.randrange(3)
        output_data[n] = case
        n += 1
    if verbose_flag:
        pp.pprint(output_data)
    with open(output_path, "w") as op:
        yaml.dump(output_data, op, default_flow_style=False)

if __name__ == '__main__':
    parser = OptionParser(usage="usage: $./gen_test_input.py [options] <output_path>",
                          version="%prog 0.1")
    parser.add_option("-n", "--number",
                      dest="num",
                      default=10,
                      help="Number of test cases")
    parser.add_option("-v", "--verbose",
                      action="store_true",
                      dest="v_flag",
                      default=False,
                      help="Verbose mode",)

    (options, args) = parser.parse_args()
    output_path_arg = args[0]
    options_dict = vars(options)
    num_testcases = options_dict['num']
    verbose_flag = options_dict['v_flag']

    main(int(num_testcases), output_path_arg)
