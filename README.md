# 5147assignment3

## first install 

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



## json structure

**对象:{属性:数组["属性:"值"]}**

[key]键的结构是不变的：稳定性

[value]值的结构是多变的：灵活性 包括：

1. json对象

2。 json数组

3. 纯值

json对象是一对一对加进去的

json数组是一个一个加进去的
