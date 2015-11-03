bolls
=====

Center-dynamics (aka spheroid) models like the following 800 bodies with springs between each other:

![800 bodies with springs](springs.gif)

The models can be compiled using [CUDAs](https://developer.nvidia.com/cuda-downloads) `$ nvcc -arch=compute_30 models/model.cu` and produce [vtk files](http://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdfhttp://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdf) that can be visualized for instance with [ParaView](http://www.paraview.org/).