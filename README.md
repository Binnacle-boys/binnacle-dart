# Binnacle

## Overview

This is a 2019 UCSC senior design project done by five students who are passionate about sailing who wanted to start an open source project for sailing. The current technology for sailing is kept propietary as it is a very expensive sport.

We developed a crossplatform mobile application using Google's Flutter framework. The purpose of the application was to help improve their sailing technique. To do this we researched and developed an optimal route planning algorithm for sailing. We added a navigator that acts as a mediator between sailors and the optimal route. The navigator gives the realtime notifications sailors need to maintain their course.

The application can be downloaded on the Google Playstore or Apple App Store under the name Binnacle. Below is a high level picture showing that the application generates an optimal route for a sailor and tries to make sure the sailor stays on course.

![Augmented photo of the Santa Cruz Harbor showing an example optimal path with how environment variables impact it, and how sailboats are perceived.](binnacle_photoshopped.png)

## Development Overview

`docs/` contains all our scrum documents which give a clearer view of the goal and scope of the project.

`route_planning/` is our initial resarch bed for developing an optimal route planning algorithm. It's built off of Python 3.

`binnacle/` is the Flutter project for the mobile application. There is more information for it in its workspace.

[sail_routing_dart](https://github.com/Binnacle-boys/sail_routing_dart) is the final algorithm developed from our research test bed ported as a Dart library.

## Future Work

**Smart watch application.** It's much easier to access a smart watch display than a smart phone display.

**Further algorithm development.** For this 6 month project we worked on an algorithm geared towards beginners. Further development would include handling terrain issues (shallow shores and coastlines) and adding in more data points (e.g. sailboats current heading and ocean currents).

**Velocity Made Good Generator.** This project used open source aerodynamic models (polar plots) of sailboats to know what the optimal angle into the wind is for the generic UCSC sailboats. We realized we collect enough data to calculate an estimated polar plot.