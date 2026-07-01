# Script Name: Zenodo Community Views & Dowloads Statistics
# Author: Stefano Della Chiesa
# Affiliation: Leibniz Institute of Ecological  Urban and Regional Development (IOER)
# Date: [23.08.2023]
# Motivation: Currently, Zenodo lacks an integrated dashboard for community-level usage statistics, and the API queries do not effectively gather these statistics. 
# As a solution, this script has been developed to offer a summary of usage statistics at the community level.

# Description: The script goal is to show some basic statistics in terms of views and download of Zenodo Community
# Be aware that the statistics cannot be 100% trusted as sometime data contains NaNs, or not all the records can be harvested.



# MAIN STEPS ----
# 1) The script collect the list of records from a Zenodo Community using the oai package.
# 2) It extracts some specific fields like (url, title, creator, datestamp)
# 3) Remove eventually some duplicates
# 4) It loops through a list of URLs and Scrape the Views and Downloads data from each Zenodo record (URL)
#it might take some time depending on the size of your Community because a time delay of 0.5 sec is introduced
#to  prevent the HTTP Error 429: "Too Many Requests". itmight not work for large communities.
#more info on Rate limites are here: https://developers.zenodo.org/?python#how-to-verify-your-quot-zenodo-json-quot-file
# 5) Data summary and plots

if (!require(oai)) install.packages('oai') 
if (!require(dplyr)) install.packages('dplyr') 
if (!require(xml2)) install.packages('xml2') 
if (!require(rvest)) install.packages('rvest') 
if (!require(ggplot2)) install.packages('ggplot2') 
if (!require(gridExtra)) install.packages('gridExtra') 

library(oai)
library(dplyr)
library(xml2)
library(rvest)
library(ggplot2)
library(gridExtra)


# API QUERY ----
# RSE Asia Association Community data
record_list<- list_records("https://zenodo.org/oai2d",metadataPrefix="oai_datacite",set="user-rse-asia-association")
#LTER-Italy Community data
#record_list<- list_records("https://zenodo.org/oai2d",metadataPrefix="oai_datacite",set="user-lter-italy")
#nfdi Community
#record_list<- list_records("https://zenodo.org/oai2d",metadataPrefix="oai_datacite",set="user-dfns")
#nfdi Community

#extract specific fields form the record_list
df <- record_list %>% select(identifier.2,title,creator, datestamp)%>% rename(url = identifier.2)  

#Remove duplicated records based on df$title (removing versions to remove statistic double count)
df_unique <- df[!duplicated(df$title), ]
#Remove specific URLs that is mistakenly replicated (previous df$title filter was not sufficient) 

df_unique <- df_unique %>% filter(url != "https://doi.org/10.5281/zenodo.7774749")


# Extract URLs from df_unique and convert to a vector
urls <- df_unique$url

# Create an empty dataframe to store the scraped data
data <- data.frame(URL = character(0), Views = numeric(0), Downloads = numeric(0))

# WEB DATA SCRAPING ----
# Function to scrape data from a single URL
# Loop through the URLs ---- scrape the data, and append it to the dataframe

for (i in seq_along(urls)) {
  url_i <- urls[i]

  print(paste("Processing URL", i, "of", length(urls)))
  
  # Read the HTML content of the URL
  page <- read_html(url_i)
  
  # OLD Zenodo GUI before September 2023
  # # Scrape the numeric values from the specific structure
  # stats_data <- page %>%
  #   html_nodes(".stats-box .stats-data") %>%
  #   html_text() %>%
  #   as.numeric()
  # 
  # # Extract the values based on their positions in the scraped data
  # view_value <- stats_data[1]
  # download_value <- stats_data[2]
  
  # NEW Zendo GUI september 2023
  # Scrape the numeric values for VIEWS and DOWNLOADS
  # view_value <- page %>%
  #   html_nodes("div.ui.statistic:contains('Views') .value") %>%
  #   html_text() %>%
  #   as.numeric()
  
  ## Alternative way as 'contains' is giving an error that 
  ## Error in method(parsed_selector) : 
  ##   The pseudo-class :contains() is unknown
  
  # experimenting step by step:
  
  stats <- page %>%
    html_elements("div.ui.statistic")
  
  stats_text <- stats %>%
    html_text(trim = TRUE)
  
  stats_text
  
  # New code to extract no. of views
  
  view_value <- stats[grepl("Views", stats_text)] %>%
    html_element(".value") %>%
    html_text(trim = TRUE)
  
  view_value <- as.numeric(view_value)
  
  ## Resume here: Write new code for computing downloads and then rent of the
  ## code should remain the same until the end of this for loop.
  
  #download_value <- page %>%
  #  html_nodes("div.ui.statistic:contains('Downloads') .value") %>%
  #  html_text() %>%
  #  as.numeric()
  
  ## New code for downloads
  
  download_value <- stats[grepl("Downloads", stats_text)] %>%
    html_element(".value") %>%
    html_text(trim = TRUE)
  
  download_value <- as.numeric(download_value)
  
  
  # Append the scraped data to the dataframe
  data <- data %>%
    add_row(URL = url, Views = view_value, Downloads = download_value)
 
  # Sys.sleep(0.5) # to prevent HTTP Error 429: Too Many Requests
  
}

