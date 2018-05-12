import cv2
import numpy as np
im = cv2.imread("cameraman.png")
im=cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

with open('result.mem') as file:
	hardImage= [line.split()[1] for line in file]

hardImage = np.array(hardImage,np.uint8)
hardImage = np.reshape(hardImage, (-1,252))

cv2.imshow("returned", hardImage)

kernel = np.array([	[1.,-1.,-1.,-1.,1.],
					[1.,-1.,-1.,-1.,1.],
					[0., 0., 0., 0., 0.],
					[1.,1.,1.,1.,1.],
					[1.,1.,1.,1.,1. ]])/32
out=cv2.filter2D(im,-1, kernel)
cv2.imshow("window", np.uint8(out))
while True:
	k = cv2.waitKey(30) &0xFF
	if k == 27: break
print(kernel)
print()