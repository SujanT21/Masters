import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


time_series = 'LA_dividend_receipts.csv'  #(DIM: LA Dividend Receipts - Seasonally Adjusted - Office for National Statistics, 2023)
data = pd.read_csv(time_series)
time_series_data = data.to_numpy()
print(time_series_data)
variable = time_series_data[:,1]

plt.figure(figsize=(35 , 5))
plt.plot(time_series_data[:,0], time_series_data[:,1], label = 'DIM: LA dividend receipts - seasonally adjusted')
plt.grid()
#plt.ylim(15, 50)
plt.title('DIM: LA dividend receipts - seasonally adjusted')
plt.legend(loc='lower center', bbox_to_anchor=(0.5, -0.2))
plt.show()

# OpenAI's GPT-3 model
def autocorrelation(variable, lag):
    n = len(variable)
    mean = np.mean(variable)
    num = np.sum((variable[:n - lag] - mean) * (variable[lag:] - mean))
    deno = np.sum((variable - mean) ** 2)
    return num / deno

lags = range(1, 21)
autocorrelations = [autocorrelation(variable, lag) for lag in lags]

plt.bar(lags, autocorrelations, label='Autocorrelation value')
plt.legend()
plt.xlabel('Lag')
plt.ylabel('Auto-correlation')
plt.title('Plot for autocorrelation')
plt.show()