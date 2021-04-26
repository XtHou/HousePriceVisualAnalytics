
# first install 

*Mac*

Install `GDAL` on the command line first, e.g., using `homebrew`

```
brew install gdal
```

Then install `rgdal` and `rgeos`

```
install.packages("rgdal", type = "source")
install.packages("rgeos", type = "source")
```

### Install geojsonio

```
install.packages("geojsonio")
library("geojsonio")
```


## version changes

### geojson update

geojson_read   [*Read geojson or other formats from a local file or a URL*](https://cran.r-project.org/web/packages/geojsonio/geojsonio.pdf)

`geojson_read( x,parse = FALSE, what = "list", stringsAsFactors = FALSE, query = NULL, ...)` 

x: (character) Path to a local file or a URL. **(without 'file=')**



