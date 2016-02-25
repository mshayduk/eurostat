
source("utils.R")

shinyServer(function(input, output) {
    
    selectedcountry <- reactive({
        if(!is.null(input$selcountry))
            choices[grep(paste(input$selcountry, sep = ""), x=choices)]
        else
            return(curcountry)
    })
    
    output$helptext <- renderText({ 
        paste("<br><div align='center'><table width=190><tr><td align='justify' style='font-size: small;'>
              This is the explorer of the annual unemployment rate in European Union.<br><br> 
              Select parameters to subset the data and switch tabs to see different data visualizations
              </td></tr></table></div>", sep="")    
    })
    
    output$oyear <- renderPrint({input$year})
    output$ocountry <- renderPrint({input$selcountry})
    output$oage <- renderPrint({
        ageclass <- c("< 25 years" = "Y_LT25", "> 25 years" = "Y25-74", "All" = "TOTAL")
        names(ageclass)[which(ageclass==input$age)]
    })
    
    output$maptitle <- renderText({
        ageclass <- c("< 25 years" = "Y_LT25", "> 25 years" = "Y25-74", "All" = "TOTAL")
        age <- names(ageclass)[which(ageclass==input$age)]
        paste("<br><p>&nbsp;&nbsp;<b style='color:black'>Unemployment in EU. Year = ", input$year, 
              ",  Age: ", age, "</b></p>",sep = "")
    })
    
    # plots
    output$gvisbarplot <- renderGvis({
        subset <- rawdata[grep(paste(input$age,sep=""), x=rawdata$s_adj.sex.age.unit.geo.time), 
                          c("s_adj.sex.age.unit.geo.time", input$year, "isocode", "country")]
        subset <- subset[complete.cases(subset), ]
        colnames(subset)[2] <- "Unemployment"
        subset <- subset[order(subset$Unemployment, decreasing = T), ]
        ageclass <- c("< 25 years" = "Y_LT25", "> 25 years" = "Y25-74", "All" = "TOTAL")
        age <- names(ageclass)[which(ageclass==input$age)]
        title <- paste("Unemployment in EU. Year = ", input$year, ",    Age: ", age, sep = "")
        gvisBarChart(subset, xvar="country", yvar="Unemployment",
                     options = list( title = title,
                                     bar="{groupWidth:'90%'}",
                                     hAxis="{format:'##,##%'}",
                                     legend="{ position: 'top'}",
                                     width=700,
                                     height=600))
        
        
    })
    
    output$gvismap <- renderGvis({
        subset <- rawdata[grep(paste(input$age,sep=""), x=rawdata$s_adj.sex.age.unit.geo.time), 
                          c("s_adj.sex.age.unit.geo.time", input$year, "isocode", "country")]
        subset <- subset[complete.cases(subset), ]
        ageclass <- c("< 25 years" = "Y_LT25", "> 25 years" = "Y25-74", "All" = "TOTAL")
        age <- names(ageclass)[which(ageclass==input$age)]
        
        colnames(subset)[2] <- "Unemployment"
        gvisGeoChart(subset, locationvar = "isocode", 
                     colorvar = "Unemployment",     
                     hovervar = "country", 
                     options = list(region="150", 
                                    dataMode="regions",
                                    width=700, 
                                    height=400))
    })
    
    output$gviscontryplot <- renderGvis({
        subset <- rawdata[grep(paste(selectedcountry(), sep=""), x=rawdata$isocode), ]
        countryname <- subset$country[1]
        subset <- subset[1:(dim(subset)[2]-2)]
        subset <- data.frame(t(subset[-1]))
        colnames(subset) <- c("All", "> 25 years", "< 25 years")
        subset <- subset[-1, ]
        subset <- head(subset, n=-2)
        subset$Year <- as.numeric(row.names(subset))
        title <- paste("Unemployment in ", countryname, sep = "")
        
        gvisColumnChart(subset, xvar="Year", yvar=c("< 25 years", "> 25 years", "All"),
                        options=list(vAxes="[{title: 'Unemployment Rate', format:'##,##%'}]",
                                     hAxes="[{title: 'Year'}]",
                                     title=title,
                                     bar="{groupWidth:'90%'}",
                                     legend="{ position: 'top'}",
                                     width=700,
                                     height=400
                        ))
    })
    
    output$ui <- renderUI({
        if(input$tabs=="contryplot"){
            selectInput(inputId = "selcountry", 
                        label = "Select Country:",
                        choices = choices,
                        selected = selectedcountry()
            )
        }
    })
    
    outputOptions(output, "gviscontryplot", suspendWhenHidden = FALSE)
    outputOptions(output, "gvisbarplot", suspendWhenHidden = FALSE)
    outputOptions(output, "gvismap", suspendWhenHidden = FALSE)

})