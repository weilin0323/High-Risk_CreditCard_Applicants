# High-Risk_CreditCard_Applicants

使用資料集：https://www.kaggle.com/datasets/samuelcortinhas/credit-card-classification-clean-data <br/>
詳細內容請參考附件ppt <br/>

## 研究目的
透過客戶資料了解銀行在審核信用卡申請時，會因為那些條件的不同，進而將申請人評估為有風險的族群。

## 使用資料及欄位
Credit Card Classification  <br/>
<img width="600" alt="" src="https://github.com/weilin0323/High-Risk_CreditCard_Applicants/assets/51693471/456afaa7-7148-4374-b071-282838267fb2">

## 資料探索
詳細內容請參考附件ppt

## 模型預測

共使用KNN, RandomForest, Logestic及XGBoost四種模型進行預測 <br/>

共同重要變數：<br/>
<img width="500" alt="" src="https://github.com/weilin0323/High-Risk_CreditCard_Applicants/assets/51693471/280742b2-b888-4e95-b9e6-e816bbb73dae">

準確度：<br/>
<img width="500" alt="" src="https://github.com/weilin0323/High-Risk_CreditCard_Applicants/assets/51693471/65114f98-6760-4593-9e44-32b30f3a9e3f">

結論：<br/>
* 邏輯式回歸在Accuracy跟AUC表現較好
* 年齡較低、有信用卡的月數較久、工作年資短，較有可能成為高風險族群 
* 資料中的變數大多與結果沒有關係、原始變數無法衍生其他變數協助預測，導致模型的表現不好




