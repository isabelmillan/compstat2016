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
library(MASS)
library(DT)
library(Rcpp)
library(plotly)
library(RcppArmadillo)
library(dplyr)

sourceCpp("mcmc.cpp")

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
                        
                             
                    ),
                    tabPanel("MCMC",
                             sidebarLayout(
                               sidebarPanel(
                                 h5("Este programa realiza MCMC para el MASS Boston data set")),
                               mainPanel(column(4, selectInput("vardep", "Selecciona la variable dependiente",
                                                       c(names(MASS::Boston)), selected = 'length')),
                                 column(4, selectInput("varindep", "Selecciona la variable independiente",
                                                       c(names(MASS::Boston)), selected = 'budget')),
                                 
                                 fluidRow(
                                   DT::dataTableOutput("table")),
                                 
                                 column(10, plotlyOutput(outputId = "scatterplot")),
                                 
                                 column(4, selectInput("alpha", "Seleciona la distribución a priori para alpha:", c("normal","gamma","uniform"))),
                                 column(4, selectInput("beta", "Seleciona la distribución a priori para beta:", c("normal","gamma","uniform"))),
                                 column(4, selectInput("sigma", "Seleciona la distribución a priori para sigma:", c("normal","gamma","uniform"))),
                                 
                                 column(4, plotlyOutput(outputId = "alphaPlot")),
                                 column(4, plotlyOutput(outputId = "betaPlot")),
                                 column(4, plotlyOutput(outputId = "sigmaPlot")),
                                 
                                 column(5, sliderInput(inputId = "longitud", value = 100, label = "Selecciona la longitud de las cadenas", max = 10000, min = 100, step = 1)),
                                 column(5, sliderInput(inputId = "ncadenas", value = 2, label = "Selecciona el número de cadenas", max = 1000, min = 2, step = 1)),
                                 column(10, actionButton("go", "Calcula")),
                                 
                                 column(4, plotlyOutput((outputId = "cadena_alpha"))),
                                 column(4, plotlyOutput((outputId = "cadena_beta"))),
                                 column(4, plotlyOutput((outputId = "cadena_sigma"))),
                                 
                                 column(4, plotlyOutput((outputId = "alpha_postplot"))),
                                 column(4, plotlyOutput((outputId = "beta_postplot"))),
                                 column(4, plotlyOutput((outputId = "sigma_postplot"))),
                                 
                                 column(4, plotlyOutput((outputId = "comp_alpha"))),
                                 column(4, plotlyOutput((outputId = "comp_beta"))),
                                 column(4, plotlyOutput((outputId = "comp_sigma")))
                               )
                               )
                             )
                    )
                  )
)
                             
                    
                    
                    
                    
          
        
