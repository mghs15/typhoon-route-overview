flist <- list.files("./", pattern="table")

df <- NULL

for( file in flist ){
  print(file)
  d <- read.csv(file(file, encoding = "cp932"), header=TRUE)
  df <- rbind(df, d)
}

# write.csv(df, "typhoon-ichihyo-2001-22.csv", row.names = FALSE)

#------------------------------------------------------------------

# df <- read.csv("typhoon-ichihyo-2001-22.csv", header=TRUE)

head(df)
tail(df)

tdf <- subset(df, df[,11]>0) #最大風速34kt以上
tdf <- subset(df, df[,18]==1) #上陸のみ
tdf <- subset(df, df[,18]==1 & df[,11]>0) #最大風速34kt以上/上陸のみ

head(tdf)
tail(tdf)

#1:年	2:月	3:日	4:時（UTC）	5:台風番号	6:台風名	
#7:階級	8:緯度	9:経度	10:中心気圧	11:最大風速	
#12:50KT長径方向	13:50KT長径	14:50KT短径	
#15:30KT長径方向	16:30KT長径	17:30KT短径	18:上陸

splot <- function(x, y, col, main) {
  plot(x, y, col=col, main=main)
  m <- lm(y ~ x)
  abline(m)
  return(summary(m)) 
}

pcol = tdf[,2]

splot(tdf[,8], tdf[,10], col=pcol, main="緯度と中心気圧の関係")
splot(tdf[,8], tdf[,11], col=pcol, main="緯度と最大風速の関係")
splot(tdf[,8], tdf[,13], col=pcol, main="緯度と50KT長径の関係")
splot(tdf[,11], tdf[,13], col=pcol, main="最大風速と50KT長径の関係")
splot(tdf[,10], tdf[,13], col=pcol, main="中心気圧と50KT長径の関係")


splot(tdf[,13], tdf[,14], col=pcol, main="50KT長径と50KT短径の関係")
splot(tdf[,13], tdf[,16], col=pcol, main="50KT長径と30KT長径の関係")

pairs(tdf[,c(2,8,9,10,11,13)], panel = panel.smooth)

boxplot(tdf[,10] ~ tdf[,2], main="月と中心気圧の関係")
boxplot(tdf[,11] ~ tdf[,2], main="月と最大風速の関係")

write.csv(tdf, "tyhoon-subset.csv", row.names = FALSE)


