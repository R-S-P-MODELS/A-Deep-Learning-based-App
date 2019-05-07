#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



PredictImage=function(imagem,modelo,pickle,linhas){
  require(reticulate)
  use_python("/usr/bin/python3")
  require(keras)
  u=modelo
 # u=load_model_hdf5(modelo)
  source_python("classify_function.py")
  l1=prediction(u,pickle,imagem)
  l1=data.frame(l1)
  l1=l1[order(l1$probability,decreasing=TRUE),]
  if(nrow(l1)<linhas)
    print(l1)
  else
    print(l1[1:linhas,])
}

library(shiny)
library(keras)
library(reticulate)
use_python("/usr/bin/python3")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Deep Learning Predictor"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         fileInput(inputId = "SelectImage",label = "Selecione a imagem",accept = c('.jpg','.png')),
        # fileInput(inputId = "SelectModel",label = "Selecione o modelo",accept = c('.model','.hdf5')),
        # fileInput(inputId = "SelectPickle",label = "Selecione o arquivo binarizer pickle",accept = c('.pickle')),
	numericInput(inputId="linhas",label="numero de classes preditas",min=1,max=1000,value=5)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(id="Referenciador",
          tabPanel("Classify Species",verbatimTextOutput("Probabilities")),
          tabPanel("Classify Health",verbatimTextOutput("Probabilities2"))
        ),
        plotOutput("distPlot"),
         
         h3("Aplicativo desenvolvido por Rafael Silva Pereira!\n\n"),
         h4("Em caso de duvidas ou problemas favor entrar em contato\n\n"),
         h4("Para gerar o grafico a primeira vez clique para completar o dataset, não será nescessario para futuras explorações\n\n"),
         h4("r.s.p.models@gmail.com")
      
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  options(shiny.maxRequestSize=1000000*1024^2)

  plot_jpeg = function(path, add=FALSE)
  {
    require('jpeg')
    jpg = readJPEG(path, native=T) # read the file
    res = dim(jpg)[2:1] # get the resolution, [x, y]
    if (!add) # initialize an empty plot area if add==FALSE
      plot(1,1,xlim=c(1,res[1]),ylim=c(1,res[2]),asp=1,type='n',xaxs='i',yaxs='i',xaxt='n',yaxt='n',xlab='',ylab='',bty='n')
    rasterImage(jpg,1,1,res[1],res[2])
  }
   
   output$distPlot <- renderPlot({
     if(!is.null(input$SelectImage)){
       
      #library(raster)  
      #myJPG <- stack(input$SelectImage$datapath)  
      #plotRGB(myJPG)
      plot_jpeg(input$SelectImage$datapath)
    }
   })
   
   output$Probabilities=renderPrint({
     if(!is.null(input$SelectImage)  ){
        #source("KerasRAndPythonScript.R")
        #PredictImage(input$SelectImage$datapath,input$SelectModel$datapath,input$SelectPickle$datapath,input$linhas)
       modelo=LeituraModeloEspecies()
       PredictImage(input$SelectImage$datapath,modelo,"SaidaLatim.pickle",input$linhas)
       
       
     }    
   })
   
   output$Probabilities2=renderPrint({
     if(!is.null(input$SelectImage) ){
       #source("KerasRAndPythonScript.R")
       #PredictImage(input$SelectImage$datapath,input$SelectModel$datapath,input$SelectPickle$datapath,input$linhas)
       modelo=LeituraModeloDoencas()
       
       PredictImage(input$SelectImage$datapath,modelo,"SickvsHealthyFixed.pickle",input$linhas)
       
       
     }    
   })
   
   LeituraModeloEspecies<-reactive({
     u=load_model_hdf5("plants35.model")
     return(u)
   })
   
   LeituraModeloDoencas<-reactive({
     u=load_model_hdf5("DiseasedPlantsV4.model")
     return(u)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

