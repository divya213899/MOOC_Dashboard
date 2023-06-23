library("tm")
library("wordcloud")
library("RColorBrewer")


dat = read.csv("courses.csv")

text = dat$Name
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
for(i in 1:3){
  d[i,2]=0
}
d[5,2]=0

wordcloud(words = d$word, 
          freq = d$freq,
          min.freq = 1, 
          max.words = Inf,
          random.order = FALSE, 
          rot.per = 0.2, 
          colors = brewer.pal(2, "Set3"))

## P.S. I forgot to set the seed
##I don't remember the colour combination that produced the Wordcloud


