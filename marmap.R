####

###To make a map that includes bathymetry, and also to calculate distances around a coastline use Marmap package
#First obtain bathymetric data from whatever source suits.
#setwd("C:/Users/richarde/Documents/CONNECTIVITY/Genetics/Mapping")
library(marmap)
#increase memory limit
# memory.limit(size = 10000000000)
NW_AUST_GEBC <- readGEBCO.bathy("data/GEBCO_2014_2D.nc") ###Note that I downloaded this file. If using the NOAA data, the readNOAA.bathy command will pull data from NOAA in one go.
blues <- colorRampPalette(c("lightblue", "cadetblue2", "cadetblue1", "white"))
###using noaa website
# NW_AUST_GEBC <- getNOAA.bathy(lon1 = 105, lon2 = 134, lat1 = -5, lat2 = -36, resolution = 10)

summary(NW_AUST_GEBC)
#make a map
plot(NW_AUST_GEBC, xlim = c(105, 132), ylim = c(-40, -5), n = 1, image = TRUE, bpal = blues(100), main="Northwestern Australia")

##To add colour and sale bar to the bathymetry use:
plot(NW_AUST_GEBC, image = TRUE)
scaleBathy(NW_AUST_GEBC, deg = 2, x = "bottomleft", inset = 4)
##See marmap vignette for more options
#for example
blues <- c("lightsteelblue4", "lightsteelblue3", "lightsteelblue2", "lightsteelblue1")
greys <- c(grey(0.6), grey(0.93), grey(0.99))
plot(NW_AUST_GEBC, image = TRUE, land = TRUE, lwd = 0.03, bpal = list(c(0, max(NW_AUST_GEBC), greys),
                 c(min(NW_AUST_GEBC), 0, blues)))
# Add coastline
plot(NW_AUST_GEBC, n = 1, lwd = 0.4, add = TRUE)

#put the sites in
coral_sites <- read.table("data/coral/coral_sites.txt", header=TRUE) #A dataframe or table with 3 columns - lat long site name

#plot them on a map
plot(NW_AUST_GEBC, image = TRUE, land = TRUE, n=1, bpal = list(c(0, max(NW_AUST_GEBC), greys), c(min(NW_AUST_GEBC), 0, blues)))

# add sampling points, and add text to the plot:
points(coral_sites$longitude, coral_sites$latitude, pch = 21, col = "black", bg = "yellow", cex = 1.3)
text(116, -18, "North West\nAustralia", col = "white", font = 3)

#scaleBathy(NW_AUST_GEBC, deg = 3, x = "bottomleft", inset = 15) #if you want to add a scale bar

#To calculate the shortest by-water path
#first, define the constraint for calculating a least-cost-path
trans2 <- trans.mat(NW_AUST_GEBC, min.depth = -0.1) #travel cant be shallower than 0.1 metres depth. It can take a while to calculate. This is a "transition object"


#make a data frame with long lat and x and y as headers
coral.sites.table <- read.table("data/coral/coral_sites_rev.txt", header=TRUE) #this is just the locations of each site
coral.sites.df <- data.frame(coral.sites.table)

#out2 <- lc.dist(trans2, coral.sites.df, res = "path") #generates the the shortest by-water paths, which then can be plotted. Takes a long time (25 mins)
out3 <- lc.dist(trans2, coral.sites.df, res = "dist") #use "dist" instead of path to get a kilometres distance matrix between all sites.  

library(MASS)
out3.m <- as.matrix(out3)
write.csv(out3.m, file="output/coral_distance.csv", row.names = F)


#plotting paths created in out2
#First, make the map
pdf("output/coral_plot.pdf", width=5, height=5)
plot(NW_AUST_GEBC, xlim = c(113.5, 130.1), ylim = c(-27, -12.2))
points(coral.sites.df, pch = 21, col = "yellow", bg = col2alpha("blue", .9), cex = 1.2)
text(coral.sites.df[,1], coral.sites.df[,2], lab = rownames(coral.sites.df), pos = c(3, 4, 1, 2), col = "blue")
          #to add in any paths
          #lapply(out2, lines, col = "orange", lwd = 1, lty = 1) -> dummy
dev.off()
  


      