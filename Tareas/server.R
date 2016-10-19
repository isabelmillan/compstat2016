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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
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
  
  
  # Montecarlo
  
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
 
    
})
  
 

  
  
 
