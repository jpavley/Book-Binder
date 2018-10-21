# Book Binder Architecture

## Objects

![Book Binder Class Diagram](book-binder-class-diagram.png)

A binder represents a collection of works: comic books, baseball cards,
DVDs, paperback novels, etc.... Related works are organized into series.

A series represents a set of associated works: books in a trilogy, a set of
movie sequels, or issues of a comic book. Series are sometimes published in 
volumes or sets of related issues.

A work represents a published work of art. Works are published in a series
with a first issue, multiple following issues, and a current or final issue.
Works are sometimes reprinted with minor variations, for example, corrected
text, or major variations, for example an alternate cover.

In general publishing works of art is a messy, semi-organized process. Not all
works are numbered sequentially or published in order. Issues numbers are
skipped or extra issues are inserted. Sometimes issues are not numbered and
there is no simple method to identify the location of an work in a series.

Therefore the Book Binder model is going to change and we try to fit the
messy world of publishing into a well ordered system.

In an effort to model the mess we provide both a predefined hierarchy of works
and a open system of tags. Thus a movie maybe published on VHS Tape and DVD
and also be a director's cut. Tags should be used for editions of a work
while the works hierarchy should used for media types. Since media technology
changes more slowly than editorial formats (editions) we should be able to
keep up with the pace of technology changes.

## Shared Properties

Each object in the Book Binder app has a URI. A full URI describes the
address of a work in the predefined hierarchy of works.

Each object in the Book Binder app has a list of tags. Tag should be used to
associate works across the hierarchy such as language or corrected edition.