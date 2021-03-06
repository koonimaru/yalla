ya||a
=====

ya||a is yet another parallel agent-based model for morphogenesis, like the following branching process:

![Branching Model](branching.gif)

ya||a extends the spheroid model by the addition of spin-like polarities to simulate epithelial sheets and tissue polarity using pair-wise interactions only. This design is simple and lends itself to parallelization and we implemented it together with recent models for protrusions and migration for GPUs for high performance. 

The models can be compiled using [CUDAs](https://developer.nvidia.com/cuda-downloads) `$ nvcc -std=c++11 -arch=sm_XX model.cu` on Linux and macOS without further dependencies. The examples produce [vtk files](http://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdf) that can be visualized for instance with [ParaView](http://www.paraview.org/). The model  [`examples/springs.cu`](examples/springs.cu) is a good starting point to learn more.

ya||a is maintained at [github.com/germannp/yalla](https://github.com/germannp/yalla) and is freely available under the [MIT license](LICENSE).
