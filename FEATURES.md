# Features

## Use Cases

1. First time: User opens app for the first time and wants to add her collection.
2. Add book: User purchases one or more issues of a series and wants to add them to her collection.
3. Track series: Users might not own any issues of a series but want to start tracking series in the app.
4. Update book: User sells an issue or wants to add a more details about an issue to the app.

## Views

 Book Binder has three views: Detail, Timeline, and Summary. These views enable
 users to manage their collections at the book and series level as well as well
 as a chronological feed or a ordered list.

## Detail View

 Detail view enable the user to manage their books. Detail view is a sub-view of
 either the Timeline or Summary Views. The Detail View displays one book at a
 time and enables navigation between books of the same series.

### Book Object

 A book is a collectable object (it could be a magazine, comic book, novel,
 audio recording, album, DVD, etc...).

#### Book Properties and Actions

References

* <https://schema.org/CreativeWork> and specific types
* <https://schema.org/SocialMediaPosting> and specific types
* <https://schema.org/ItemList> and specific types
* <https://schema.org/Product> and specific types

* Identity
  * Title
  * Authors
  * Editors/Directors
  * Publishers/Producers
  * Distributors
  * Series
  * Unique ID (Library of Congress?)
  * Genres (general, comedy, drama, dramedy, fiction, non-fiction, science
    fiction, documentary)
  * Kind (book, movie, comic, magazine, journal, etc.)
  * Media Format (paper back, hard cover, CD, DVD, VHS, Blu-ray 4K HRD, etc.)
  * Photo
  * License (copyright, creative commons, open source, etc.)

* Dates
  * Date Published
  * Date Acquired
  * Dates Consumed
  * Dates updated

* Links
  * Previous Book
  * Next Book
  * Copies

* Commentary
  * Review
  * Reaction (love, hate, it's complicated)
  * Rating (0 to 4 stars)#### Book Actions

* Actions
  * Add
  * Update
  * Purchase
  * Rent
  * Consume
  * Delete
  * Duplicate
  * Share

## Timeline View

 The Timeline View is a chronological feed of Book Events based on update
 property dates. A Book Event can appear multiple times in the Timeline as it is
 added, updated, consumed, shared, or deleted. If these actions happen
 immediately one after the other then Book Events are aggregated so that the
 Timeline is not cluttered with duplicates. From the Timeline a user can
 navigate to either a series or a book (Summary or Detail Views).

### Book Event

 A Book Event is an record in the user's timeline of an action related to a book
 object. For example, an addition, update, purchase, deletion, or share of a
 book. Book Events are recorded based on the date of the action, the type of
 action, and its proximity to actions related to the same book object.

#### Book Event Properties and Actions

* Identity
  * Unique ID
  * Title
  * Kind
  * List of Book IDs (associate with event)
  * Index Value (location in Timeline)
  * Visible Flag

* Actions
  * Edit Visibility
  * Go to Book(s)
  * Go to Series
  * Share

## Summary View

The Summary View is a list of series that shows which books are collected and
missing. For example if the user is collecting Water Bottle Hero, which is a
series of 10 comic books. Summary view shows which issues are owned and
which issues are unowned. For series with more than ten issues Summary View
can be configured to show only a range of issues (such as the last 10).

Summary View enables the user to quick add the next issue to her collection as
well as add any missing issue.

Summary View also enables the user to navigate to a specific book.

### Series Object

A Series Object is a collection of Book Objects that extrapolates missing
books from the current collected books in a series. If there are four novels
in _Cat Wars_ and the user has read books one and and four, the Series Object
that represents _Cat Wars_ will infer that books two and three are missing.

A Series Object always assumes that a sequel, an additional issue, could be
published, and make is easy for the user to add that issue with a single
touch.

#### Series Object Properties and Actions

* Identity
  * Unique ID
  * Title
  * Kind
  * List of Collected Book IDs (associated with series)
  * List of Missing Book Index Numbers
  * Visible Flag

* Actions
  * Edit Visibility
  * Go to Collected Book
  * Add Missing Book
  * Add Next Book
  
## Serialization
  
### JSON Representation
  
Minimum about if info that needs to be serialized in JSON for a factory to create series, books, and URIs.

```javascript

{
    "series":
    [
        {
            "seriesPublisher": "",
            "seriesTitle": "",
            "seriesEra": 0,
            "seriesVolume": 1,
            "seriesFirstIssue": 0,
            "seriesCurrentIssue": 0,
            "seriesSkippedIssues":0,
            "seriesExtraIssues":0,
            "books":
            [
                {
                    "printing": 1,
                    "issueNumber": 0,
                    "variantLetter": "",
                    "isOwned": true
                }
            ]
        }
    ],
    "selectedSeriesIndex": 0,
    "selectedBookIndex": 0
}

```

## Models

### How to integrate issue number, era, and series

Since comic book publishers keep starting over from issue 0, series are grouped into eras by date ranges.
Doctor Strange includes 8 eras. Some times the series have different titles but often they don't. Sometimes
the numbers continue between eras but more often they don't. The 7th series uses a "legacy" numbering
scheme that Marvel may or may not abandon.

Collectors and comic book sellers use a may use a different
definition of series and than the publisher. For example according to Marvel the current series of Daredevil
started in 2015 with issue number 1 and jumped from issue 28 to issue 598 in 2017. Collectors take this jump in
numbering to be the start of a new series (Daredevil 2017).

#### Series for Daredevil

* "Daredevil", 1964, 1-380
* "Daredevil", 1998, 1-119, 500-512
* "Daredevil", 2011, 1-36
* "Daredevil", 2014, 1-18
* "Daredevil", 2015, 1-28
* "Daredevil", 2017, 598-?

#### Series for Doctor Strange

* "Strange Tales", 1951, 1-168
* "Doctor Strange", 1968, 169-183
* "Doctor Strange", 1974,  1-81
* "Doctor Strange, Sorcerer Supreme", 1988, 1-90
* "Doctor Strange", 2015, 1-26
* "Doctor Strange, and the Sorcerers Supreme", 2016, 1-12
* "Doctor Strange", 2017, 381-390
* "Doctor Strange", 2018, 1-?

#### Possible URIs for each series

/Marvel Comics Group/Strange Tales/1961/168

Sources

* <http://www.comichron.com/faq/legacynumberingatmarvel.html>
* <https://www.mycomicshop.com>
