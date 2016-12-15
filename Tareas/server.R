#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(MASS)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

########Función inversa
  
  set.seed(20160817)
  output$hist1<-renderPlot({
    hist((-log(1-runif(input$numinversa))/(input$lamda)),
         breaks=50, col='skyblue',
         xlab="Valor", probability = TRUE,
         
         main= "Distribucion exponencial por metodo de la funcion inversa")
    curve(dexp(x, rate=input$lamda),add=TRUE)}
    
  )
  
  prueba<-reactive({
    
    exponencial<-(-log(1-runif(input$numinversa))/(input$lamda))
    funcioninversa<- ks.test(exponencial,dexp)
    funcioninversa
  })  
  
  output$ks<-renderPrint(prueba())    
  
  
########## Montecarlo
  
  phi<- reactive({
    texto<-paste("aux<-", input$Phi)
    eval(parse(text=texto))
    aux
  })
  
  
  
  output$graficamontecarlo<- renderPlot({   
    nsim<-input$nsim2
    nmin<-input$nmin
    nmax<-input$nmax
    a<-input$a
    b<-input$b
    alpha<-input$alpha
    
    mc<-replicate(nsim,{
      n<-floor(runif(1,nmin,nmax))
      densx<-runif(n,min=a,max=b)
      phix<-sapply(densx,phi())
      estim<-mean(phix)
      intervalo<-estim + c(-1,1)*qnorm(1-alpha/2)*sqrt(var(phix)/n)
      (c(n,estim,intervalo[1],intervalo[2]))
      
    })
    mc<-as.data.frame(t(mc))
    names(mc)<-c("Nsimulaciones", "Estimacion", "intervaloinf","intervalosup")
    mc
    
    graf<- ggplot(mc, aes(x=Nsimulaciones,y=Estimacion)) + 
      ggtitle(paste("Estimación Montecarlo con",(1-alpha)*100,"% de confianza", sep="")) +
      geom_line(aes(y = Estimacion), colour = "red") +
      geom_ribbon(aes(ymin = intervaloinf, ymax= intervalosup),alpha=0.2)
    
    graf 
    
  })
  
####### MCMC
  
  #Datos
  output$table <- DT::renderDataTable(DT::datatable({
    data <- tbl_df(MASS::Boston)
    data
  }))
  
 # Defininición de variables
  
  varindep <- reactive({
    data <- tbl_df(MASS::Boston)
    varindep <- data[ ,which(names(data) == input$varindep)]
    varindep
  })
  
  vardep <- reactive({
    data <- tbl_df(MASS::Boston)
    varindep <- data[ ,which(names(data) == input$vardep)]
    varindep
  })
  
  datos <- reactive({
    datos <- cbind(varindep(), vardep())
    nombres <- c('varindep', 'vardep')
    colnames(datos) <- nombres
    datos
  })
  

#Graficando  
  output$scatterplot <- renderPlotly ({
    datos <- datos()
    plot_ly(datos, x = datos$varindep, y = datos$vardep, type = 'scatter', mode = 'markers')
  })
  
# Distribuciones a priori
  
  alphaDist <- reactive({
    input$alph
  })
  
  betaDist <- reactive({
    input$beta
  })
  
  sigmaDist <- reactive({
    input$sigma
  })
  
  plotPrior <- function(dist){
    
    if(dist == "normal") {
      x <- seq(-10, 10, by=.1)
      y <- dnorm(x)
      plt <- plot_ly(x = x, y = y, type = 'scatter', mode = 'lines', name = 'prior')
    }
    
    else if(dist == "gamma")
    {
      x <- seq(0, 10, by=.1)
      y <- dgamma(x,2,2)
      plt <- plot_ly(x = x, y = y,  type = 'scatter', mode = 'lines', name = 'prior')
    } 
    else if(dist == "uniform")
    {
      x <- seq(0, 10, by=.1)
      y <- dunif(x)
      plt <- plot_ly(x = x, y = y, type = 'scatter', mode = 'lines', name = 'prior')
    }
    plt
  }
  
  
  output$alphaPlot <- renderPlotly({
    plotPrior(alphaDist())
  })
  
  output$betaPlot <- renderPlotly({
    plotPrior(betaDist())
  })
  
  output$sigmaPlot <- renderPlotly({
    plotPrior(sigmaDist())
  })
  
  # Simulación
  
  ncadenas <- reactive({
    input$ncadenas
  })
  
  longitud <- reactive({
    input$longitud
  })
  
  cadena <- eventReactive(input$go, {
    
    n <- longitud()
    datos <- datos()
    
    x <- datos$varindep
    y <- datos$vardep
    
    mcmc <- mcmc(n, c(0,0,0), x, y)
    mcmc$chain
  })
  
  # Cadenas
  
  output$cadena_alpha<- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 1]
    plot_ly(y = cadena, type = 'scatter', mode = 'lines')
  })
  
  output$cadena_beta <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 2]
    plot_ly(y = cadena, type = 'scatter', mode = 'lines')
  })
  
  output$cadena_sigma <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 3]
    plot_ly(y = cadena, type = 'scatter', mode = 'lines')
  })
  
  # Histogramas 
  
  output$alpha_postplot <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 1]
    plot_ly(x = cadena, type="histogram", name = "Posterior alpha", nbinsx = 10)
  })
  
  output$beta_postplot <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 2]
    plot_ly(x=cadena, type="histogram", name = "Posterior beta", nbinsx = 10)
  })
  
  output$sigma_postplot <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 3]
    plot_ly(x=cadena, type="histogram", name = "Posterior sigma", nbinsx = 10)
  })
  
  
  # Comparación 
  
  output$comp_alpha <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 1]
    densidad <- density(cadena)
    d1 <- densidad[[1]]
    d2 <- densidad[[2]]
    
    plotPrior(alphaDist()) %>%
      add_trace(x = d1, y = d2, type = 'scatter', mode = 'lines', name = 'posterior') %>%
      layout(yaxis2 = list(overlaying = "y", side = "right"))
    
  })
  
  output$comp_beta <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 2]
    densidad <- density(cadena)
    d1 <- densidad[[1]]
    d2 <- densidad[[2]]
    
    plotPrior(betaDist()) %>%
      add_trace(x = d1, y = d2, type = 'scatter', mode = 'lines', name = 'posterior') %>%
      layout(yaxis2 = list(overlaying = "y", side = "right"))
    
  })
  
  output$compsigma <- renderPlotly({
    ncadenas <- longitud() - ncadenas()
    cadena <- cadena()
    cadena <- cadena[-(1:ncadenas) , 3]
    densidad <- density(cadena)
    d1 <- densidad[[1]]
    d2 <- densidad[[2]]
    
    plotPrior(sigmaDist()) %>%
      add_trace(x = d1, y = d2, type = 'scatter', mode = 'lines', name = 'posterior') %>%
      layout(yaxis2 = list(overlaying = "y", side = "right"))
  })
  
})  
  
    

