# A-Deep-Learning-based-App
In this repository i show a app in which a shiny R app interfaces with the python language, by using the keras model to both predict a plant species as well as if they are sick or healthy, the deep learning process was trained using the tensorflow backend and the app expects a jpg image of a plant


In this repository i show a deep learning based app that stores models for classyfying plants between species as well as classifying then into Healthy or Sick

The shiny interface uses the reticulate package to create a interface between R and python3, which is the code that does the deep learning part.


The backend used for classification is tensorflow and both models were trained on keras, local dependencies must be installed for this code to run

to run this app the user may write in their R interface the following command

shiny::runGitHub(repo="A-Deep-Learning-based-App",username="R-S-P-MODELS")

You can also clone the repository and build the docker image
