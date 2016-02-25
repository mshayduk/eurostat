
<style>
table.res th {
    background-color: #333333;
    color: #ffffff;
}
table.print th {
    background-color: #d9d9d9;
    font-family: Courier; 
    font-size: small;
}
table.print td {
    font-family: Courier; 
    font-size: small;
    background-color: #ffffe5;
}
.code{
    color: darkred; 
    font-family: Courier; 

}

</style>





#### About this App ####

This shiny app reads the tab-separated-values dataset of European Unemployment Rate, subsets it according to the user input and visualize the results with the <span class=code>googleVis</span> package for R. 
The App appearance is driven by the <span class=code>shinydashboard</span>  R-package. The best use-case for dashboards is different compared to the case covered in this demo app, but dashboards suggest the out-of-box good-looking skin and compact layout.

The user inputs for subsetting the dataset (the ***selector input*** and the ***radio button***) are located in the sidebar. The output is presented in the tabulated body page. The additional ***selector input***  will appear automatically on the sidebar when needed.

#### Original data ####

The original data is downloaded from the [eurostat](http://ec.europa.eu/eurostat/web/main/home)  resourse.
This site is the provider of statistics on Europe. The dataset **Unemployment rate - annual data** explored in this app can be downloaded here: [tipsun20.tsv.gz](http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/tipsun20.tsv.gz) (tab separated values). For the detailed information about the dataset and the metadata see:  <http://ec.europa.eu/eurostat/web/products-datasets/-/tipsun20>.

The dataset contains the observations of the unemployment rate by year, age category and by country. The unemployment rate is the percentage of unemployed persons relative to the total labour force (employed and unemployed) based on International Labour Office (ILO) definition. 

#### Data transformations ####

The original dataset is extended with the official [ISO 3166-1 alpha-2](https://www.iso.org/obp/ui/#search) country codes (see also: <http://www.iso.org/iso/country_codes>) and the country common name. The ISO codes for all countries is downloaded from here: [iso_3166_2_countries.csv](https://commondatastorage.googleapis.com/ckannet-storage/2011-11-25T132653/iso_3166_2_countries.csv). The first 3 entries of this ISO 3166-1 alpha-2 dataset are:

<p><div align='center'>
<!-- html table generated in R 3.2.1 by xtable 1.7-4 package -->
<!-- Thu Feb 25 23:10:57 2016 -->
<table class=print border=0 width=500>
<tr> <th>  </th> <th> Common Name </th> <th> ISO 3166-1 2 Letter Code </th>  </tr>
  <tr> <td> 1 </td> <td> Afghanistan </td> <td align="center"> AF </td> </tr>
  <tr> <td> 2 </td> <td> Albania </td> <td align="center"> AL </td> </tr>
  <tr> <td> 3 </td> <td> Algeria </td> <td align="center"> DZ </td> </tr>
   </table>
</div></p>

The EU countries are selected from this dataset and merged with the original unemployment dataset.
The resulting dataset is subsetted according to the user input and the result is presented in various types of [googleVis (CRAN)](https://cran.r-project.org/web/packages/googleVis/index.html) interactive plots. 
