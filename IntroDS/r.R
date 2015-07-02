setwd("C:\\git\\nanodegree\\1\\")

rm(list = ls())

file<-read.csv('turnstile_data_master_with_weather.csv', header=TRUE)

#rain <-file[file$rain==0, 'ENTRIESn_hourly']
#norain <-file[file$rain==1, 'ENTRIESn_hourly']


#wilcox.test(rain, norain, alternative='l') 


file[,c("UNIT")] <- as.numeric(file$UNIT)
file[,c("EXITSn_hourly", "DESCn")] <- list(NULL)

fit <- lm(ENTRIESn_hourly ~ UNIT + DATEn + Hour + maxpressurei + maxdewpti + mindewpti+minpressurei + meandewpti +     meanpressurei   +fog +rain +meanwindspdi    +mintempi +meantempi  +maxtempi +precipi +thunder, data=file)





pred = dataframe.drop('', axis = 1)
pred = pred.drop('', axis = 1)

