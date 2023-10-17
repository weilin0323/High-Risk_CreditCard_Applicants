rm(list=ls()) # 清除所有變量
setwd("C:/Users/User/Programming/R/Homework1/BI")
library(data.table)
library(tidyverse)
library(ggthemes)
library(RColorBrewer)
library(lattice)
library(randomForest)
library(caTools)

# Part0 載入新資料集
cleandata = fread('./Application_v4.csv', encoding="UTF-8",fill = T)
# 查看dataframe各欄位資料型態
str(cleandata)
# 將Target從integer轉成Factor
cleandata[, c(2:8,15:17,19,20)] <- lapply(cleandata[,c(2:8,15:17,19,20)], as.factor)
# 將ID欄位刪除
cleandata <- cleandata[, -1] 


# Part1-1 自變數(類別)-長條圖
Income_type_DF = as.data.frame(table(cleandata$Income_type))
Education_type_DF = as.data.frame(table(cleandata$Education_type))
Family_status_DF = as.data.frame(table(cleandata$Family_status))
Housing_type_DF = as.data.frame(table(cleandata$Housing_type))
Occupation_type_DF = as.data.frame(table(cleandata$Occupation_type))
ggplot()+
  geom_bar(data=Income_type_DF,aes(x=reorder(Var1,-Freq),y=Freq),stat = "identity",fill = brewer.pal(nrow(Income_type_DF), "Set1"))+ 
  labs(title = 'Income_type 收入來源 - 長條圖') + 
  xlab("收入來源") + ylab("人數") 
ggplot()+
  geom_bar(data=Education_type_DF,aes(x=reorder(Var1,-Freq),y=Freq),stat = "identity",fill = brewer.pal(nrow(Education_type_DF), "Set2"))+ 
  labs(title = 'Education_type 教育程度 - 長條圖') + 
  xlab("教育程度") + ylab("人數")
ggplot()+
  geom_bar(data=Family_status_DF,aes(x=reorder(Var1,-Freq),y=Freq),stat = "identity",fill = brewer.pal(nrow(Family_status_DF), "Set3"))+ 
  labs(title = 'Family_status 家庭狀況 - 長條圖') + 
  xlab("家庭狀況") + ylab("人數")
ggplot()+
  geom_bar(data=Housing_type_DF,aes(x=reorder(Var1,-Freq),y=Freq),stat = "identity",fill = brewer.pal(nrow(Housing_type_DF), "Pastel1"))+ 
  labs(title = 'Housing_type 居住類型 - 長條圖') + 
  xlab("居住類型") + ylab("人數")
ggplot()+
  geom_bar(data=Occupation_type_DF,aes(x=reorder(Var1,-Freq),y=Freq),stat = "identity",fill = 2)+ 
  labs(title = 'Occupation_type 職務類型 - 長條圖') + 
  xlab("職務類型") + ylab("人數")+
  theme(axis.text.x = element_text(size=8,angle = 20, vjust = 1 , hjust=0.7)) 

# Part1-2 自變數(連續)-密度圖 、常態檢定
densityplot( cleandata$Years_employed, data=data, main="Distribution of Popularity") 
# 如果樣本數少於等於50，則看 Shapiro-Wilk 的 W 值，來檢測是否為常態分佈；
# 如果樣本數大於50，則看 Kolomogorov 的 D 值。
nortest::lillie.test(cleandata$Years_employed) # p-value < 0.05, 非常態分佈

# Part2 自變數(類別)與依變數-長條圖(比例)
ggplot(cleandata,aes(x = Income_type))+
  geom_bar(aes(fill=Target),position = "fill")+ ylab("People")
ggplot(cleandata,aes(x = Education_type))+
  geom_bar(aes(fill=Target),position = "fill")+ ylab("People")
ggplot(cleandata,aes(x = Family_status))+
  geom_bar(aes(fill=Target),position = "fill")+ ylab("People")
ggplot(cleandata,aes(x = Housing_type))+
  geom_bar(aes(fill=Target),position = "fill")+ ylab("People")
ggplot(cleandata,aes(x = Occupation_type))+
  geom_bar(aes(fill=Target),position = "fill")+ ylab("People")+
  theme(axis.text.x = element_text(size=8,angle = 80, vjust = 1 , hjust=1))

# Part2-2 自變數(連續)與依變數-最大值、最小值、平均值、中位數、第一四分位數
summary(cleandata[cleandata$Target==0,"Years_employed"])
summary(cleandata[cleandata$Target==1,"Years_employed"])

