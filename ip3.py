# -*- coding: utf-8 -*-
# @Time    : 2020/4/1 11:38
# @Author  : Marco
# @File    : ip3.py
# @Project: Reconstruction of 3D Needle-punched C/C Composites
# @Step: slice interpolation
# @Improvement：Unedited

import cv2 as cv
import numpy as np
import os
import shutil

def match(x0,y0,img1):
    # region1=img1[x0-1:x0+2,y0-1:y0+2]
    # region2=img1[x0-2:x0+3,y0-2:y0+3]
    # region = img1[x0 - r:x0 + r + 1, y0 - r:y0 + r + 1]
    for r in range(0,11):                              #normal search
        for x1 in range(x0-r,x0+r+1):
            for y1 in range(y0-r,y0+r+1):
                if img1[x1,y1]>=30:
                    return x1,y1

    x1=x0
    y1=y0

    while(x1<373):
        if img1[x1,y1]>=30:
            return x1,y1
        else:
            x1=x1+1

    return x0,y0

def interpolation(name0,name1,num):                  #inputfolder, outputfolder ,suffix

    img0 = cv.imread(inputfolder + name0, cv.IMREAD_GRAYSCALE)
    img1 = cv.imread(inputfolder + name1, cv.IMREAD_GRAYSCALE)
    img0[img0 < 30] = 0  # delete needless pixels
    img1[img1 < 30] = 0

    (x0array,y0array)=np.where(img0>=30)
    # zip(x0array,y0array)
    (x1array,y1array)=np.where(img1>=30)

    # global img
    img = []
    img.append(img0)

    for i in range(1, num):  # 左闭右开，最后一层本来就存在，不需要插入
        img.append(np.zeros(img0.shape, img0.dtype))                     # initialization, shape=(373,1050)

    for (x0,y0) in zip(x0array,y0array):              #positive order interpolation
        x1,y1=match(x0,y0,img1)                      # look for match points in the other slice

        for i in range(1, num):  # 左闭右开，最后一层本来就存在，不需要插入

            x=(num-i)*x0/num + i*x1/num             #linear interpolation
            y=(num-i)*y0/num + i*y1/num
            x=int(round(x))
            y=int(round(y))                     #四舍六入五平分
            # print(x,y)
            img[i][x,y]=255

    for (x_1,y_1) in zip(x1array,y1array):              #reverse order interpolation

        x_0,y_0=match(x_1,y_1,img0)                      # look for match points in the other slice

        for i in range(1, num):  # 左闭右开，最后一层本来就存在，不需要插入

            x=(num-i)*x_1/num + i*x_0/num             #linear interpolation
            y=(num-i)*y_1/num + i*y_0/num
            x=int(round(x))
            y=int(round(y))                     #四舍六入五平分
            # print(x,y)
            img[num-i][x,y]=255

    for i in range(1, num):
        # cv.imshow('img'+str(i), img[i])
        postpaths.append(outputfolder + name0[0:5] + '_'+str(i) + suffix)  # Get the paths of post files
        cv.imwrite(postpaths[-1], img[i])

    return 0


inputfolder="F:/CR/pics/ip_test/"                                     #the name of the folder that store original files
originalnames=os.listdir(inputfolder)                              #Get the names of original files. "originalnames" is a list.
originalnames.sort(key=lambda x:int(x[0:5]))

outputfolder='F:/CR/pics/interpolation_output/'                    #the name of the folder that store post files
if os.path.exists(outputfolder):                               #Delete existing outputfolder and create a new one
    shutil.rmtree(outputfolder)
os.makedirs(outputfolder)

suffix='_ip.jpg'                                                   #extension name
postpaths=[]
lenth=len(originalnames)
slices_dist=1                                                      #the distance between two adjacent slices


for i in range(lenth-1):

    slices_num=int(originalnames[i+1][0:5])-int(originalnames[i][0:5])
    Dist=slices_num*slices_dist                                       #the real distance between two original slices
    interpolated_num = slices_num * 1         # the number of the slices to be interpolated，!!! including src1  !!!

    interpolation(originalnames[i],originalnames[i + 1],interpolated_num)


k=cv.waitKey(0)
if k==27:
    cv.destroyAllWindows()

