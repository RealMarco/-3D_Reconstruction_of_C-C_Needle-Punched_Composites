# -*- coding: utf-8 -*-

import numpy as np
import cv2


def extract_edge(src_img_name):
    original_img = cv2.imread(src_img_name, 0)
    #img = cv2.GaussianBlur(original_img, (5,5), 0)   #(3,3)
    #edge = cv2.Canny(img, 30, 80) #初始(60，80)
    return original_img


def color_change(src_img_name, det_img_name, edge):
    img = cv2.imread(src_img_name, 1) #读取原图again
    img_orginal=cv2.imread('00080.tif')
    img[edge ==255] = [147, 82,109 ]   #  (B,G,R)
    #cv2.imshow(det_img_name, img)
    #img=cv2.add(img1,img_orginal)
    cv2.imwrite(det_img_name, img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])
    cv2.imshow(det_img_name, img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
                

if __name__ == '__main__':
    src_img_name = '3d.PNG'
    det_img_name = '3d_color.jpg'
    color_change(src_img_name, det_img_name, extract_edge(src_img_name))
