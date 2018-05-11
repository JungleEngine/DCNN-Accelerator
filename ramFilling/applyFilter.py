import cv2
import numpy as np
im = cv2.imread("cameraman.png")
im=cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

# kernel = np.ones((5,5),np.int32)
# kernel[0]=[-1,-1,-1,-1,-1]
# kernel[1]=[-1,-1,-1,-1,-1]
# kernel[2]=[ 0, 0, 0, 0, 0]
# kernel[3]=[-1,-1,-1,-1,-1]
# kernel[4]=[-1,-1,-1,-1,-1]
kernel = np.array([	[1,-1,-1,-1,1],
					[1,-1,-1,-1,1],
					[0, 0, 0, 0, 0],
					[1,1,1,1,1],
					[1,1,1,1,1]])/32
out=cv2.filter2D(np.uint8(im),-1, kernel)
out
print(out)
cv2.imshow("window", out)
while True:
	k = cv2.waitKey(30) &0xFF
	if k == 27: break
print(kernel)
print()