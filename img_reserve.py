import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt
def get_img_reserve(img):
#直接调用反选函数
    dst=cv.bitwise_not(img)
    cv.imshow("reserve",dst)
    cv.imwrite("CC_threshold_reserve.jpg",dst)
    edge = cv.Canny(dst, 50, 90)
    cv.imshow("no_vote_canny.jpg",edge)
    cv.imwrite("no_vote_canny.jpg",edge)
    cv.waitKey()
cv.destroyAllWindows()

img=cv.imread("CC_threshold.jpg")
get_img_reserve(img)


