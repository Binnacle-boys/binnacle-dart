# Polar plots

Used to interpret polar plots from csv files. These particular csv formatted files can be found here: http://jieter.github.io/orc-data/site/


## How to use
Copy *extended* csv plot from a particular sail boat from the above site. Reference the csv by file path and create a polar plot with it. Example:
polar = PolarPlot('data/test_plot.csv')
angle = polar.find_optimal_angle(0, 8, 180)
print("Test angle", angle)

#Example CSV:
This example csv outlines the format of the file. The top line is a header specifying the columns. The columns with numbered names are wind speeds. 'twa/tws' is the heading angle relative to wind direction. So each row has a boat speed for each wind speed value at that angle. Here is the example:
twa/tws;6;8;10;12;14;16;20
0;0;0;0;0;0;0;0
43.9;3.83;0;0;0;0;0;0
42.5;0;4.52;0;0;0;0;0
42.8;0;0;5.11;0;0;0;0
42.1;0;0;0;5.57;0;0;0
40.3;0;0;0;0;5.78;0;0
39.8;0;0;0;0;0;5.9;0
40.8;0;0;0;0;0;0;5.94
52;4.25;5.05;5.69;6.09;6.31;6.43;6.47
60;4.51;5.34;5.94;6.26;6.47;6.62;6.71
75;4.72;5.59;6.12;6.4;6.63;6.83;7.14
90;4.76;5.76;6.34;6.66;6.94;7.18;7.38
110;4.83;5.84;6.38;6.72;7.07;7.41;8.01
120;4.68;5.69;6.3;6.64;6.98;7.34;8.04
135;4.25;5.21;6;6.43;6.74;7.08;7.77
150;3.64;4.59;5.41;6.07;6.44;6.74;7.37
147.8;3.72;0;0;0;0;0;0
151.8;0;4.52;0;0;0;0;0
154;0;0;5.23;0;0;0;0
162.4;0;0;0;5.63;0;0;0
180;0;0;0;0;5.97;0;0
180;0;0;0;0;0;6.37;0
180;0;0;0;0;0;0;6.95
