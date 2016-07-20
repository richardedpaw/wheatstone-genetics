####

To make a map that includes bathymetry, and also to calculate distances around a coastline use Marmap package
#First obtain bathymetric data from whatever source suits.
#setwd("C:/Users/richarde/Documents/CONNECTIVITY/Genetics/Mapping")
library(marmap)
#increase memory limit
# memory.limit(size = 10000000000)
NW_AUST_GEB <- readGEBCO.bathy("data/GEBCO_2014_2D.nc") ###Note that I downloaded this file. If using the NOAA data, the readNOAA.bathy command will pull data from NOAA in one go.
blues <- colorRampPalette(c("lightblue", "cadetblue2", "cadetblue1", "white"))
###using noaa website
# NW_AUST_GEB <- getNOAA.bathy(lon1 = 105, lon2 = 134, lat1 = -5, lat2 = -36, resolution = 10)

summary(NW_AUST_GEB)
#make a map
plot(NW_AUST_GEB, n = 1, image = TRUE, bpal = blues(100), main="Northwestern Australia")

##To add colour and sale bar to the bathymetry use:
plot(NW_AUST_GEB, image = TRUE)
scaleBathy(NW_AUST_GEB, deg = 2, x = "bottomleft", inset = 4)
##See marmap vignette for more options
#for example
blues <- c("lightsteelblue4", "lightsteelblue3", "lightsteelblue2", "lightsteelblue1")
greys <- c(grey(0.6), grey(0.93), grey(0.99))
plot(NW_AUST_GEB, image = TRUE, land = TRUE, lwd = 0.03, bpal = list(c(0, max(NW_AUST_GEB), greys),
                 c(min(NW_AUST_GEB), 0, blues)))
# Add coastline
plot(NW_AUST_GEB, n = 1, lwd = 0.4, add = TRUE)

#put the sites in
Lcarpo.sites <- read.table("data/L_carpo_sites.txt", header=TRUE) #A dataframe or table with 3 columns - lat long site name

#plot them on a map
plot(NW_AUST_GEB, image = TRUE, land = TRUE, n=1, bpal = list(c(0, max(NW_AUST_GEB), greys), c(min(NW_AUST_GEB), 0, blues)))

# add sampling points, and add text to the plot:
points(Lcarpo.sites$Long, Lcarpo.sites$Lat, pch = 21, col = "black", bg = "yellow", cex = 1.3)
text(116, -18, "North West\nAustralia", col = "white", font = 3)

#scaleBathy(NW_AUST_GEB, deg = 3, x = "bottomleft", inset = 15) #if you want to add a scale bar

#To calculate the shortest by-water path
#first, define the constraint for calculating a least-cost-path
trans2 <- trans.mat(NW_AUST_GEB, min.depth = -0.1) #travel cant be shallower than 0.1 metres depth. It can take a while to calculate. This is a "transition object"


#make a data frame with long lat and x and y as headers
Lcarpo.sites.table <- read.table("L_carpo_sites_reversed.txt", header=TRUE) #this is just the locations of each site
Lcarpo.sites.df <- data.frame(Lcarpo.sites.table)

out2 <- lc.dist(trans2, Lcarpo.sites.df, res = "path") #generates the the shortest by-water paths, which then can be plotted. Takes a long time (25 mins)
out3 <- lc.dist(trans2, Lcarpo.sites.df, res = "dist") #use "dist" instead of path to get a kilometres distance matrix between all sites.  

library(MASS)
write.matrix(out3, sep = " ", file="LC_distance") #export the matrix of distances in km

#plotting paths created in out2
#First, make the map
     plot(NW_AUST_GEB, xlim = c(110, 132), ylim = c(-28, -12))
          points(Lcarpo.sites.df, pch = 21, col = "yellow", bg = col2alpha("blue", .9),
                 cex = 1.2)
          text(Lcarpo.sites.df[,1], Lcarpo.sites.df[,2], lab = rownames(Lcarpo.sites.df),
               pos = c(3, 4, 1, 2), col = "blue")
          #to add in any paths
          lapply(out5, lines, col = "orange", lwd = 1, lty = 1) -> dummy
          
         