#  TODO

## Open

- Need to update to include the idea of showing all the books in a Series
Object. This means a detail view for series as well as books. So now we're
looking at a four or five view app as we'll want to separate capture from
Book Object Detail View as well. Capture view enables shooting a photo to
add a book to a collection. Capturing may create or extend a Series Object
and well as alway create a Book Event. The new list of views are: Capture,
Book Detail, Timeline, Summary, and Series Overview.

- Include the price paid and the estimated current value of a collected
book. Update Detail and Summary Views to report on costs and value. This
points to the need for an overview of the collection which could include it's
total count, cost, and value.

- URI now need to include slashes of missing parts: "publisher/title/era///" is the 
new series URI because of this. Probably need a series URI compare method so that
"publisher/title/era" is the same as "publisher/title/era///".

- Models and metaphor confusion: Comicbook, book, and series could potentially 
all refer to the same thing; Book and issue likewise. Probably Comicbook and book
need to go. A book is an "owned" issue of a series and can just be renamed issue. A Comicbook
is an object with that contains a series and a list of associated books.

- Investigate http://www.coverbrowser.com Can I use these covers?

- Hide toolbar when returning from detail view to summary view.
- When returning to summary view from detail view the changed based to a book should persist.
- Implement camera in detail view to take or use a photo of a comic book cover.
- Implement delete in detail view to remove a book from a series.
- Implement add in detail view to add a book to a series.
- Implement series view to view and edit a series.
- Implement add in summary view to add a book to a series.
- Implement add series action in summary view.
- Create a placeholder comic book cover for each of the major publishers plus an indy cover.

## In progress

## Closed
- Rename ViewController to SummaryViewController.
- Remove edit mode management from summary view.
- Enable swiping between books in detail view.
- Enable swiping up and down between series in detail view.


