# DDE_project_bouncingball 🥎


## Demonstrations
Tracking of the ball with color and shape:

<img src="tracking/TrackingResults/Color/ball1_3/video.gif" width="200" height="400"> <img src="tracking/TrackingResults/Shape/ball1_3/video.gif" width="200" height="400">

## Features

This project rely on code realised in Python and MATLAB.

The tracking has been realized with opencv and imutils which can be installed with pip:
```bash
python -m pip install opencv-python
python -m pip install imutils
```

Multiple other code on Python rely on sklearn and  numpy which can be installed with pip:
```bash
python -m pip install numpy
```

The optimisation has been realised using the MATLAB MPT toolbox.

## Codes description

* [DDE_tracking_with_color.ipynb](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/tracking/DDE_tracking_with_color.ipynb) can be used to track and save the position of the center of the ball with based on its color.
* [DDE_tracking_with_shape.ipynb](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/tracking/DDE_tracking_with_shape.ipynb) can be used to track and save the position of the center of the ball with based on its shape.

* [outlier_detection.ipynb](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/outlier/outlier_detection.ipynb) aims to detect outliers in the experimental data (previously obtained with computer vision).

* [DDE_bounce_clustering.ipynb](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/clustering/DDE_bounce_clustering.ipynb) serves to split the data in each rebound of the ball in order to account for the offset caused by the ball moving slightly towards/away from the camera during the experimentation. This offset must be removed for improved results later on as it makes the accurate height of the ball harder to estimate.

* [optimisation.m](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/optimisation/optimisation.m) is a MATLAB code which has been implemented in order to deduce the actual height at which the ball was released initially from the experimental data and the coefficient of restitution. It has been realised by trying to match the experimental data with the actual physical equation behinf it with a Least-Square optimisation.

* [Trajectory_regression.ipynb](https://github.com/LouiseMassager/DDE_project_bouncingball/blob/main/regression/Trajectory_regression.ipynb) revolves around a regression method in order to estimate from the current and previous position of the ball, its next position.

## Author

- [@Louise Massager](https://github.com/LouiseMassager)
- [@Dinh-Hao Nguyen](https://github.com/Dinh-Hao-Nguyen)
- [@Yiming]
- [@Mohammadjavad Rahimi](https://github.com/MJSk8RAHIMI)


## Acknowledgements

- [opencv to track ball with color](https://stackoverflow.com/questions/63730808/golf-ball-tracking-in-python-opencv-with-different-color-balls).
- [opencv to track ball with shape](https://www.youtube.com/watch?v=RaCwLrKuS1w&ab_channel=CodeSavant).
