# 3D-Saliency
Project code associated with Hu_etal '16 paper on 3D proto-object based saliency

### Introduction

The program is written in MATLAB (Mathworks). The code is known to run on R2014a, but should also be compatible with other versions. The main program function is **demo.m**. Running this program will compute a saliency map for each input image. In the code, you can change the dataset (see **Eyetracking Datasets** section below for more information) as well as the number of sample images from each dataset. For more details about the model, please see:

    @Article{Hu_etal16a,
      Title                    = {A proto-object based saliency model in three-dimensional space},
      Author                   = {Hu, Brian and Kane-Jackson, Ralinkae and Niebur, Ernst},
      Journal                  = {Vision Research},
      Year                     = {2016},
      Pages                    = {42--49},
      Volume                   = {119},
      Doi                      = {10.1016/j.visres.2015.12.004},
    }


### Eyetracking Datasets

The model was tested on three separate 3D eyetracking datasets. We refer the reader to the original authors' download sites in order to get the data and any other associated post-processing files. We include a few sample images from each dataset in the **datasets** directory in order to demo our code.

1. [NUS-3D](https://sites.google.com/site/vantam/nus3d-saliency-dataset)

2. [Gaze-3D](http://ivc.univ-nantes.fr/en/databases/3D_Gaze/)

3. [NCTU-3D](http://shallowdown.wixsite.com/chih-yao-ma/nctu-3dfixation-database)

### Evaluation Code

Evaluating the performance of the saliency model with and without depth information was done using multiple metrics from the [MIT Saliency Benchmark](http://saliency.mit.edu/home.html). A description of these metrics and the associated code can be found [here](https://github.com/cvzoya/saliency). We currently do not include any evaluation code in this repository.

### Miscellaneous

If you have any questions, please feel free to contact me at bhu6 (AT) jhmi (DOT) edu.
