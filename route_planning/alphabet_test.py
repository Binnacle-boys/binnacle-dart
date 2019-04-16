#!/usr/bin/env python3
'''-------------------------------------
alphabet_test.py
Binnacle
binnacle-dart/route_planning


See '-h' for usage.

    on 2-10-2019
--------------------------------------
'''
import argparse
import sys
import math
import matplotlib.pyplot as plt
import yaml

from algorithm_modules import *

sys.path.append("./algorithm_modules")

verbose_flag = False
POLAR_PATH = './algorithm_modules/polar_plots/data/test_plot.csv'

def euc_dist(a, b):
    """ Find euclidean distance between points """
    return math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)

def calc_length(points_x, points_y):
    """ Calc length of a line, done on this side of the testing for now
        Args:
               points_x (arraylike): vector of x coordinates
               points_y (arraylike): vector of y coordinates

        Returns:
            res (float) length og line
    """
    res = 0
    prev = (points_x[0], points_y[0])
    for curr in zip(points_x, points_y):
        diff = euc_dist(prev, curr)
        prev = curr
        res += diff
    return res

def main(input_path, output_path, group_name):
    """ Main selective algorithm caller """
    test_config = yaml.load(open("test_config.yaml"))
    test_input = yaml.load(open(input_path))
    if group_name not in test_config:
        print("Invalid group name. Select a group from test_config.yaml or leave blank or all")
        exit()
    if test_input is None:
        print("Invalid testfile: %s. Try again" % input_path)
        exit()
    algs = test_config[group_name]
    i = 0

    test_results = {}
    for input_index, input_datum in test_input.items():
        single_datum_results = []

        if verbose_flag:
            print(input_datum)

        for alg_name in algs:
            result = {}
            if verbose_flag:
                print("Alg name: ", alg_name)
            module = __import__(alg_name, alg_name)
            line_len = 0
            t, s = 0, 0
            lable_text = ''
            if alg_name == 'polar_alg':
                if verbose_flag:
                    print("Doing polar alg")
                funky = getattr(module, 'get_route')
                route = funky(input_datum['start'], input_datum['end'], input_datum['wind_direction'], input_datum['wind_speed'], POLAR_PATH)
                result["route"] = route
                # TODO: Get actual length
            else: 
                func = getattr(module, 'sin_test')
                t, s = func()
                line_len = calc_length(t, s)
                lable_text = "%s(input[%d]) = %.4f" % (alg_name, i, line_len)
            if verbose_flag:
                print(lable_text)
            # plt.plot(t, s, lw=2, label=lable_text)
            result["algorithm_name"] = alg_name
            result["route_length"] = line_len

            single_datum_results.append(result)
        i += 1
        test_results[input_index] = single_datum_results
    with open(output_path, 'w') as output_yaml:
        yaml.dump(test_results, output_yaml, default_flow_style=False)

    plt.plot()
    plt.legend(loc='upper left')
    plt.ylim(0, 100)
    plt.show()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Run and compare different groups of algorithms.")

    parser.add_argument("-v", "--verbose",
                        action="store_true",
                        dest="verbose_flag",
                        default=False,
                        help="Verbose mode",)
    parser.add_argument("-g", "--groupname",
                        dest="groupname",
                        help="Group of algorithm names to run, see tst_config.yaml")
    parser.add_argument("input_filepath",
                        default="input.yaml",
                        help="Input filepath")
    parser.add_argument("output_filepath",
                        default="output.yaml",
                        help="Output filepath")
    args = parser.parse_args()
    print(args.output_filepath)

    verbose_flag = args.verbose_flag

    main(args.input_filepath, args.output_filepath, args.groupname)
