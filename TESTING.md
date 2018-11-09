#  Testing

## ComicBookDictionary

## Defnitions

- Section: A combination of publisher, series, and volume
- Item: A combinatins of work and variant

### Sample1.json Data
```
key [0, 0] value [Marble Entertainment The People Under The Chair 1950 #1]
key [0, 1] value [Marble Entertainment The People Under The Chair 1950 #3b]
key [0, 2] value [Marble Entertainment The People Under The Chair 1950 #3c]
key [1, 3] value [Marble Entertainment The People Under The Chair 1960 #1]
key [1, 4] value [Marble Entertainment The People Under The Chair 1960 #1x]
key [1, 5] value [Marble Entertainment The People Under The Chair 1960 #4]
key [1, 6] value [Marble Entertainment The People Under The Chair 1960 #8n]
key [2, 0] value [Marble Entertainment Eternal Bells 1970 #1]
key [2, 1] value [Marble Entertainment Eternal Bells 1970 #2]
key [2, 2] value [Marble Entertainment Eternal Bells 1970 #5]
key [2, 3] value [Marble Entertainment Eternal Bells 1970 #5a]
key [2, 4] value [Marble Entertainment Eternal Bells 1970 #5c]
key [3, 0] value [Eek Comics The Human Animal 2010 #1]
```
### Analysis
- 4 sections: 0, 1, 2, 3
- 13 total items
- 3 items in section 0
- 4 items in section 1
- 5 item in section 2
- 1 item in section 3
- section 0 = pub 0 + ser 0 + vol 0
- section 1 = pub 0 + ser 0 + vol 1
- section 2 = pub 0 + ser 1 + vol 0
- section 3 = pub 2 + ser 0 + vol 0

### Keys
```
[[0, 0], [0, 1], [0, 2], [1, 3], [1, 4], [1, 5], [1, 6], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [3, 0]]
```