# 自變數(類別)與依變數-長條圖
# ggplot(cleandata,aes(x = Income_type,fill=Target))+
#   geom_bar(position = "dodge")+ ylab("People")
# ggplot(cleandata,aes(x = Education_type,fill=Target))+
#   geom_bar(position = "dodge")+ ylab("People")
# ggplot(cleandata,aes(x = Family_status,fill=Target))+
#   geom_bar(position = "dodge")+ ylab("People")
# ggplot(cleandata,aes(x = Housing_type,fill=Target))+
#   geom_bar(position = "dodge")+ ylab("People")
# ggplot(cleandata,aes(x = Occupation_type,fill=Target))+ 
#   geom_bar(position = "dodge")+ylab("People")+

# Part3-1 自變數(類別)與依變數-卡方檢定(獨立性檢定)
# 檢定收入來源與Target是否相關，p=0.475 > 0.05
chisq.test(table(cleandata$Income_type, cleandata$Target))
# 檢定教育程度源與Target是否相關，p=0.1037
chisq.test(table(cleandata$Education_type, cleandata$Target))
# 檢定家庭狀況與Target是否相關，p=0.08239
chisq.test(table(cleandata$Family_status, cleandata$Target))
# 檢定居住類型與Target是否相關，p=0.08239
chisq.test(table(cleandata$Housing_type, cleandata$Target))
# 檢定職務類型與Target是否相關，p=0.3682
chisq.test(table(cleandata$Occupation_type, cleandata$Target))
# 以上p值皆小於0.05，接受虛無假設，以上欄位與Target之間不相關。

# Part3-2 自變數(連續)與依變數-皮爾森檢定
# (由於Point-biserial相關係數與皮爾森相關係數很近似，因此可用皮爾森檢定來計算Point-biserial相關係數及其p值。)
cor.test(cleandata$Years_employed, as.numeric(cleandata$Target), alternative = "two.sided", method = "pearson")

# Part4-1 區分訓練資料集及測試資料集
set.seed(88)
train_index <- sample(1:nrow(cleandata), size = 0.7 * nrow(cleandata))
train_data <- cleandata[train_index,]
test_data <- cleandata[-train_index,]
train_data = data.frame(train_data)
test_data  = data.frame(test_data )

# Part4-2 原始隨機森林
rf_model = randomForest(Target~., data=train_data, ntree=150)  
# 預測
pred = predict(rf_model, test_data)
table(pred, test_data$Target) #混淆矩陣
error = 1-mean(pred==test_data$Target)
error
# Part4-3 優化隨機森林
# 畫圖-決定ntree決策樹數量
plot(rf_model) #可以看出tree大約50即可
# tuning-決定mtry抽樣數量
tuneRF(train_data[,-18], train_data[,18]) #每次抽2個變數是最好

# Part4-4 新隨機森林
new_rf_model = randomForest(Target ~ ., data=train_data, ntree=150 ,mtry=2)
# 預測
pred2 = predict(new_rf_model, test_data)
table(pred2, test_data$Target) #混淆矩陣
error2 = 1-mean(pred2==test_data$Target) #變更爛...還是用原始隨機森林

# Part5  用原始隨機森林的資料
# 變數重要性
options("scipen"=100, "digits"=4)
Target_importance = importance (rf_model)
# 變數重要性-排序並畫圖
importance_chart = Target_importance[order(Target_importance,decreasing=F),,drop=F]
barchart(importance_chart)
# AUC
pred_prob = predict(rf_model, test_data, type='prob')
colAUC(pred_prob, y=test_data$Target,plotROC = TRUE)
# 混淆矩陣函式-準確率(Accuracy)、召回率(Recall)、精確率(Precision)、型一錯誤(f1score)
AccuracyMetrices = function(x, k=3) c(
  accuracy = sum(diag(x))/sum(x),                    # 正確性
  recall = as.numeric(x[2,2]/rowSums(x)[2]),    
  precision = as.numeric(x[2,2]/colSums(x)[2]),
  #F1 Score = 2 * (Precision * Recall) / (Precision + Recall)
  f1score = (2 * (as.numeric(x[2,2]/colSums(x)[2]) * as.numeric(x[2,2]/rowSums(x)[2])) )/ (as.numeric(x[2,2]/colSums(x)[2]) + as.numeric(x[2,2]/rowSums(x)[2]))
) %>% round(k)
AccuracyMetrices(table(pred, test_data$Target),3)

