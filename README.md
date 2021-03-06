# MPS_ImageClassifier
MATLAB code for our project "Learning architectures based on quantum entanglement: a simple matrix product state algorithm for image recognition". The paper is available at arXiv:1803.09111. This code is mainly maintained by Dr. Shi-Ju Ran and me.


1. Before running the code, please set the Parameter.m. 

	1.1 You should put the following files from MNIST into the Para.TrainDataPath:
        "train-images.idx3-ubyte"  "train-labels.idx1-ubyte"
        "t10k-images.idx3-ubyte"  "t10k-labels.idx1-ubyte"
    These data can be download from http://yann.lecun.com/exdb/mnist/ [1] for free. You may also want to change Para.TrainDataPath (line 38) according to your need.

	1.2 As shown in the paper, we mainly discuss four cases: Real space, Real space + Reorder/Cut, Frequency space, Frequency space + Reorder/Cut. This can be controlled by these parameters: Para.Fourier; Para.IsReorder; Para.CutNum. 
  
	1.3 The resulting data are stored in Para.EXP. You may want to change it as you wish.
  
2. Run MainFun.m to execute the code. If you want to loop over some parameters, you may look into the files in "RunLoop". The files in "PlotKit" can help you get some nice plots from your data.

3. Enjoy :)

Note: The file readMNIST.m is contributed by Siddharth Hegde[2] with modification. For some parts of the code, one can consider MATLAB package "Tensor_Toolbox"[3]. In the current version this toolbox is not used.

[1] Yann LeCun, Corinna Cortes and Christopher J.C. Burges. THE MNIST DATABASE of handwritten digits, Available online. URL: http://yann.lecun.com/exdb/mnist/

[2] Siddharth Hegde. readMNIST, Available online. URL: http://www.codeforge.com/read/242556/readMNIST.m__html

[3] Brett W. Bader, Tamara G. Kolda and others. MATLAB Tensor Toolbox Version 2.6, Available online, February 2015. URL: http://www.sandia.gov/~tgkolda/TensorToolbox/.
