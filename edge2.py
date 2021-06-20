# ！/usr/bin/env python
# -*- coding: utf-8 -*-
import cv2 as cv
import numpy as np
import os
import sys
from matplotlib import pyplot as plt



def threshold_demo(image):
    gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    ret, binary = cv.threshold(gray, 127, 255, cv.THRESH_BINARY | cv.THRESH_OTSU)
    print("threshold value %s" % ret)
    cv.imshow("binary", binary)


def local_threshold(image):
    gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    binary = cv.adaptiveThreshold(gray, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY, 25, 10)
    cv.imshow("binary", binary)


def custom_threshold(image):
    gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    h, w = gray.shape[:2]
    m = np.reshape(gray, [1, w * h])
    mean = 1.8 * m.sum() / (w * h)
    print("mean: ", mean)
    ret, binary = cv.threshold(gray, mean, 255, cv.THRESH_BINARY)
    cv.imshow("binary", binary)
    return binary


def bi_demo(image):
    dst = cv.bilateralFilter(image, 0, 100, 15)
    cv.imshow("bilateral", dst)


def open_demo(image):
    print(image.shape)
    # gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    # ret, binary = cv.threshold(gray, 0, 255, cv.THRESH_BINARY | cv.THRESH_OTSU)
    h, w = image.shape[:2]
    m = np.reshape(image, [1, w * h])
    mean = 1.8 * m.sum() / (w * h)
    print("weight_mean: ", mean)
    ret, binary = cv.threshold(image, mean, 255, cv.THRESH_BINARY)
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (3, 3))
    binary = cv.morphologyEx(binary, cv.MORPH_OPEN, kernel)
    cv.imshow("open_operation", binary)
    return binary


def close_demo(image):
    print(image.shape)
    # gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    ret, binary = cv.threshold(image, 0, 255, cv.THRESH_BINARY | cv.THRESH_OTSU)
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (13, 13))
    binary = cv.morphologyEx(binary, cv.MORPH_CLOSE, kernel)
    cv.imshow("close_operation", binary)
    return binary


def add_demo(m1, m2):
    dst = cv.add(m1, m2)
    cv.imshow("add_demo", dst)
    return dst


def subtract_demo(m1, m2):
    dst = cv.subtract(m1, m2)
    cv.imshow("subtract_demo", dst)
    return dst


def divide_demo(m1, m2):
    dst = cv.divide(m1, m2)
    cv.imshow("divide_demo", dst)


def multiply_demo(m1, m2):
    dst = cv.multiply(m1, m2)
    cv.imshow("multiply_demo", dst)
    return dst


def blur_demo(image):
    dst = cv.blur(image, (3, 3))
    cv.imshow("blur_demo", dst)


def median_blur_demo(image):
    dst = cv.medianBlur(image, 5)
    cv.imshow("median_blur_demo", dst)
    return dst


def custom_blur_demo(image):
    # kernel = np.ones([5,5], np.float32)/25
    kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]], np.float32)
    dst = cv.filter2D(image, -1, kernel=kernel)
    cv.imshow("custom_blur_demo", dst)
    return dst


def edge_demo(image):
    blurred = cv.GaussianBlur(image, (1, 1), 0)
    gray = cv.cvtColor(blurred, cv.COLOR_BGR2GRAY)
    ret, thresh = cv.threshold(gray, 127, 255, cv.THRESH_BINARY)
    xgrad = cv.Sobel(image, cv.CV_16SC1, 1, 0)
    ygrad = cv.Sobel(image, cv.CV_16SC1, 0, 1)
    edge_output = cv.Canny(xgrad, ygrad, 30, 90)  # 3:1
    #cv.imshow("Canny Edge", edge_output)
    return edge_output


def convex_demo(img):
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    ret, thresh = cv.threshold(gray, 127, 255, cv.THRESH_BINARY)
    contours, hierarchy = cv.findContours(thresh, 2, 1)
    for cnt in contours:
        hull = cv.convexHull(cnt)
        length = len(hull)
        if length > 3:
            for i in range(length):
                cv.line(img, tuple(hull[i][0]), tuple(hull[(i + 1) % length][0]), (0, 0, 255), 2)
    cv.imshow('convex', img)
    cv.waitKey()
    return img


