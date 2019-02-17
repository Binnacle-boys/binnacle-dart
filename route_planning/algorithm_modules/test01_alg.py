import numpy as np
import random 
def sin_test():
	r = random.uniform(0.1, 1.9)
	r2 = 10*(r**-1)
	print(r, r2)
	#r2 = random.randint(1, 20)
	t = np.arange(0.0, 5.0, 0.01)
	s_cos = r2*(np.cos(np.pi*t* r))
	s = [x*20+y +r2 for x,y in zip(t, s_cos)]
	return t, s