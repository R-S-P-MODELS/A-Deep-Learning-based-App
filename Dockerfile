FROM openanalytics/r-base

MAINTAINER Rafael Pereira "r.s.p.models@gmail.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0\
    libpoppler-cpp-dev \
    libxml2-dev
# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev

#installing python3
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
&& pip3 install --upgrade pip

#installing tensorflow and another python dependencies


RUN pip3 install numpy 
RUN pip3 install argparse 
RUN pip3 install imutils
RUN pip3 install sklearn 
RUN pip3 install opencv-python 
RUN pip3 install pandas 
#RUN pip3 install os 
RUN pip3 install tensorflow
RUN pip3 install keras

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/',dependencies=TRUE)"

# install dependencies of the Analysis app
#RUN R -e "install.packages(c('pdftools','plotly','fields','reshape2','cluster','tm'), repos='https://cloud.r-project.org/',dependencies=TRUE)"

# basic shiny functionality
RUN R -e "install.packages(c('reticulate','keras','jpeg'), repos='https://cloud.r-project.org/',dependencies=TRUE)"


# copy the app to the image
#RUN mkdir /root/Exploration
#COPY APPLastVersion.R /root/Exploration
#COPY Encontrar_candidatos_dataset_v1.R /root/Exploration
#COPY Rprofile.site /usr/lib/R/etc/
COPY appOnlyFigures.R appOnlyFigures.R
COPY classify_function.py classify_function.py  
COPY KerasRAndPythonScript.R KerasRAndPythonScript.R  
COPY mlb35.pickle mlb35.pickle   
COPY plants35.model plants35.model
EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('appOnlyFigures.R',port=3838,host='0.0.0.0',launch.browser=FALSE)"]
#CMD ["R", "-e", "shiny::runApp('/home/rafael/Downloads/APPs/DataExploration/APPLastVersion.R')"]
