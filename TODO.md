#  TODO

## Use Cases

1. First time: User opens app for the first time and wants to add her collection.
2. Add book: User purchases one or more issues of a series and wants to add them to her collection.
3. Track series: Users might no own any issues of a series but want to start tracking series in the app.
4. Update book: User sells an issue or wants to add a more details about an issue to the app.

## Serialization

### JSON Representation

Minimum about if info that needs to be serilized in JSON for a factory to create series, books, and URIs.

```
[
    {
        "seriesPublisher": "",
        "seriesTitle": "",
        "seriesEra": "",
        "firstIssue": "",
        "currentIssue": "",
        "books": 
        [
            {
                "issueNumber": "",
                "variantLetter": "",
                "isOwned": ""
            }
        ]
    }
]
```

## Models

### How to integrate issue number, era, and series?

Since comic book publishers keep starting over from issue 0, series are grouped into eras by date ranges. 
Doctor Strange includes 8 eras. Some times the series have different titles but often they don't. Sometimes 
the numbers continue between eras but more often they don't. The 7th series uses a "legacy" numbering 
scheme that Marvel may or may not abondon. 

Collectors and comic book sellers use a may use a different
definition of series and than the publisher. For example according to Marvel the current series of Daredevil
started in 2015 with issue number 1 and jumped from issue 28 to issue 598 in 2017. Collectors take this jump in
numbering to be the start of a new series (Daredevil 2017).

#### Series for Daredevil

- "Daredevil", 1964, 1-380
- "Daredevil", 1998, 1-119, 500-512
- "Daredevil", 2011, 1-36
- "Daredevil", 2014, 1-18
- "Daredevil", 2015, 1-28
- "Daredevil", 2017, 598-?

#### Series for Doctor Strange

- "Strange Tales", 1951, 1-168
- "Doctor Strange", 1968, 169-183
- "Doctor Strange", 1974,  1-81
- "Doctor Strange, Sorcerer Supreme", 1988, 1-90
- "Doctor Strange", 2015, 1-26
- "Doctor Strange, and the Sorcerers Supreme", 2016, 1-12
- "Doctor Strange", 2017, 381-390
- "Doctor Strange", 2018, 1-?

#### Possible URIs for each series

/Marvel Comics Group/Strange Tales/1961/168

Sources

- <http://www.comichron.com/faq/legacynumberingatmarvel.html>
- <https://www.mycomicshop.com>
