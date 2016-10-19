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
shinyUI(fluidPage(title="Estadística Computacional",
                  tabsetPanel(
                    tabPanel("Método funcion inversa",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa simula la distribucin de la función exponencial por el método de la función inversa"),
                                 numericInput(inputId="numinversa",label="Escoge el numero de simulaciones",
                                              value=1000, min=0, max=10000000),
                                 numericInput(inputId="lamda", label="Escoge el parametro lamda de la función exponencial",
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
                    tabPanel("Método aceptacion rechazo",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa simula la distribucion de la funcion beta por el metodo de aceptacion-rechazo"),
                                 numericInput(inputId="numacept",label="Escoge el numero de simulaciones",
                                              value=1000, min=0, max=10000000),
                                 numericInput(inputId="alfa", label="Escoge el parametro alfa de la funcion beta",
                                              value=2.7,min=0,max=1000,step=.1),
                                 numericInput(inputId="beta",label="Escoge el parametro beta de la distribucion beta",
                                              value=6.3,min=0,max=1000,step=.1)
                               ),
                               mainPanel("hola"
                                         # plotlyOutput("hist3"),
                                         #b("hist4")
                                         
                               )
                               
                             )
                    ),
                    tabPanel("Método Montecarlo",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa resuelve cualquier integral definida usando simulación de uniformes y Montecarlo"),
                                 textInput(inputId="Phi", label="Escribe la función que deseas integrar", value= "function(x) 2*x"),
                                 numericInput(inputId="nsim2", label="Número de puntos a simular", value=100),
                                 numericInput(inputId = "nmin", label="Escoge el valor inferior del numero de simulaciones", value= 100),
                                 numericInput(inputId = "nmax", label="Escoge el valor superior del numero de simulaciones", value= 10000),
                                 numericInput(inputId = "a", label="Escoge el valor inferior del intervalo", value=0),
                                 numericInput(inputId = "b", label="Escoge el valor superior del intervalo", value=2),
                                 sliderInput(inputId = "alpha", label="Escoge el nivel de confianza de intervalos que deseas", min= .001, max=.5, value=0.05)
                               ),
                               mainPanel(
                                 plotOutput("graficamontecarlo"),
                                 h6("El valor inferior del intervalo de confianza es "),
                                 textOutput("bajo"),
                                 h6("El valor superior del intervalo de confianza es"),
                                 textOutput("alto")
                                 
                               )
                             )
                             
                    )
                  ))   
        
)

