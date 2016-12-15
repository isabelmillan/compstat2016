#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(title="Estad??stica Computacional",
                  tabsetPanel(
                    tabPanel("Metodo funcion inversa",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa simula la distribucin de la funci??n exponencial por el m??todo de la funci??n inversa"),
                                 numericInput(inputId="numinversa",label="Escoge el numero de simulaciones",
                                              value=1000, min=0, max=10000000),
                                 numericInput(inputId="lamda", label="Escoge el parametro lamda de la funci??n exponencial",
                                              value=.2,min=0,max=1000,step=.1)
                                 #  numericInput(inputId="valory",label="Escoge el rango de y en el que quieres la grafica",
                                 #              value=80,min=0,max=1000,step=1)
                               ),
                               mainPanel(
                                 plotOutput("hist1"),
                                 h6("El valor p obtenido en la prueba de bondad de ajuste Kolmogorov-Smirnov es"),
                                 textOutput("ks")
                                 
                               )
                             )  
                    ),
                    
                    tabPanel("Metodo Montecarlo",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa resuelve cualquier integral definida usando simulaci??n de uniformes y Montecarlo"),
                                 textInput(inputId="Phi", label="Escribe la funci??n que deseas integrar", value= "function(x) 2*x"),
                                 numericInput(inputId="nsim2", label="N??mero de puntos a simular", value=100),
                                 numericInput(inputId = "nmin", label="Escoge el valor inferior del numero de simulaciones", value= 100),
                                 numericInput(inputId = "nmax", label="Escoge el valor superior del numero de simulaciones", value= 10000),
                                 numericInput(inputId = "a", label="Escoge el valor inferior del intervalo", value=0),
                                 numericInput(inputId = "b", label="Escoge el valor superior del intervalo", value=2),
                                 sliderInput(inputId = "alpha", label="Escoge el nivel de confianza de intervalos que deseas", min= .001, max=.5, value=0.05)
                               ),
                               mainPanel(
                                 plotOutput("graficamontecarlo")
                              
                                 
                               )
                             )
                             
                    )
                  ))   
        
)