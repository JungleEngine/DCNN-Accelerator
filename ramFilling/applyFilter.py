import cv2
import numpy as np
im = cv2.imread("cameraman.png")
im=cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
# file = open("result.mem","r");
# file = file.read()

hardImage = np.array(256*256,np.uint8);
d=0
i=0
j=0
q=0
with open('result.mem') as file:
	hardImage= [line.split()[1] for line in file]
# for line in file:
# 	pixel = line.split()[1]
# 	j+=1
# 	if j==256:
# 		i+=1
# 		j=0
# 	q+=1
# 	hardImage[q]= pixel
hardImage = np.array(hardImage,np.uint8)
print(hardImage.shape)
hardImage = np.reshape(hardImage, (-1,252))
print(hardImage.shape)
rows,cols = hardImage.shape

M = cv2.getRotationMatrix2D((cols/2,rows/2),360,-1)
hardImage = cv2.warpAffine(hardImage,M,(cols,rows))
cv2.imshow("returned", hardImage)
# kernel = np.ones((5,5),np.int32)
# kernel[0]=[-1,-1,-1,-1,-1]
# kernel[1]=[-1,-1,-1,-1,-1]
# kernel[2]=[ 0, 0, 0, 0, 0]
# kernel[3]=[-1,-1,-1,-1,-1]
# kernel[4]=[-1,-1,-1,-1,-1]
kernel = np.array([	[1.,-1.,-1.,-1.,1.],
					[1.,-1.,-1.,-1.,1.],
					[0., 0., 0., 0., 0.],
					[1.,1.,1.,1.,1.],
					[1.,1.,1.,1.,1. ]])/32
out=cv2.filter2D(im,-1, kernel)
out
print(out)
cv2.imshow("window", np.uint8(out))
while True:
	k = cv2.waitKey(30) &0xFF
	if k == 27: break
print(kernel)
print()