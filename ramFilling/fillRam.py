import cv2
im = cv2.imread("cameraman.png")
im=cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

print("// memory data file (do not edit the following line - required for mem load use)")
print("// instance=/cpu/ram1/ram")
print("// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1")
i=0

# [1,-1,-1,-1,1],
# 					[1,-1,-1,-1,1],
# 					[0, 0, 0, 0, 0],
# 					[1,1,1,1,1],
# 					[1,1,1,1,1]
#row 1
print(str(i)+":",1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",1)
i=i+1

#row 2
print(str(i)+":",1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",-1)
i=i+1
print(str(i)+":",1)
i=i+1

#row 3
print(str(i)+":",0)
i=i+1
print(str(i)+":",0)
i=i+1
print(str(i)+":",0)
i=i+1
print(str(i)+":",0)
i=i+1
print(str(i)+":",0)
i=i+1
#row 4
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
#row 5
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1
print(str(i)+":",1)
i=i+1


for row in im:
	for pixel in row:		
		print(str(i)+":",pixel)
		i=i+1
