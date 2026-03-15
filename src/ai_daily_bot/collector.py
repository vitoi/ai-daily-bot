import feedparser

def collect(url):
    feed = feedparser.parse(url)
    for e in feed.entries[:5]:
        print(e.title)
