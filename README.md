# 3D_Reconstruction_of_C-C_Needle-Punched_Composites
Reconstructing the C-C needle-punched composites from micro-CTs to 3D geometric model. 

## Edge Detection
Detected the edges using conventional algorithms, namely noise reduction, Canny, Sobel, Gaussian, morphological algorithms, and proposed voting windows.
Read edge_v3.py for more details.

## Interlayer Image Interpolation
Linear interpolation of the detected edges was achieved.
ip3.py

## Corner Detection and Matching.
Improved Shi-Tomasi feature dectection algorithm to avoid the failure cases in vanishing-gradient region.
Achieved by matlab: ct_feature_detection_3.m, match3.m

## Surface Reconstruction
Based on triangulation algorithm.
ct_triangulation4.m

## Voxel Reconstruction