def poly_demo(img):
    imgray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    ret, thresh = cv.threshold(imgray, 127, 255, 0)
    contours, hierarchy = cv.findContours(thresh, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
    cnt = contours[1]

    epsilon = 0.5 * cv.arcLength(cnt, True)
    approx = cv.approxPolyDP(cnt, epsilon, True)
    cv.polylines(img, [approx], True, (0, 0, 255), 2)

    cv.imshow('poly_demo', img)
    cv.waitKey()
    return img


def color_change(image):
    print(image.shape)
    height = image.shape[0]
    width = image.shape[1]
    channels = image.shape[2]
    print("width: %s, height: %s, channels: %s" % (width, height, channels))
    for row in range(height):
        for col in range(width):
            for c in range(channels):
                if c == 2:
                    if image[row, col, c] == 255:
                        image[row, col, c] = 0
                elif c == 1:
                    if image[row, col, c] == 255:
                        image[row, col, c] = 255
                elif c == 0:
                    if image[row, col, c] == 255:
                        image[row, col, c] = 0
    cv.imshow("color change", image)
    return image


def sobel_demo(image):
    # image = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
    sobelX = cv.Sobel(image, cv.CV_64F, 1, 0)
    sobelY = cv.Sobel(image, cv.CV_64F, 0, 1)
    sobelX = np.uint8(np.absolute(sobelX))
    sobelY = np.uint8(np.absolute(sobelY))
    sobelCombined = cv.bitwise_or(sobelX, sobelY)
    cv.imshow("Sobel_X", sobelX)
    cv.imshow("sobel_Y", sobelY)
    plus_sobel = cv.add(sobelX, sobelY)
    cv.imshow("sobel_plus", plus_sobel)
    cv.waitKey()
    return sobelY


def erode(img):
    h = img.shape[0]
    w = img.shape[1]
    img1 = np.zeros((h, w), np.uint8)
    for i in range(1, h - 1):
        for j in range(1, w - 1):
            min = img[i, j]
            for k in range(i - 1, i + 2):
                for l in range(j - 1, j + 2):
                    if k < 0 | k >= h - 1 | l < 0 | l >= w - 1:
                        continue
                    if img[k, l] < min:
                        min = img[k, l]
            img1[i, j] = min
    cv.imshow("erode", img1)
    return img1


def expand(img):
    h = img.shape[0]
    w = img.shape[1]
    img1 = np.zeros((h, w), np.uint8)
    for i in range(1, h - 1):
        for j in range(1, w - 1):
            max = img[i, j]
            for k in range(i - 1, i + 2):
                for l in range(j - 1, j + 2):
                    if k < 0 | k >= h - 1 | l < 0 | l >= w - 1:
                        continue
                    if img[k, l] > max:
                        max = img[k, l]
            img1[i, j] = max
    cv.imshow("expand", img1)
    return img1


def inverse(image):
    dst = cv.bitwise_not(image)
    cv.imshow("inverse demo", dst)
    return dst


def vote_window(image):  # vote window
    print(image.shape)
    height = image.shape[0]
    width = image.shape[1]
    print("width: %s, height: %s" % (width, height))
    for row in range(2, height - 1, 3):
        for col in range(2, width - 1, 3):
            pv0 = image[row, col]
            pv1 = image[row - 1, col - 1]
            pv2 = image[row - 1, col]
            pv3 = image[row - 1, col + 1]
            pv4 = image[row, col - 1]
            pv5 = image[row, col + 1]
            pv6 = image[row + 1, col - 1]
            pv7 = image[row + 1, col]
            pv8 = image[row + 1, col + 1]
            vote_sum = (float(pv1) + float(pv2) + float(pv3) + float(pv4) +
                        float(pv5) + float(pv6) + float(pv7) + float(pv8))
            vote_ratio = vote_sum / 2040.0
            print("vote ratio", vote_ratio)
            if vote_ratio >= 0.125:
                image[row, col] = 0
                image[row - 1, col - 1] = 0
                image[row - 1, col] = 0
                image[row - 1, col + 1] = 0
                image[row, col - 1] = 0
                image[row, col + 1] = 0
                image[row + 1, col - 1] = 0
                image[row + 1, col] = 0
                image[row + 1, col + 1] = 0
            else:
                image[row, col] = 255
                image[row - 1, col - 1] = 255
                image[row - 1, col] = 255
                image[row - 1, col + 1] = 255
                image[row, col - 1] = 255
                image[row, col + 1] = 255
                image[row + 1, col - 1] = 255
                image[row + 1, col] = 255
                image[row + 1, col + 1] = 255
    cv.imshow("pixels_demo", image)
    return image


inputfolder="F:/CR/picture_2_13/Original_2_13/"           #the name of the folder that store original files
originalnames=os.listdir(inputfolder)                #Get the names of original files
originalnames.sort(key=lambda x:int(x[-9:-4]))

outputfolder='F:/CR/picture_2_13/Post_2_13/'                           #the name of the folder that store post files
suffix='_edge.jpg'                                   #extension name
postpaths=[]
for i in originalnames:
    postpaths.append(outputfolder+i[0:5]+suffix)     # Get the paths of post files
    src = cv.imread(inputfolder+i)
    src1 = edge_demo(src)
    cv.imwrite(postpaths[-1], src1)
    cv.waitKey(0)
    cv.destroyAllWindows()

# src = cv.imread("F:/CR/Original/picture_1_22/00930.tif")
# #cv.namedWindow("input image", cv.WINDOW_AUTOSIZE)
# #cv.imshow("input image", src)
# src1 = edge_demo(src)
# cv.imwrite('F:/CR/Post/00930_edge.jpg', src1)
# cv.waitKey(0)
# cv.destroyAllWindows()