# STATISTICS & PLOTS ----
# Remove observations with NA values
data <- na.omit(data)

summary(data$Views)
summary(data$Downloads)
TotalViews<-sum(data$Views)
TotalViews
TotalDownloads<-sum(data$Downloads)
TotalDownloads

# The following code is extra (it is as provided by the original author of this
# code) and not test on the Zenodo repo of the RSE Asia Association Zenodo
# community. Please use with caution

# Calculate means for Views and Downloads
mean_views <- mean(data$Views)
mean_views
mean_downloads <- mean(data$Downloads)
mean_downloads


# Create a data frame with the values for the boxplot
data_df <- data.frame(
  Type = rep(c("Views", "Downloads"), each = length(data$Views)),
  Value = c(data$Views, data$Downloads)
)

# Calculate the median and upper whisker values
medians <- aggregate(Value ~ Type, data_df, median)
upper_whiskers <- aggregate(Value ~ Type, data_df, function(x) quantile(x, 0.75) + 1.5 * IQR(x))

# Create a boxplot without outliers using ggplot2
p_bp_gg <- ggplot(data_df, aes(x = Type, y =Value )) +
  geom_boxplot(outlier.shape = NA) +  # Setting outlier.shape to NA removes outliers
  geom_point(data = medians, aes(x = Type, y = Value), color = "black", shape = 16, size = 3) +
  geom_text(data = medians, aes(x = Type, y = Value, label = round(Value, 2)),
            vjust = -1, color = "black") +
  labs(title = "Boxplot - Views & Downloads", x = NULL, y = "Values") +
  scale_x_discrete(labels = c("Downloads","Views")) +
  coord_cartesian(ylim = c(0, max(upper_whiskers$Value))) +  # Set y-axis limits
  theme_minimal()+
  theme(axis.text.x = element_text(size = 11))  # Adjust the font size and style
p_bp_gg


# Flipped boxplot using ggplot2
p_bp_gg_flipped <- ggplot(data_df, aes(x = Value, y = Type)) +  # Flip x and y aesthetics
  geom_boxplot(outlier.shape = NA) +
  #geom_boxplot() +
  geom_point(data = medians, aes(x = Value, y = Type), color = "black", shape = 16, size = 3) +
  geom_text(data = medians, aes(x = Value, y = Type, label = round(Value, 2)),
            hjust = -0.9, color = "black") +  # Adjust hjust for text placement
  labs(title = "Boxplot - Views & Downloads", x = "Values", y = NULL) +  # Swap x and y labels
  scale_y_discrete(labels = c("Downloads", "Views")) +  # Adjust y-axis labels
  coord_cartesian(xlim = c(0, max(upper_whiskers$Value))) +  # Set x-axis limits
  theme_minimal() +
  theme(axis.text.y = element_text(size = 11))  # Adjust the font size and style for y-axis

p_bp_gg_flipped


#Create a Scatterplot:
p_scatter <- ggplot(data, aes(x = Views, y = Downloads)) +
  geom_point() +
  labs(title = "Scatterplot of Views vs Downloads", x = "Views", y = "Downloads") +
  geom_abline(intercept = 0, slope = 1, color = "grey", linetype = "dashed") +
  xlim(0, max(data$Views)) +
  ylim(0, max(data$Downloads)) +
  theme_minimal()+
  annotate("text", x = min(data$Views), y = max(data$Downloads),
           label = paste("Total Views:", TotalViews, "\nTotal Downloads:", TotalDownloads),
           color = "black", hjust = 0, vjust = 1,size = 3.5, fontface = "bold")
