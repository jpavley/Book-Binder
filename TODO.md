#  TODO

## Open

- Need a detail view for series as well as books. So now we're
looking at a four or five view app as we'll want to separate capture from
Book Object Detail View as well. Capture view enables shooting a photo to
add a book to a collection. Capturing may create or extend a Series Object
and well as alway create a Book Event. The new list of views are: Capture,
Book Detail, Timeline, Summary, and Series Overview.

- Include the price paid and the estimated current value of a collected
book. Update Detail and Summary Views to report on costs and value. This
points to the need for an overview of the collection which could include it's
total count, cost, and value.

- Object architecture/design is complied. BookBinder, Comicbook, and JsonModel are all similar and tightly
coupled to the idea of collecting comic books. Need to use protocols and make sure the book binder
does care about what type of "book" it is binding: Comicbook, Novel, 4K Ultra HD Blue-Ray, etc...

- New user use case: Start with popular collections? Start blank?

- Placeholder comicbook covers only look good on iPhone SE! Sad!

- Really need a web backend for this app. Giant database of comicbooks in the sky with only
part of a user's collection stored locally. 

- Investigate http://www.coverbrowser.com Can I use these covers?

- Implement camera in detail view to take or use a photo of a comic book cover.
- Implement delete in detail view to remove a book from a series.
- Implement add in detail view to add a book to a series.
- Implement series view to view and edit a series.
- Implement add in summary view to add a book to a series.
- Implement add series action in summary view.
- Add volume property to book model
- Add issue type to book model (regular, annual, special)
- Make skipped issues and extra issues lists
- Implement comicbook variant as an object as a collection belonging to work. A variant has a letter and a
cover image.

## In progress


## Closed
- Rename ViewController to SummaryViewController.
- Remove edit mode management from summary view.
- Enable swiping between books in detail view.
- Enable swiping up and down between series in detail view.
- Hide toolbar when returning from detail view to summary view.
- URI now need to include slashes of missing parts: "publisher/title/era///" is the 
new series URI because of this. Probably need a series URI compare method so that
"publisher/title/era" is the same as "publisher/title/era///".
- To create a BookBinder from a list of book URIs I need to encode the first and current issues. But
there isn't much of a good reason for a book URI to carry that info around as it changes every time
a new issue is published. In a large collection all the book URIs will need to be updated when 
a new issue is published which means book URIs are not stateless. In fact I should take the ownership
field out of the the book URI as that is state that can easily change as well! A book URI at this point
sould look like this "Publisher/Title/Era/Issue Number/Varient Letter". (Which was were I started!)
- When returning to summary view from detail view the changes to a book should persist. Also all issues 
(owned and unowned) should be in the books array and the books array should be a books dictionary with
the book URI as the key!
- Create a placeholder comic book cover for each of the major publishers plus an indy cover.
- Implement saving and loading the current book binder
- write missing unit tests!
- Update classes to match architecture









