import numpy as np
import pandas as pd

income_train = pd.read_csv("income.csv", 
  names=["age", "class", "fnlwgt",
  "education", "education_num", "marital_status", 
  "occupation", "relationship","race", "sex","capital_gain", 
  "capital_loss","hours_per_week", "native_country", "income"]);