p_scatter

# Create a kernel density estimate plot for Views
p_views <- ggplot(data, aes(x = Views)) +
  geom_density(fill = "grey", alpha = 0.3) +
  labs(title = "Probability Density Distribution of Views", x = "Views", y = "Density") +
  geom_vline(xintercept = density(data$Views)$x[which.max(density(data$Views)$y)], color = "black", linetype = "dashed") +
  geom_text(aes(x = density(data$Views)$x[which.max(density(data$Views)$y)] + 5,
                y = median(density(data$Views)$y)+0.002,  # Calculate middle y-coordinate
                label = round(density(data$Views)$x[which.max(density(data$Views)$y)], 0)),
            hjust = 0, vjust = 0.5, color = "black") +  # Adjust positioning
  coord_cartesian(xlim = c(0, max(data$Views)), ylim = c(0, NA)) +
  theme(plot.background = element_rect(fill = "white"))+
  theme_minimal() 

p_views

# Create  histogram plot for Views
Views<-data$Views
p_h_views <- ggplot(data, aes(x = Views)) +
  geom_histogram(binwidth = 20, color = "black", fill = "grey", alpha = 0.7) +
  labs(title = "Histogram of Views", x = "Views", y = "Frequency") +
  scale_x_continuous(limits = c(0, max(Views))) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal()

p_h_views

# Create  histogram plot for Downloads
Downloads<-data$Downloads
p_h_Downloads <- ggplot(data, aes(x = Downloads)) +
  geom_histogram(binwidth = 20, color = "black", fill = "grey", alpha = 0.7) +
  labs(title = "Histogram of Views", x = "Views", y = "Frequency") +
  scale_x_continuous(limits = c(0, max(Downloads))) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal()

p_h_Downloads



# Create a kernel density estimate plot for Downloads
p_downloads <- ggplot(data, aes(x = Downloads)) +
  geom_density(fill = "grey", alpha = 0.3) +
  labs(title = "Probability Density Distribution of Downloads", x = "Downloads", y = "Density") +
  geom_vline(xintercept = density(data$Downloads)$x[which.max(density(data$Downloads)$y)], color = "black", linetype = "dashed") +
  geom_text(aes(x = density(data$Downloads)$x[which.max(density(data$Downloads)$y)] + 5,
                y = median(density(data$Downloads)$y)+0.002,  # Calculate middle y-coordinate
                label = round(density(data$Downloads)$x[which.max(density(data$Downloads)$y)], 0)),
            hjust = 0, vjust = 0.5, color = "black") +  # Adjust positioning
  coord_cartesian(xlim = c(0, max(data$Downloads)), ylim = c(0, NA)) +
  theme(plot.background = element_rect(fill = "white"))+
  theme_minimal()

p_downloads

#### CUMULATIV EPLOT
# Set the locale to English (to set dates in the cumsum plot to English)
Sys.setlocale("LC_TIME", "en_UK.UTF-8")

df_recordXdate <- df_unique %>% select(url, title, creator, datestamp) %>%
  mutate(month = format(as.Date(datestamp), "%Y-%m")) %>%
  group_by(month) %>%
  summarize(count = n())


df_recordXdate <- df_recordXdate %>%
  arrange(month) %>%
  mutate(cumulative_count = cumsum(count))

# Cumulative plot
p_cumsum <- ggplot(df_recordXdate, aes(x = as.Date(paste0(month, "-01")), y = cumulative_count,color = cumulative_count)) +
  geom_line("linewidth" = 3) +
  #geom_smooth(color ="red",se = FALSE,linetype = "dashed") +
  xlab("Month") +
  ylab("Cumulative Count") +
  ggtitle("Cumulative Records over Time") +
  theme(panel.background = element_rect(fill = alpha("grey", 0.25)),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month")+
  #scale_x_date(date_labels = format_date_english, date_breaks = "1 month")+
  scale_color_gradient(high = "#000000", low = "#999999")+
  guides(color = "none") # remove the gradient legend


#Arrange plots in a grid layout with custom column spans
grid.arrange(
  p_downloads,p_views, 
  p_scatter, p_bp_gg_flipped,
  p_cumsum, ncol = 2,
  layout_matrix = rbind(c(1, 2), c(3, 4), c(5, 5))
)

# To revert locale to the original OS language
Sys.setlocale("LC_TIME", "German.UTF-8") # Windows OS

