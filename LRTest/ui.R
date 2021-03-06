library(shiny)


source('sourcedir.R')

renderDrugName <- function() { 
  
  ( htmlOutput('drugname') )
  
} 
renderLimit <- function() { 
  
  ( htmlOutput('limit') )
  
}  

renderStart <- function() { 
  
  ( htmlOutput('start') )
  
}  

shinyUI(fluidPage(
                  fluidRow(
                    column(width=4,
                           a(href='https://open.fda.gov/', 
                             img(src='l_openFDA.png', align='bottom') ),
                           renderDates()
                    ),
                    column(width=8,
                           titlePanel("LRT Signal Analysis for a Drug" ) )
                  ),
#   img(src='l_openFDA.png'),
#   titlePanel("RR-Drug"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        tabPanel('Data Reference', HTML( (loadhelp('overview') ) )  )
        ,
        tabPanel('Select Drug',
                 selectInput_p("v1", 'Drug Variable' ,getdrugvarchoices(), 
                               HTML( tt('drugvar1') ), tt('drugvar2'),
                               placement='top'), 
                 conditionalPanel(
                   condition = "1 == 2",
                   textInput_p("t1", "Drug Name", 'Gadobenate', 
                               HTML( tt('drugname1') ), tt('drugname2'),
                               placement='bottom'), 
                   
                   numericInput_p('limit', 'Maximum number of event terms', 50,
                                  1, 100, step=1, 
                                  HTML( tt('limit1') ), tt('limit2'),
                                  placement='bottom'), 
                   
                   numericInput_p('start', 'Rank of first event', 1,
                                  1, 999, step=1, 
                                  HTML( tt('limit1') ), tt('limit2'),
                                  placement='bottom')
                 ),
                 wellPanel(
                   bsButton("tabBut", "Select Drug and # of Events...", 
                            style='primary'),
                   br(),
                   renderDrugName(),
                   radioButtons('useexact', 'Match drug name:', c('Exactly'='exact', 'Any Term'='any'), selected='any'),
                   renderLimit(),
                   renderStart()
                 ), 
                 dateRangeInput('daterange', 'Use Reports Between: ', start = '1989-6-30', end = Sys.Date()),
                 bsModal( 'modalExample', "Enter Variables", "tabBut", size = "small",
                          htmlOutput('mymodal'), 
                          textInput_p("drugname", "Name of Drug", 'Gadobenate', 
                                      HTML( tt('drugname1') ), tt('drugname2'),
                                      placement='left'), 
                          numericInput_p('limit2', 'Maximum number of event terms', 5,
                                         1, 100, step=1, 
                                         HTML( tt('limit1') ), tt('limit2'),
                                         placement='left'),
                          
                           numericInput_p('start2', 'Rank of first event', 1,
                                         1, 999, step=1, 
                                         HTML( tt('limit1') ), tt('limit2'),
                                         placement='left'),
                          #          dateRangeInput('daterange2', 'Date Report Was First Received by FDA.', start = '1989-6-30', end = Sys.Date() ),
                          bsButton("update", "Update Variables", style='primary')),
                 wellPanel(
                   helpText( HTML('<b>Down Load Report</b>') ),
                   radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                                inline = TRUE),
                   downloadButton('downloadReport')
                 ),
                 
                 bsAlert("alert")
                 ,
                 HTML( (loadhelp('LRT') ) )  
)
        ,
    id='sidetabs', selected='Select Drug')
    ),
    mainPanel(
      
      bsAlert("alert2"),
      tabsetPanel(
                tabPanel("LRT Results based on Total Events",
                         wellPanel(
                         htmlOutput( 'prrtitle' ), 
                         helpText('Results sorted by LRR')
                         ),
#                          wordcloudtabset('cloudprr', 'prr', 
#             `                             popheads=c( tt('prr1'), tt('word1') ), 
#                                          poptext=c( tt('prr5'), tt('word2') ) )
                         maketabset( c('prr', 'cloudprr', 'textplot'), 
                                     types=c('html', "plot", 'plot'),
                                     names=c("Table","Word Cloud", "Text Plot"), 
                                     popheads = c(tt('prr1'), tt('word1'), tt('textplot1') ), 
                                     poptext = c( tt('prr5'), tt('wordLRT'), tt('textplot2') ) )
                ),
              tabPanel("Simulation Results for Event Based LRT",
                       wellPanel( 
                         plotOutput( 'simplot')
                        )
              ),
                tabPanel("Analyzed Event Counts for Drug"   ,
                         wellPanel( 
                           htmlOutput( 'alldrugtextAnalyzedEventCountsforDrug' ),
                           htmlOutput_p( 'alldrugqueryAnalyzedEventCountsforDrug' ,
                                         tt('gquery1'), tt('gquery2'),
                                         placement='bottom' )
                         ), 
                         wellPanel( 
                           htmlOutput( 'titleAnalyzedEventCountsforDrug' ), 
 #                          tableOutput("query"),
                           htmlOutput_p( 'queryAnalyzedEventCountsforDrug' ,
                                       tt('gquery1'), tt('gquery2'),
                                       placement='bottom' )
                         ),
                    wordcloudtabset('cloudAnalyzedEventCountsforDrug', 'AnalyzedEventCountsforDrug', 
                                    popheads=c( tt('event1'), tt('word1') ), 
                                    poptext=c( tt('event2'), tt('word2') )
                    )
                ),
                tabPanel("Analyzed Event Counts for All Drugs",
                         wellPanel( 
                           htmlOutput( 'alltext' ),
                           htmlOutput_p( 'queryalltext' ,
                                       tt('gquery1'), tt('gquery2'),
                                       placement='bottom' )
                         ),
                        htmlOutput( 'alltitle' ), 
                        wordcloudtabset('cloudall', 'all', 
                                         popheads=c( tt('event1'), tt('word1') ), 
                                         poptext=c( tt('event2'), tt('word2') ))
                ),
                tabPanel("Counts For Drugs In Selected Reports",
                         wellPanel( 
                           htmlOutput( 'cotext' ),
                           htmlOutput_p( 'querycotext' ,
                                       tt('gquery1'), tt('gquery2'),
                                       placement='bottom' )
                         ),
                           htmlOutput( 'cotitle' ),
                         wordcloudtabset('cloudcoquery', 'coquery',
                                         popheads=c( tt('codrug1'), tt('word1') ), 
                                         poptext=c( tt('codrug3'), tt('word2') ))
                 ),
                tabPanel("Event Counts for Drug",
                         wellPanel( 
                           htmlOutput( 'cotextE' ),
                           htmlOutput_p( 'querycotextE' ,
                                         tt('gquery1'), tt('gquery2'),
                                         placement='bottom' )
                         ),
                         wellPanel(
                           htmlOutput( 'cotitleE' )
                         ),
                         wellPanel(
                           htmlOutput( 'cotitleEex' ),
                           htmlOutput( 'coqueryEex' )
                         ),
                         htmlOutput_p( 'coquerytextE' ,
                                       tt('gquery1'), tt('gquery2'),
                                       placement='bottom' ),
                         wordcloudtabset('cloudcoqueryE', 'coqueryE',
                                         popheads=c( tt('codrug1'), tt('word1') ), 
                                         poptext=c( tt('codrug3'), tt('word2') ))
                ),
                tabPanel("Counts For All Events",
                         wellPanel( 
                           htmlOutput( 'cotextA' ),
                           htmlOutput_p( 'querycotextA' ,
                                         tt('gquery1'), tt('gquery2'),
                                         placement='bottom' )
                         ),
                         wellPanel(
                           htmlOutput( 'cotitleA' )
                         ),
#                          htmlOutput_p( 'coquerytextA' ,
#                                        tt('gquery1'), tt('gquery2'),
#                                        placement='bottom' ),
                         wordcloudtabset('cloudcoqueryA', 'coqueryA',
                                         popheads=c( tt('codrug1'), tt('word1') ), 
                                         poptext=c( tt('codrug3'), tt('word2') ))
                ),
                tabPanel("Counts For Indications In Selected Reports",
                         wellPanel( 
                           htmlOutput( 'indtext' ),
                           htmlOutput_p( 'queryindtext' ,
                                       tt('gquery1'), tt('gquery2'),
                                       placement='bottom' )
                         ),
                         wellPanel(
                           htmlOutput( 'indtitle' )
                         ),
                         wordcloudtabset('cloudindquery', 'indquery',
                                         popheads=c( tt('indication1'), tt('word1') ),
                                         poptext=c( tt('indication2'), tt('word2') ) )
                ),
                tabPanel("Other Apps",  
                         wellPanel( 
                           htmlOutput( 'applinks' )
                         )
                ),
                tabPanel('Data Reference', HTML( renderiframe('https://open.fda.gov/drug/event/') ) ),
                tabPanel('About', 
                         img(src='l_openFDA.png'),
                         HTML( (loadhelp('about') ) )  ),
#                 tabPanel("session",  
#                          wellPanel( 
#                            verbatimTextOutput( 'urlquery' )
#                          )
#                 ),
              id='maintabs'
            )
          )
        )
      )
    )
