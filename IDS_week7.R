getwd()

#installing the text mining and snowball packages for preprocessing

install.packages('tm')
install.packages('SnowballC')
install.packages('glmnet')

library(tm)
library(glmnet)

#Setting up the 20NewsGroups data

#consist of posts made on web forums in the early 2000s, separated into 20 topics


#--------USING THE TM LIBRARY TO WORK WITH TEXT FILES------------------#

#DirSource class reiterates over the files in a directory
#Corpus class takes a list of text files and reads them into R objects

#Loading into one folder of documents
topic_docs <- Corpus(
  DirSource(
    '20news-train/comp.graphics',
    encoding = 'UTF-8' #specifies the text encoding the files are saved with
  ))

summary(topic_docs[1:5])

#to inspect a single document we can use inspect() function. To get a single
#document, you use double brackets
inspect(topic_docs[[1]])

#this document has 2 properties : metadata and content ; we'll be ignoring metadata in this worksheet
topic_docs[[1]]$content


#Setting up for binomial classification (between two categories)
#now we'll load  rec.motorcycles

topic_2_docs <- Corpus(
  DirSource(
    '20news-train/rec.motorcycles',
    encoding = 'UTF-8' #specifying the text encoding the files are saved with
  )
)

#to work with the two topics we need to do 2 things:
# 1) combine them into a single list of all the documents from both topics 
binomial_docs <- c(
  as.list(topic_docs),
  as.list(topic_2_docs) #converting the Corpus to a list to combine them properly
)
 # 2) Create a seperate list of the topic labels for the two
labels_1 <- replicate(length(topic_docs), 'comp.graphics')
labels_2 <- replicate(length(topic_2_docs), 'rec.motorcycles')
binomial_labels <- c(labels_1, labels_2)

#not saving it into binomial_docs as it is not a data frame at this point
length(binomial_docs) == length(binomial_labels)



#------------------PREPROCESSING TEXT DATA------------------------#
#we'll want to do preprocessing to clean up different sources of noise in the data
#comp.graphics : post 38487

example_doc <- binomial_docs[['38487']]
print(example_doc)

#Tokenisation : breaking up documents into sequences of tokens(words and punctuation)
tokens <- Boost_tokenizer(example_doc)
summary(tokens)
print(tokens)

#EXERCISE : try using MC_tokenizer on the example document and obs the differences
tokens2 <- MC_tokenizer(example_doc)
summary(tokens2)
print(tokens2)
#MC_tokenizer ignores all the punctuation and also breaks up word after every punctuation 


#Removing punctutation: tm has a removePunctuation() method to do this
removePunctuation(example_doc)
#can be applied on the document itself ^^ or on a list of tokens : 
removePunctuation(tokens)


#Removing Stopwords : they are common words that don't contribute to the meaning of a 
#document, tm has a built-in list of english stopwords

stops <- stopwords('en')
?stopwords
print(stops)

#you can remove these words from a document using removeWords() method :
removeWords(example_doc, stops)
#NOTE : R missed to remove the stopword : I'll


#Lowercasing : removing capitalisation : tolower()
tolower(example_doc)
#removing Stop words after lowercasing
removeWords( tolower(example_doc), stops )


#EXERCISE: stopword removal on the list of tokens. 
removeWords(tokens2, stops)

#after lowercasing
removeWords( tolower(tokens2), stops)
#order of pre-processing operations : tokenization > remove punctuation > lowercasing > remove stop words

#WORD STEMMING : is removing grammar markers from words (energising vs energise
#stemDocument() 
stemDocument(
  example_doc
)


#--------------APPLYING PREPROCESSING METHODS TO MULTIPLE DOCUMENTS-------------

#tm library has a tm_map method which allows you to apply a 
#function to every document in Corpus

#so first we convert our combined list of documents back into Corpus, 
#we can do it using vectorSource command
binomial_docs <- Corpus(
  
  VectorSource(binomial_docs)
)

binomial_docs

