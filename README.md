# CITS4402-Project-Group-16

Start by clicking the 'Load Folder' button and selecting the numbered 
folder (e.g. 001)

Our full algorithm doesn't work, but the aim was for the user to click the 
'Run Algorithm' button to run the tracking software

Entering a frame number into edit field and clicking the 'Load Frame' button
will display an image and the bounding boxes provided by the gt file

Clicking the 'Candidate Detection' button will show the output of the 
detection step for each frame

Clicking the 'Object Discrimination' button after this will show the output
of the discrimination step for each frame.

We have two versions of the algorithm - the object detection and discrimination
are the same, but each version has a different attempt at the Kalman filter.