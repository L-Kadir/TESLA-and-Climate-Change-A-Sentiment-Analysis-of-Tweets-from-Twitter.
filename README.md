# Sentiment Analysis of Tweets about TESLA.

## Table of contents
- [Project Overview](#project-overview)
- [Data and Statistical Software](#data-and-statistical-software)
- [ETL](#etl)
- [Data Analysis and Results](#data-analysis-and-results)
- [Conclusion](#conclusion)
- [Recommendation](#recommendation)

## Project Overview
This project is conducted get a better understanding of people’s sentiments of Tesla in relatiuon to climate change. The results will help us make recommendations to the marketing team.

## Data and Statistical Software
- The data for the analysis was retrieved from twitter.
- The analysis was focused on tweets about Tesla.
- RStudio was utilized for the sentiment analysis.

## ETL
The following tasks were performed to undersand and prepare the data for the analysis:

- The data has 4492 observations and 9 columns as shown by `dim()`
- All the variables are character strings as shown by `str()`.
- Two columns had no data and were dropped as a result.
- The summary of dataset was examined using `summary()`.
- Checked for the presence of any NA’s using `any_na()`.
- Checked for the head as well as the tail of the data using `head()` and `tail()`.

## Data Analysis and Results

- By using the `mutate()` function, a new column(*h_number*) was created.
- `unnest_tokens()` function was used to add row numbers by splitting the tweets (msg) into words in a separate column.
- By using `anti_join()` function “stop words” such as "a", "in", "and", "I", "of", "is" etc., which has no sentiments were removed
- The `count()` function was then use to have a look at our word list after the stop words were removed.
- By using the `inner_join()` function, the various lexicons - **nrc**, **bing**,and **afinn** were used to extract sentiments from each word.
  
  - Below is **nrc** ranking of 15 most meaningful words (i.e., words with highest frequency) from the tweets.
    
    <img width="634" height="326" alt="image" src="https://github.com/user-attachments/assets/f94b580c-a362-40bd-81bc-d5531b3f0e5c" />

   - **bing's** ranking of 15 most meaningful words from the tweets is:
 
     <img width="663" height="362" alt="image" src="https://github.com/user-attachments/assets/c1de6f1f-61c1-4ef1-a39c-25685796b5fc" />

    - Lastly, **afinn's** ranking of 15 most meaningful words from the tweets is:
      
        <img width="665" height="350" alt="image" src="https://github.com/user-attachments/assets/5ffcd7e3-772d-4449-9b9d-aa5f7d4b2443" />

  - Now, without using any lexicon, three graphs were created:
    
      - A graph of the 20 most common words in the tweets
      - A wordcloud was also generated from the top 300 most common words.
      - A netwerok diagram based on bi-grams.
        

  <img width="1234" height="789" alt="image" src="https://github.com/user-attachments/assets/dc1df048-48a0-472c-9103-94928b2ee6e4" />
  
  <img width="559" height="503" alt="image" src="https://github.com/user-attachments/assets/4c284a8b-7d1b-4644-bfca-bc26f9af42a9" />
  
  <img width="610" height="521" alt="image" src="https://github.com/user-attachments/assets/1d97fa4c-0c8c-4fb9-9e75-db215f6493cf" />
  

  - We still saw some words like "rt", "tco", "https", "qu", etc.,in the graph above, which are not meaningful. Hence, a new custom *stop words* including those meaningless words were created and removed from the tweets using `anti_join()`, and the new results plotted. The graphs are shown below:
    

<img width="1231" height="783" alt="image" src="https://github.com/user-attachments/assets/5bc33fc1-f0fd-4af8-bda3-a4a5acfcd3d8" />

<img width="551" height="474" alt="image" src="https://github.com/user-attachments/assets/caa219ec-4429-43df-a7bd-c9a006d76327" />


## Conclusion 
- Our sentiment analysis of Tesla-related conversations highlights a few clear patterns. People are still talking a lot about the big pillars of the brand — Elon Musk, cars, models, and electric vehicles — which shows Tesla’s core identity is front and center. At the same time, words like “fail”, “told”, and “investigation” pop up enough to suggest that not all the conversation is positive. These could be tied to product hiccups, regulatory attention, or simply public perception, but they’re worth paying attention to.

- On the production side, terms like “customize”, “battery”, and “energy” stand out, pointing to strong public interest in innovation and personalization. This is an opportunity to offer more options in how people configure their cars and to keep pushing forward on battery tech. Mentions of “mercedesbenz” and “ford” remind us that competition in the EV market is heating up, making it important to keep Tesla’s edge in technology and brand appeal.

- From a marketing angle, it’s interesting to see “spacex” frequently mentioned alongside Tesla. That crossover could be used to tell more compelling stories, but it’s also a reminder to manage the brand carefully so Tesla remains distinct in minds of the public and consumers. Again, given the presence of negative words, a quick, clear, and transparent response to concerns will help protect reputation.

## Recommendation
- Product Strategy – Offer more customization and keep improving battery performance to match what customers are asking for.
- Quality & Reliability – Focus on fixing product and safety issues before they become bigger stories.
- Marketing – Share more about Tesla’s innovations, environmental impact, and real customer experiences to outweigh the negative sentiments.
- Brand Positioning – Use the SpaceX connection where it helps but keep Tesla’s identity separate and strong.
- Competitive Response – Stay ahead of rivals with regular product updates and messaging that reinforces Tesla’s leadership.
By acting on these points, Tesla can protect and grow its brand, keep customers excited, and stay ahead in a fast-changing EV market.
 
    


    





