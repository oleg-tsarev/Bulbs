library(shiny)
library(googleVis)

shinyServer(function(input,output){
    output$oLocation <- renderText({input$iLocation})
    output$oUsage <- renderText({input$iUsage})
    RateDefine <- reactive({
        State_desc <- c("U.S.A.","Alabama","Alaska","Arizona","Arkansas","California","Colorado",
                        "Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho",
                        "Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine",
                        "Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana",
                        "Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina",
                        "North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina",
                        "South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington",
                        "West Virginia","Wisconsin","Wyoming")
        State_code <- c("AVG","AL","AK","AZ","AR","CA","CO","CT","DE","COL","FL","GA","HI","ID","IL","IN","IA",
                        "KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC",
                        "ND","OH","OK","OR","PA","RI","SC","SD","TM","TX","UT","VT","VA","WA","WV","WI","WY")
        COMMERCIAL <- c(0.0962,0.1058,0.1479,0.0954,0.0768,0.136,0.0934,0.147,0.1011,0.12,0.0976,0.0947,0.3483,
                        0.0683,0.0819,0.0907,0.08,0.0913,0.0866,0.0779,0.1158,0.1052,0.1397,0.1095,0.0886,0.0928,
                        0.0816,0.0916,0.084,0.0886,0.134,0.1283,0.093,0.1508,0.0861,0.0798,0.0947,0.0726,0.0834,
                        0.0937,0.1204,0.0957,0.0801,0.1029,0.0817,0.0805,0.143,0.0811,0.0767,0.0842,0.1054,0.0823)
        RESIDENTIAL <- c(0.1128,0.1131,0.1784,0.1127,0.093,0.1555,0.1139,0.1735,0.1356,0.1227,0.1152,0.11,0.3727,
                         0.0847,0.1137,0.1038,0.1085,0.1117,0.0933,0.0836,0.1472,0.1285,0.1494,0.1414,0.1137,0.1019,
                         0.1007,0.1009,0.1002,0.1182,0.161,0.1579,0.1138,0.1769,0.1081,0.0903,0.1166,0.0943,0.0984,
                         0.1282,0.144,0.116,0.0998,0.1007,0.1104,0.0994,0.1731,0.1112,0.0853,0.0985,0.1327,0.0985)
        df <- data.frame(State_desc,State_code,COMMERCIAL,RESIDENTIAL)
        try(df <- read.csv(input$iRates$datapath,T,";",""),silent=T)
        df <- subset(df,df$State_desc == input$iLocation)
        if (input$iUsage=="COMMERCIAL") df[,3] else df[,4]
    })
    output$oRates <- renderText({RateDefine()})
    output$oIncandescent <- renderText({input$iIncandescent})
    output$oQuantity <- renderText({input$iQuantity})
    output$oHours <- renderText({input$iHours})
    output$oDays <- renderText({input$iDays})
    output$oIncPrice <- renderText({input$iIncPrice})
    output$oCFLLifetime <- renderText({input$iCFLLifetime})
    ParamsDefine <- reactive({
        watt <- switch(input$iIncandescent, "40 W INCANDESCENT" = 40,"60 W INCANDESCENT" = 60,
                       "75 W INCANDESCENT" = 75,"100 W INCANDESCENT" = 100,"150 W INCANDESCENT" = 150)
        MaxDays <- input$iMaxDays
        df <- data.frame(days=seq(0,MaxDays,15)
                        ,costs_inc=watt/1000*input$iHours*seq(0,MaxDays,15)*RateDefine()*input$iQuantity
                           +input$iIncPrice*(seq(0,MaxDays,15)%/%ceiling(input$iIncLifetime/24*input$iHours)+1)*input$iQuantity
                        ,costs_cfl=watt/5/1000*input$iHours*seq(0,MaxDays,15)*RateDefine()*input$iQuantity
                           +input$iCFLPrice*(seq(0,MaxDays,15)%/%ceiling(input$iCFLLifetime/24*input$iHours)+1)*input$iQuantity
                        )
        df <- data.frame(days=df$days,costs_inc=df$costs_inc,costs_cfl=df$costs_cfl,sav=df$costs_inc-df$costs_cfl)
    })
    output$oSavingStartDate <- renderText({
        df2 <- subset(ParamsDefine(),sav > 0)
        df2[1,1]
    })
    output$Chart1 <- renderGvis({
        gvisLineChart(ParamsDefine(), xvar="days", yvar=c("costs_inc","costs_cfl"),
                      options=list(legend="bottom",gvis.editor="OPTIONS"))
    })
    output$Chart2 <- renderGvis({
        df2 <- subset(ParamsDefine(),sav > 0)
        gvisLineChart(df2, xvar="days", yvar=c("sav"),
                      options=list(legend="bottom",gvis.editor="OPTIONS"))
    })
})

