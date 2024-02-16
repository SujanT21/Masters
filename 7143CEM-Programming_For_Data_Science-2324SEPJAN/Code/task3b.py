# Importing relevant libraries
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# Creating a DataFrame from the provided data
cases = {
    'Age': ['0–9', '10–19', '20–29', '30–39', '40–49', '50–59', '60–69', '70–79', '≥80'],
    'Fatality': [0, 0.2, 0.2, 0.2, 0.4, 1.3, 3.6, 8, 14.8]
}

dataset = pd.DataFrame(cases)

# Setting the style of seaborn
sns.set(style="whitegrid")

# Creating the bar plot using Seaborn
plt.figure(figsize=(10, 6))  # Defining figure size
bar_plot = sns.barplot(x='Age', y = 'Fatality', data=dataset, palette='viridis')

# Rotating x-axis labels for better readability
bar_plot.set_xticklabels(bar_plot.get_xticklabels())

# Adding labels and title
plt.xlabel('Agein years')
plt.title('Coronavirus fatality rate in China')

# Displaying the plot
plt.tight_layout()
plt.show()


###################
# Importing relevant libraries
import pandas as pd
import plotly.express as px
import matplotlib.pyplot as plt

# Creating a DataFrame from the provided data
cases = {
    'Age': ['0–9', '10–19', '20–29', '30–39', '40–49', '50–59', '60–69', '70–79', '≥80'],
    'Fatality': [0, 0.2, 0.2, 0.2, 0.4, 1.3, 3.6, 8, 14.8]
}
dataset = pd.DataFrame(cases)

# Creating a bar plot using Plotly Express
fig = px.bar(dataset, x='Age', y='Fatality', title='Coronavirus fatality rate in China')

# Updating layout for better readability
fig.update_layout(xaxis_title='Age in years', showlegend=False)
fig.show()

# If you want to save the Plotly figure as an image using Matplotlib
fig.write_image("coronavirus_fatality_rate_chart.png")

# If you want to display the same data with a static Matplotlib plot
plt.figure(figsize=(10, 6))
plt.bar(dataset['Age'], dataset['Fatality'])
plt.title('Coronavirus fatality rate in China') 
plt.xlabel('Age in years') 
plt.show()



##########################
# Importing relevant libraries
import matplotlib.pyplot as plt
import pandas as pd
from plotnine import ggplot, aes, geom_bar, labs, theme_minimal, theme, element_text


# Creating a DataFrame from the provided data
cases = {
    'Age': ['0–9', '10–19', '20–29', '30–39', '40–49', '50–59', '60–69', '70–79', '≥80'],
    'Fatality': [0, 0.2, 0.2, 0.2, 0.4, 1.3, 3.6, 8, 14.8]
}
dataset = pd.DataFrame(cases)

# Create a bar plot using plotnine
plot = (
    ggplot(dataset, aes(x='Age', y='Fatality')) +
    geom_bar(stat='identity', fill='#1f78b4') +
    labs(title='Coronavirus fatality rate in China', x='Age in years') +
    theme_minimal() +
    theme(axis_text_x=element_text(angle=45, hjust=1))  # Rotating x-axis labels for better readability
)

# Save the Plotnine plot to an image file
plot.save("coronavirus_fatality_rate_plot.png")

# Read the saved image file using Matplotlib and display it
img = plt.imread("coronavirus_fatality_rate_plot.png")
plt.figure(figsize=(10, 6))
plt.imshow(img)
plt.axis('off')
plt.show()
