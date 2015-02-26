library(shiny)

shinyUI(
    fluidPage(
        sidebarLayout(
            position = "left"
            ,sidebarPanel(
                tabsetPanel(
                    tabPanel(
                        h4("RATES")
                        ,selectInput(
                            "iLocation"
                            , h3("LOCATION:")
                            ,c("U.S.A.","Alabama","Alaska","Arizona","Arkansas",
                              "California","Colorado","Connecticut","Delaware","District of Columbia",
                              "Florida","Georgia","Hawaii","Idaho","Illinois",
                              "Indiana","Iowa","Kansas","Kentucky","Louisiana",
                              "Maine","Maryland","Massachusetts","Michigan","Minnesota",
                              "Mississippi","Missouri","Montana","Nebraska","Nevada",
                              "New Hampshire","New Jersey","New Mexico","New York","North Carolina",
                              "North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania",
                              "Rhode Island","South Carolina","South Dakota","Tennessee","Texas",
                              "Utah","Vermont","Virginia","Washington","West Virginia",
                              "Wisconsin","Wyoming")
                        )
                        ,radioButtons("iUsage",h3("USAGE:"),c("RESIDENTIAL","COMMERCIAL"))
                        ,sliderInput("iHours",h3("HOURS PER DAY:"),1,24,12,1,width="90%")
                        ,sliderInput("iMaxDays",h3("INTERVAL IN DAYS:"),360,4800,480,10,width="90%")
                        ,verbatimTextOutput("")
                        ,fileInput("iRates",h3("UPLOAD RATES FILE:"),F,'.csv')
                    )
                    ,tabPanel(
                        h4("INC.BULBS")
                        ,selectInput(   "iIncandescent"
                            ,h3("INCANDESCENT BULB:")
                            ,c("40 W INCANDESCENT","60 W INCANDESCENT","75 W INCANDESCENT"
                                ,"100 W INCANDESCENT","150 W INCANDESCENT")
                        )
                        ,numericInput("iQuantity",h3("QUANTITY:"),10,1,100,1)
                        ,sliderInput("iIncPrice",h3("PRICE,$:"),0.5,3,1,0.1,width="90%")
                        ,sliderInput("iIncLifetime",h3("LIFETIME,h:"),500,2000,1000,100,width="90%")
                    )
                    ,tabPanel(
                        h4("CFL BULBS")
                        ,sliderInput("iCFLPrice",h3("PRICE,$:"),5,20,10,0.5,width="90%")
                        ,sliderInput("iCFLLifetime",h3("LIFETIME,h:"),1000,14000,10000,1000,width="90%")
                    )
                )
            )
            ,mainPanel(
                h2("SAVINGS CALCULATOR FOR COMPACT FLUORESCENT LAMPS (CFL)")
                ,h4(paste("YOU ARE SAVING MONEY STARTING FROM DAY #"))
                ,h4(textOutput("oSavingStartDate"))
                ,h4("INCADESCENT AND CFL COSTS DEVELOPMENT:")
                ,htmlOutput("Chart1")
                ,h4("SAVINGS DEVELOPMENT IN CASE OF CFL USAGE:")
                ,htmlOutput("Chart2")
            )
        )
    )
)