#now we can use tm_map to process the documents : 
cleaned_binomial_docs <- tm_map(
  binomial_docs,  #the collection of documents to process
  removeWords,    # the function to apply to each document
  stopwords('en')  #any additional arguments to pass to the function being called
  )

#we can use this, then, to create a fully preprocesses copy of all out documents : 

#lowercasing 
cleaned_binomial_docs <- tm_map(
  binomial_docs,
  tolower
)

#to remove punctuation 
cleaned_binomial_docs <- tm_map(
 cleaned_binomial_docs,  #we want to stack on top of the previous preprocessing
  removePunctuation
)

#to remove stopwords
cleaned_binomial_docs <- tm_map(
  cleaned_binomial_docs,
  removeWords,
  stopwords('en')
)

#Finally, stemming 
cleaned_binomial_docs <- tm_map(
  cleaned_binomial_docs,
  stemDocument
)

#order of preprocessing : 
# 1) Lowercasing
# 2) Remove Punctuation 
# 3) Remove Stopwords
# 4) Stemming


#--------------TEXT VECTORISATION : BAG OF WORDS ---------------------#

#ti plug text documents into data mining methods we need to convert unstructured
#text into structured numeric features for each sample
# Vectorisation : one of the most common ways to vectorise text is in terms
# of counts of the unique words that appear in it

#tm has a DocumentTermMatric method we can call to compute this : 
binomial_dtm <- DocumentTermMatrix(
  cleaned_binomial_docs
)

binomial_dtm
#Documents: 1182 ; Unique Words: 16953 ; 
#out of 19947190 entries in the matrix only 91256 are non-zero (0.45%)

?DocumentTermMatrix


#EXERCISE : Calculate document text matrix for non-processed version of 
#binomial document set and compare 

DocumentTermMatrix(
  binomial_docs
)
#Documents: 1182; Unique Words: 35879 
#Out of 42276442 entries in the matrix, 132536 are non-zero (0.31%)
#the un-processed docs have more than twice the amount of unique words, 
#a lot more words do not appear : only 0.31% appeared compared to 0.45% for 
#processed data : so I think this matrix is more sparse which would it harder
#to classify, a lot more memory usage as well



#WORD WEIGHTING STRATEGIES FOR BAG-OF-WORDS
#by fault that DTM calculates are the raw counts i.e., how many times each 
#word appears in each document 

inspect(binomial_dtm[1:3,])

#documents can be of very different lengths 
doc_lengths <- lapply(  #applies a function across each element of a list
  as.list(cleaned_binomial_docs),
  nchar    #count the length of a string
)

doc_lengths <- unlist(doc_lengths) #getting rid of the structure lapply() creates
quantile(doc_lengths)

#75% of our documents are less than 1000 characters in length, but max length is over
#40,000 characters


#BINARY WEIGHTING
#it's an alternative to raw frequencies, 1 means word was present in doc, 0 means it wasn't

#to use binary weighing we add an argument into DocumenTermMatrix like so:
binomial_dtm_binary <- DocumentTermMatrix(
  cleaned_binomial_docs,
  control = list(
    weighting=weightBin
  )
)

inspect(binomial_dtm_binary[1:3,])
#we can see that the values are all binary regardless of how many times the word
#appeared on the counts


#TF-IDF WEIGHTING 
#term frequency Inverse Document Frequency weighting
#TF-IDF is calculated for a specific term in a specific document as : 
  #the frequency of the term in the document (raw count)
  # Divided by the number of documents in the whole dataset where the
  #term occues (ignoring frequency in each document)

#this has the effect of giving a higher weight to words that appear in fewer documents
# i.e., words that are more distinctive for a document get higher weights
binomial_dtm_tfidf <- DocumentTermMatrix(
  cleaned_binomial_docs,
  control = list(
    weighting= weightTfIdf
  )
)

inspect(binomial_dtm_tfidf[1:3, ])


#REMOVING SPARSE TERMS
#tm provides a method to trim out sparse terms
#following command will keep the words in the top 98% of frequencies, removing
#all terms in the bottom 2% of frequencies : 
removeSparseTerms(binomial_dtm, 0.98)

