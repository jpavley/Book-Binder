# Features

## Views
Book Binder has three views: Detail, Timeline, and Summary. These views enable users to manage their
collections at the book and series level as well as well as a chronilogical feed or a ordered list.

## Detail View
Detail view enable the user to manage their books. Detail view is a subview of either the Timeline or Summary
Views. The Detail View displays one book at a time and enables navigation between books of the same
series.

### Book Object
A book is a collectable object (it could be a magazine, comic book, novel, audio recording, album, DVD, etc...).

#### Book Properties and Actions

* Identity
    * Title
    * Authors
    * Editors/Directors
    * Publishers/Producers
    * Distributers
    * Series
    * Unique ID (Library of Congress?)
    * Genres (general, comedy, drama, dramedy, fiction, non-fiction, science fiction, documentary)
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

The Timeline View is a chronolical feed of books based on update property dates. A book can appear
multiple times in the Timeline as it is added, updated, consumed, shared, or deleted. If these
actions happen immedialy one after the other then Timeline Objects are aggregated so that the Timeline
is not filled with duplicates. From the Timeline a user can navigate to either a series or a book
(Summary or Detail Views).

### Timeline Object

A Timeline Object is an record in the user's timeline of a event related to a book object. For example,
an addition, update, purchase, deletion, or share. Timeline objects recorded based on the date of the
event, the type of event, and its proxity to events realted to the same book object.
