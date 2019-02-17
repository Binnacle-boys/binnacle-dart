import numpy as np
import random 
def sin_test():
	r = random.uniform(0.1, 3.0)
	r2 = 15*(r**-1)
	t = np.arange(0.0, 5.0, 0.01)
	s_cos = r2*(np.cos(np.pi*t* r))
	s = [x*20+y +r2 for x,y in zip(t, s_cos)]
	return t, s