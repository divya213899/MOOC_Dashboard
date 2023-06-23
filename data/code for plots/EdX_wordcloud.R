library("tm")
library("wordcloud")
library("RColorBrewer")

edx= read.csv("edX_Course.csv")
text = edx$Title
docs = Corpus(VectorSource(text))

toSpace = content_transformer(function (x, pattern) gsub(pattern, " ", x))
docs1 = tm_map(docs, toSpace, "/")
docs1 = tm_map(docs, toSpace, "@")
docs1 = tm_map(docs, toSpace, "#")
docs1 = tm_map(docs1, content_transformer(tolower))
docs1 = tm_map(docs1, removeNumbers)
docs1 = tm_map(docs1, stripWhitespace)

dtm = TermDocumentMatrix(docs1)
m = as.matrix(dtm)
v = sort(rowSums(m), decreasing = TRUE)
d = data.frame(word = names(v), freq = v)


# setting the frequenices of certain words like "and", "for", "the", "introduction" to 0
d[1,2]=0; d[2,2]=0; d[3,2]=0; d[4,2]=0; d[6,2]=0

wordcloud(words = d$word, 
          freq = d$freq,
          min.freq = 1, 
          max.words = 400,
          random.order = FALSE, 
          rot.per = 0.2, 
          colors = brewer.pal(2, "Set1"))
