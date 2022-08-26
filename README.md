# Would You Have Survived the Titanic?

## Overview
Have you ever wondered whether you would've have survived the Titanic? This application uses the famous Kaggle Titanic data set to train a model that predicts the chance of survival given certain input features about a person. After several models were cross-validated for accuracy, a Random Forest classifier was chosen as the final model, and used within the application for prediction.

## File Structure

- `/app`: Contains all files and data used in the Shiny web application, deployed [here](https://akota64.shinyapps.io/titanic-app)
- `/data`: Contains the [raw Titanic data from Kaggle](https://www.kaggle.com/competitions/titanic/data)
- `/images`: Contains the images used in the [application pitch presentation](https://akota64.github.io/would_you_survive_titanic_project), made with R Markdown and Slidify
- `/model`: Contains the modeling notebook and final model used in the application. Refer to the notebook `/model/model_building_doc.Rmd` to learn more about how the model was built. Refer to `/model/model.R` for the script used to generate the final model for the application.
- `/index.Rmd` and `/index.html`: A presentation pitching the 'Would You Have Survived the Titanic?' application, available [here](https://akota64.github.io/would_you_survive_titanic_project)