#this created a significant size reduction 

#EXERCISE : experiment with different thresholds for removing sparse terms. 
#What thresholds do you have to use to keep more than 2000 unique words
#how quickly do you get down to less than 10 unique words
#run them on binary or tf-idf matrix and compare

removeSparseTerms(binomial_dtm_tfidf, 0.98) #one unique term less than binomial_dtm
removeSparseTerms(binomial_dtm_binary, 0.98) #same values

#for more than 2000 unique words
removeSparseTerms(binomial_dtm, 0.999) #7220 terms

#less than 10
removeSparseTerms(binomial_dtm, 0.70)  #9 terms



#-------------CLASSIFYING DOCUMENTS WITH BAG-OF-WORDS VECTORS------------------#
#now we're going to use logistic regression model for this application of classifying text documents

#DATA SET UP 
#for classification we need to make sure that the same features 
#are being used fo both training and testing

#start up by pulling the vocabulary extracted from the document-term matrices
observed_vocabulary <- unlist(binomial_dtm$dimnames)

#we'll use this to re-calculate out training set document-term matrix
binomial_train_dtm <- DocumentTermMatrix(
  cleaned_binomial_docs,
  control=list(
    dictionary=observed_vocabulary
  )
)

#We need to make sure our labels are formatted correctly
#Training a binomial model in R required binary labels, we'll reformat our labels
binomial_train_labels <- (
  binomial_labels == 'comp.graphics'
) * 1

#using glmnet() instead of glm() because of sparse data and multiple variables
binomial_model <- glmnet(
  binomial_train_dtm,
  binomial_train_labels,
  family = 'binomial'
)

#we now have a model, we now have to EVALUATE IT, 

#---ASSEMBLING THE TEST SET

topic_1_test_docs <- Corpus(
  DirSource(
    '20news-test/comp.graphics',
    encoding = 'UTF-8'
  )
)

topic_2_test_docs <- Corpus(
  DirSource(
    '20news-test/rec.motorcycles',
    encoding = 'UTF-8'
  )
)

binomial_test_docs <- c(
  as.list(topic_1_test_docs),
  as.list(topic_2_test_docs)
)

binomial_test_docs <- Corpus(
  VectorSource(binomial_test_docs)
)

labels_test_1 <- replicate(length(topic_1_test_docs), 'comp.graphics')
labels_test_2 <- replicate(length(topic_2_test_docs), 'rec.motorcycles')

binomial_test_labels <- c(labels_test_1, labels_test_2)

cleaned_binomial_test_docs <- tm_map(binomial_test_docs, tolower)
cleaned_binomial_test_docs <- tm_map(cleaned_binomial_test_docs, removePunctuation)
cleaned_binomial_test_docs <- tm_map(cleaned_binomial_test_docs, removeWords, stopwords('en'))
cleaned_binomial_test_docs <- tm_map(cleaned_binomial_test_docs, stemDocument)

binomial_test_dtm <- DocumentTermMatrix(
  cleaned_binomial_test_docs,
  control = list(
    dictionary = observed_vocabulary
  )
)

#due to R quirks we have to recast binomial_test_dtm as an explicit matrix for
#the predict() function to work properly
binomial_test_dtm <- data.matrix(binomial_test_dtm)

#usint predict()
binomial_probabilities <- predict(
  binomial_model,
  binomial_test_dtm, 
  s = tail(binomial_model$lambda, 1),
  type = 'response' #gives us probabilities for each label, to convert these into 
  #yes/no decisions, we binarize at 0.5
)

binomial_predictions <- ifelse(
  binomial_probabilities > 0.5, 
  1,
  0
)

#to calculate accuracy of the test set, we need to make sure the test set 
#labels are also formatted correctly as 0 or 1
binomial_test_labels <- (
  binomial_test_labels == 'comp.graphics'
) * 1

binomial_classification_error <- mean(
  binomial_predictions != binomial_test_labels
)
print(paste('Accuracy', 1 - binomial_classification_error ))
#Accuracy : 0.482 : okay but not great