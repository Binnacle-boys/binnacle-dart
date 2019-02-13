#!/usr/bin/env python3
'''-------------------------------------
alphabet_test.py
Binnacle
binnacle-dart/route_planning


See '-h' for usage.

    on 2-10-2019
--------------------------------------
'''
from optparse import OptionParser
import sys
import math
import matplotlib.pyplot as plt
import yaml

from algorithm_modules import *

sys.path.append("./algorithm_modules")
v_flag = False

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

        if v_flag:
            print(input_datum)

        for alg_name in algs:
            module = __import__(alg_name, alg_name)
            func = getattr(module, 'sin_test')
            t, s = func()
            line_len = calc_length(t, s)
            lable_text = "%s(input[%d]) = %.4f" % (alg_name, i, line_len)
            if v_flag:
                print(lable_text)
            plt.plot(t, s, lw=2, label=lable_text)
            result = {}
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
    parser = OptionParser(usage="usage: $./alphabet_test [options] <input_path> <output_path>",
                          version="%prog 0.1")
    parser.add_option("-g", "--groupname",
                      dest="g",
                      default="all",
                      help="Group of algorithm names to run, see tst_config.yaml")
    parser.add_option("-v", "--verbose",
                      action="store_true",
                      dest="v_flag",
                      default=False,
                      help="Verbose mode",)

    (options, args) = parser.parse_args()

    print("options  [", type(options).__name__, "]   :", options)
    print("args  [", type(args).__name__, "]   :", args)

    input_filepath = args[0]
    output_filepath = args[1]
    options_dict = vars(options)
    groupname = options_dict['g']
    v_flag = options_dict['v_flag']

    main(input_filepath, output_filepath, groupname)
