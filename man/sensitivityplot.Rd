\name{sensitivityplot}
\alias{sensitivityplot}
\title{Plot of a summary of BMD values per group of items}

\description{
Plot of a summary of BMD values per group of items 
(with groups defined for example from biological annotation), 
with groups ordered by values of the chosen summary (as an ECDF plot)
or ordered as they are in the definition of the factor coding for them,
with points sized by the numbers of items per group.

}

\usage{
sensitivityplot(extendedres, BMDtype = c("zSD", "xfold"),
                group, ECDF_plot = TRUE, colorby,
                BMDsummary = c("first.quartile", "median" , "median.and.IQR"),
                BMD_log_transfo = TRUE,
                line.size = 0.5, line.alpha = 0.5, point.alpha = 0.5)
}

\arguments{
\item{extendedres}{the dataframe of results provided by bmdcalc (res)  
 or a subset of this data frame (selected lines). This dataframe can be extended 
 with additional columns coming for example from the annotation of items, and some lines 
 can be replicated if their corresponding item has more than one annotation. 
 This extended dataframe
 must at least contain the column giving the chosen BMD values
 on which to compute the sensitivity (column \code{BMD.zSD} or \code{BMD.xfold}).}

\item{BMDtype}{The type of BMD used, \code{"zSD"} (default choice) or \code{"xfold"}.}

\item{group}{the name of the column of extendedres coding for the groups
on which we want to estimate a global sensitivity. 
If \code{ECDF_plot} is FALSE, this column should be a factor ordered as you want 
the groups to appear in the plot from bottom up.}

\item{ECDF_plot}{if TRUE (default choice) groups appear ordered by 
values of the BMD summary value
from the bottom up, else they are ordered as their corresponding levels in the factor
given in \code{group}. If \code{colorby} is given, \code{ECDF_plot} is fixed to FALSE.}

  
\item{colorby}{optional argument naming the column of \code{extendedres} coding for 
an additional level of grouping that will be materialized by the color. 
If not missing,  \code{ECDF_plot} is fixed to FALSE.}

\item{BMDsummary}{The type of summary used for sensitivity plot, 
\code{"first.quartile"} (default choice)
for the plot of first quartiles of BMD values per group, 
\code{"median"} for the plot of medians of BMD values per group
and \code{"median.and.IQR"} for the plot of medians with an interval corresponding
to the inter-quartile range (IQR).}

\item{BMD_log_transfo}{If TRUE, default choice, a log transformation of the BMD is used in the plot.}

\item{line.size}{Width of the lines.}

\item{line.alpha}{Transparency of the lines.}

\item{point.alpha}{Transparency of the points.}

}

\details{
The chosen summary is calculated on the BMD values for each group 
(groups can be for example defined as pathways from biological annotation of items)
and plotted as an ECDF plot (ordered by the BMD summary) or in the order of the levels of the factor defining
the groups from bottom to up. In this plot each point is sized according to the number of items in the corresponding group. Optionally a different levels 
(e.g. different molecular levels in a multi-omics approach) can be coded by different colors.}

\value{ 
   a ggplot object.
}

\seealso{
    See \code{\link{ecdfquantileplot}}.
}

\author{ 
Marie-Laure Delignette-Muller
}

\examples{

# (1) An example from data published by Larras et al. 2020
# in Journal of Hazardous Materials
# https://doi.org/10.1016/j.jhazmat.2020.122727

# a dataframe with metabolomic results (output $res of bmdcalc() or bmdboot() functions)
resfilename <- system.file("extdata", "triclosanSVmetabres.txt", package="DRomics")
res <- read.table(resfilename, header = TRUE, stringsAsFactors = TRUE)
str(res)

# a dataframe with annotation of each item identified in the previous file
# each item may have more than one annotation (-> more than one line)
annotfilename <- system.file("extdata", "triclosanSVmetabannot.txt", package="DRomics")
annot <- read.table(annotfilename, header = TRUE, stringsAsFactors = TRUE)
str(annot)

# Merging of both previous dataframes
# in order to obtain an extenderes dataframe
# bootstrap results and annotation
annotres <- merge(x = res, y = annot, by.x = "id", by.y = "metab.code")
head(annotres)

### an ECDFplot of 25th quantiles of BMD-zSD calculated by pathway
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class", 
                            BMDsummary = "first.quartile")

\donttest{

# same plot in raw BMD scale (so not in log scale) 
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class",  
                            BMDsummary = "first.quartile",
                            BMD_log_transfo = FALSE)

### Plot of 25th quantiles of BMD-zSD calculated by pathway
### in the order of the levels as defined in the group input
levels(annotres$path_class)
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class", ECDF_plot = FALSE, 
                            BMDsummary = "first.quartile")

### an ECDFplot of medians of BMD-zSD calculated by pathway
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class",  
                            BMDsummary = "median")

### an ECDFplot of medians of BMD-zSD calculated by pathway
### with addition of interquartile ranges (IQRs) 
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class",  
                            BMDsummary = "median.and.IQR") 

### The same plot playing with graphical parameters 
sensitivityplot(annotres, BMDtype = "zSD",
                            group = "path_class",  
                            BMDsummary = "median.and.IQR",
                            line.size = 1.5, line.alpha = 0.4, point.alpha = 1) 
                           

# (2) 
# An example with two molecular levels
#
### Rename metabolomic results
metabextendedres <- annotres

# Import the dataframe with transcriptomic results 
contigresfilename <- system.file("extdata", "triclosanSVcontigres.txt", package = "DRomics")
contigres <- read.table(contigresfilename, header = TRUE, stringsAsFactors = TRUE)
str(contigres)

# Import the dataframe with functional annotation (or any other descriptor/category 
# you want to use, here KEGG pathway classes) 
contigannotfilename <- system.file("extdata", "triclosanSVcontigannot.txt", package = "DRomics")
contigannot <- read.table(contigannotfilename, header = TRUE, stringsAsFactors = TRUE)
str(contigannot)

# Merging of both previous dataframes   
contigextendedres <- merge(x = contigres, y = contigannot, by.x = "id", by.y = "contig")
# to see the structure of this dataframe
str(contigextendedres)

### Merge metabolomic and transcriptomic results
extendedres <- rbind(metabextendedres, contigextendedres)
extendedres$molecular.level <- factor(c(rep("metabolites", nrow(metabextendedres)),
                              rep("contigs", nrow(contigextendedres))))
str(extendedres)

### Plot of 25th quantiles of BMD-zSD calculated by pathway
### and colored by molecular level
# optional inverse alphabetic ordering of groups for the plot
extendedres$path_class <- factor(extendedres$path_class, 
                levels = sort(levels(extendedres$path_class), 
                decreasing = TRUE))
sensitivityplot(extendedres, BMDtype = "zSD",
                            group = "path_class", colorby = "molecular.level", 
                            BMDsummary = "first.quartile")

### Plot of medians and IQRs of BMD-zSD calculated by pathway
### and colored by molecular level
sensitivityplot(extendedres, BMDtype = "zSD",
                            group = "path_class", colorby = "molecular.level", 
                            BMDsummary = "median.and.IQR",
                            line.size = 1.2, line.alpha = 0.4, 
                            point.alpha = 0.8) 

}
}


