
## [Optimal routing in sailing](http://www.fast.u-psud.fr/~rabaud/Articles/Optimal_routing.pdf)

### Abstract
This paper discusses how to determine the best trajectory for a sailing boat and draws some analogies
between this routing problem and condensed matter physics or geometrical optics.

### My Initial Take
This looks like a good explanation of the basic problem. However, they implement a solution to a different problem than ours. Namely, the scale. They are plotting deal routes across the Atlantic. They also go in deep about the geometry because when solving the OST problem on a bigger scale e.g. the Atlantic, spherical geometry plays a big role.




## [Velocity Made Good – Trading off course against speed](http://www.oceansail.co.uk/Articles/VMGArticle.php)

### Abstract
In sailing it’s not unusual to find that changing course a little away from the direct line to your destination can give you more boat speed, as can sailing a little free of close hauled when you’re working to windward. Sometimes this can work to your advantage with the extra distance sailed being more than made up for by better boat speed, on other occasions the gain in speed isn’t enough and you end up taking longer than you needed. This article puts some hard numbers on the gains and losses and introduces a simple table that can be used in practical sailing situations to help to decide on the best course to steer.

### My Initial Take
This isn't an academic paper, just a *very comprehensive* blog post but that is quite nice, they explain things well and in simple terms. Good visuals. This post doesn't really talk about a solution or route planning other than a heuristic.



## [Design and Implementation of a Navigation Algorithm for an Autonomous Sailboat (**AVALON**)](https://pdfs.semanticscholar.org/b3a1/3f6fa88e1967b209223f6741fd87993074d2.pdf)

### Abstract
The planning algorithm is based on an A* search in 3 dimensions (x, y, heading) and
takes into account current wind speed, wind direction and the nonholonomic properties of a sailing boat.

### My Initial Take
This looks quite promising. This has a ton of good info. This paper was written to solve the same kind of problem we are solving. There are a few features of their algorithm that we will be able to lift directly from this paper.

P.S. They cite Elkaim's paper