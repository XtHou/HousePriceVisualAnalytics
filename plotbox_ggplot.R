library(ggplot2)

plotbox <- function(thisData, x, y, color, border_col, n_xboxes, n_yboxes, text_ = NULL, text_col, text_cex = 1, text_font = NULL){
  
  g <- ggplot(data=thisData) + 
    scale_x_continuous(name="x") + 
    scale_y_continuous(name="y") +
    geom_rect(
      data=thisData, mapping=aes(
        xmin=X*3, xmax=(X + 1)*3, ymin=Y, ymax=Y + 1, text=sprintf("%s \n%s", VICcity, price)
      ),
      fill = color,
      color="black", 
      alpha=1
    )
  return(g)
}