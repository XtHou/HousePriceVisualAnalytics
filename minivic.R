minivic <- function(cities, cities_info, city_colors, border_colors = rep("white", 76),
                    city_names = TRUE, city_name_colors = rep("white", 76),
                    city_name_cex = 1, font = NULL){
  # Make sure all parameters are specified
  #print(nrow(cities))
  #print(length(cities_info))
  #print(length(city_colors))
  #print(length(border_colors))
  #print(length(city_name_colors))
  #print("====================")
  
  if(any(unlist(lapply(list(
    cities, city_colors, border_colors, city_name_colors
  ), length)) != 76)){
    # stop("Please make sure parameters contain exactly 76 elements.")
  }
  
  map <- data.frame(VICcity = c('West Wimmera Shire','Brimbank City','Golden Plains Shire',
                                'Hepburn Shire','Melton City','Moira Shire','Surf Coast Shire',
                                'Moorabool Shire','Greater Geelong City',
                                'Wyndham City','Warrnambool City','Hume City','Corangamite Shire',
                                'Gannawarra Shire','Yarriambiack Shire','Northern Grampians Shire',
                                'Central Goldfields Shire','Ballarat City','Moreland City',
                                'Moonee Valley City','Maribyrnong City','Hobsons Bay City',
                                'Ararat Rural City','Pyrenees Shire','Moyne Shire',
                                'Buloke Shire','Loddon Shire','Greater Bendigo City',
                                'Mount Alexander Shire','Whittlesea City','Darebin City',
                                'Yarra City','Melbourne City','Port Phillip City','Horsham Rural City',
                                'Towong Shire','Swan Hill Rural City','Southern Grampians Shire',
                                'Glenelg Shire','Mildura Rural City','Hindmarsh Shire',
                                'Macedon Ranges Shire','Greater Shepparton City','Banyule City',
                                'Boroondara City','Stonnington City','Glen Eira City','Bayside City',
                                'Campaspe Shire','Alpine Shire','East Gippsland Shire','Casey City',
                                'Benalla Rural City','Strathbogie Shire','Mitchell Shire',
                                'Nillumbik Shire','Manningham City','Whitehorse City',
                                'Monash City','Kingston City','Wellington Shire',
                                'Yarra Ranges Shire','Latrobe City',
                                'Mornington Peninsula Shire','Wangaratta Rural City',
                                'Murrindindi Shire','Maroondah City','Knox City',
                                'Greater Dandenong City','Frankston City',
                                'South Gippsland Shire','Baw Baw Shire','Wodonga City',
                                'Indigo Shire','Mansfield Shire','Bass Coast Shire'),
                    X = c(1,1,1,1,1,1,1,1,1,1,
                          2,2,2,2,2,2,2,2,2,2,2,2,
                          3,3,3,3,3,3,3,3,3,3,3,3,
                          4,4,4,4,4,4,4,4,4,4,4,4,4,4,
                          5,5,5,5,5,5,5,5,5,5,5,
                          6,6,6,6,6,6,6,6,6,6,
                          7,7,7,7,7,7,7),
                    Y = c(11,10,9,8,7,6,5,4,3,2,
                          12,11,10,9,8,7,6,5,4,3,2,1,
                          12,11,10,9,8,7,6,5,4,3,2,1,
                          13,12,11,10,9,8,7,6,5,4,3,2,1,0,
                          12,11,10,9,8,7,6,5,4,3,2,
                          11,10,9,8,7,6,5,4,3,2,
                          9,8,7,6,5,4,3),
                    stringsAsFactors = FALSE)
  
  #print(length(map$VICcity))
  #print(length(cities))
  
  #print(map$VICcity)
  # print(cities %in%  map$VICcity)
  
  
  # Make sure all cities are present
  if(!all(map$VICcity %in% cities)){
    stop("It appears some city names are repeated or missing.")
  }
  
  user_map <- data.frame(VICcity = cities, scol = city_colors, bcol =
                           border_colors, sncol = city_name_colors,
                         stringsAsFactors = FALSE)
  
  map <- merge(map, user_map, by = "VICcity")
  map$price <- cities_info
  
  text_ <- NULL
  if(city_names){
    text_ <- map$VICcity
  }
  return(
    plotbox(
      map, map$X, map$Y, map$scol, map$bcol,
      n_xboxes = 7, n_yboxes =14,
      text_ = text_, text_col = map$sncol, text_cex = city_name_cex, text_font = font
    )
  )
}

