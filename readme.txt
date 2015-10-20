
ENF_extract:
-------------
-------------

matlab:
-------------
The matlab files are in mat/me folders.
And the grids data are in data/folder.

enf extract :
---------------
To extract enf from grid data wav files, run mat/me/extract_and_save_enf.m files. You can provide the window time for each enf frequency. By default it is 2 second, which is about 2000 samples.

extract features:
-----------------
run mat/me/save_all_features.m
For each statistical feature, by default 32 enf were used.Features were extracted by calling extract_feature_from_enf function from extract_feature_from_enf.m file. 

enf files are saved in mat/me/grid folder.
features are saved in mat/me/features folder.

Python :
---------
python files are in py/ folder

SVM:
-----
for svm classification scikit_learn library was used. It has built in svm classifier which uses popular libsvm bindings.

First, to create data for classifier, write_mat.py script is run.

*** It will create a mat file in py/feature_data/features.mat ****

Then svm_1.py is run. You can provide splitting percentage in the command line, by default it will create 75% train data and 25% test data.





 




