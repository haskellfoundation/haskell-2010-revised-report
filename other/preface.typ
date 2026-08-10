#import "../macros.typ" : *

#quote(attribution: [Haskell B. Curry and Robert Feys\
in the Preface to _Combinatory Logic_ @CurryFeys1958, May 31, 1956], block: true)[
  _Some half dozen persons have written technically on combinatory logic, and most of these,
  including ourselves, have published something erroneous. Since some of our fellow sinners are
  among the most careful and competent logicians on the contemporary scene, we regard this as
  evidence that the subject is refractory. Thus fullness of exposition is necessary for accuracy; and
  excessive condensation would be false economy here, even more than it is ordinarily._
]

In September of 1987 a meeting was held at the conference on Functional Programming Languages and Computer Architecture (FPCA ’87) in Portland, Oregon, to discuss an unfortunate situation in the functional programming community: there had come into being more than a dozen non-strict, purely functional programming languages, all similar in expressive power and semantic underpinnings. There was a strong consensus at this meeting that more widespread use of this class of functional languages was being hampered by the lack of a common language. It was decided that a committee should be formed to design such a language, providing faster communication of new ideas, a stable foundation for real applications development, and a vehicle through which others would be encouraged to use functional languages. This document describes the result of that (and subsequent) committee’s efforts: a purely functional programming language called Haskell, named after the logician Haskell B. Curry whose work provides the logical basis for much of ours.

#heading(level: 3, numbering: none)[Goals]

The committee's primary goal was to design a language that satisfied these constraints:

+ It should be suitable for teaching, research, and applications, including building large systems.
+ It should be completely described via the publication of a formal syntax and semantics.
+ It should be freely available. Anyone should be permitted to implement the language and distribute it to whomever they please.
+ It should be based on ideas that enjoy a wide consensus.
+ It should reduce unnecessary diversity in functional programming languages.

#heading(level: 3, numbering: none)[Haskell 2010: language and libraries]

The committee intended that Haskell would serve as a basis for future research in language design, and hoped that extensions or variants of the language would appear, incorporating experimental features.

Haskell has indeed evolved continuously since its original publication. By the middle of 1997, there had been five versions of the language design (from Haskell 1.0 - 1.4). At the 1997 Haskell Workshop in Amsterdam, it was decided that a stable variant of Haskell was needed; this became "Haskell 98" and was published in February 1999. The fixing of minor bugs led to the _Revised_ Haskell 98 Report in 2002.

At the 2005 Haskell Workshop, the consensus was that so many extensions to the official language were widely used (and supported by multiple implementations), that it was worthwhile to define another iteration of the language standard, essentially to codify (and legitimise) the status quo.

The Haskell Prime effort was thus conceived as a relatively conservative extension of Haskell 98, taking on board new features only where they were well understood and widely agreed upon. It too was intended to be a "stable" language, yet reflecting the considerable progress in research on language design in recent years.

After several years exploring the design space, it was decided that a single monolithic revision of the language was too large a task, and the best way to make progress was to evolve the language in small incremental steps, each revision integrating only a small number of well-understood extensions and changes. Haskell 2010 is the first revision to be created in this way, and new revisions are expected once per year.

#heading(level: 3, numbering: none)[Extensions to Haskell 98]

The most significant language changes in Haskell 2010 relative to Haskell 98 are listed here.

New language features:

- A Foreign Function Interface (FFI).
- Hierarchical module names, e.g. `Data.Bool`.
- Pattern guards.

Removed language features:

- The $(n + k)$ pattern syntax.

#heading(level: 3, numbering: none)[Haskell Resources]

The Haskell web site #link("http://haskell.org")[http://haskell.org] gives access to many useful resources, including:

- Online versions of the language and library definitions.
- Tutorial material on Haskell.
- Details of the Haskell mailing list.
- Implementations of Haskell.
- Contributed Haskell tools and libraries.
- Applications of Haskell.
- User-contributed wiki pages.
- News and events in the Haskell community.

You are welcome to comment on, suggest improvements to, and criticise
the language or its presentation in the report, via the Haskell
mailing list, or the Haskell wiki.

#heading(level: 3, numbering: none)[Building the language]

Haskell was created, and continues to be sustained, by an active
community of researchers and application programmers.  Those who
served on the Language and Library committees, in particular, devoted
a huge amount of time and energy to the language.  Here they are, with
their affiliation(s) for the relevant period:

#center-box[
Arvind (MIT) \
Lennart Augustsson (Chalmers University) \
Dave Barton (Mitre Corp) \
Brian Boutel (Victoria University of Wellington) \
Warren Burton (Simon Fraser University) \
Manuel M T Chakravarty (University of New South Wales) \
Duncan Coutts (Well-Typed LLP) \
Jon Fairbairn (University of Cambridge) \
Joseph Fasel (Los Alamos National Laboratory) \
John Goerzen \
Andy Gordon (University of Cambridge) \
Maria Guzman (Yale University) \
Kevin Hammond [editor] (University of Glasgow) \
Bastiaan Heeren (Utrecht University) \
Ralf Hinze (University of Bonn) \
Paul Hudak [editor] (Yale University) \
John Hughes [editor] (University of Glasgow; Chalmers University) \
Thomas Johnsson (Chalmers University) \
Isaac Jones (Galois, inc.) \
Mark Jones (Yale University, University of Nottingham, Oregon Graduate Institute) \
Dick Kieburtz (Oregon Graduate Institute) \
John Launchbury (University of Glasgow; Oregon Graduate Institute; Galois, inc.) \
Andres Löh (Utrecht University) \
Ian Lynagh (Well-Typed LLP) \
Simon Marlow [editor] (Microsoft Research) \
John Meacham \
Erik Meijer (Utrecht University) \
Ravi Nanavati (Bluespec, inc.) \
Rishiyur Nikhil (MIT) \
Henrik Nilsson (University of Nottingham) \
Ross Paterson (City University, London) \
John Peterson [editor] (Yale University) \
Simon Peyton Jones [editor] (University of Glasgow; Microsoft Research Ltd) \
Mike Reeve (Imperial College) \
Alastair Reid (University of Glasgow) \
Colin Runciman (University of York) \
Don Stewart (Galois, inc.) \
Martin Sulzmann (Informatik Consulting Systems AG) \
Audrey Tang \
Simon Thompson (University of Kent) \
Philip Wadler [editor] (University of Glasgow) \
Malcolm Wallace (University of York) \
Stephanie Weirich (University of Pennsylvania) \
David Wise (Indiana University) \
Jonathan Young (Yale University)
]

Those marked [editor] served as the co-ordinating editor for one or more
revisions of the language.

In addition, dozens of other people made helpful contributions, some small but
many substantial.  They are as follows:
Hans Aberg,
Kris Aerts,
Sten Anderson,
Richard Bird,
Tom Blenko,
Stephen Blott,
Duke Briscoe,
Paul Callaghan,
Magnus Carlsson,
Mark Carroll,
Franklin Chen,
Olaf Chitil,
Chris Clack,
Guy Cousineau,
Tony Davie,
Craig Dickson,
Chris Dornan,
Laura Dutton,
Chris Fasel,
Pat Fasel, 
Sigbjorn Finne,
Michael Fryers,
Peter Gammie,
Andy Gill, 
Mike Gunter,
Cordy Hall,
Mark Hall,
Thomas Hallgren,
Matt Harden,
Klemens Hemm,
Fergus Henderson,
Dean Herington,
Bob Hiromoto,
Nic Holt,
Ian Holyer, 
Randy Hudson,
Alexander Jacobson,
Patrik Jansson,
Robert Jeschofnik,
Orjan Johansen,
Simon B.~Jones, 
Stef Joosten, 
Mike Joy,
Wolfram Kahl,
Stefan Kahrs,
Antti-Juhani Kaijanaho,
Jerzy Karczmarczuk,
Kent Karlsson,
Martin D. Kealey,
Richard Kelsey,
Siau-Cheng Khoo, 
Amir Kishon, 
Feliks Kluzniak,
Jan Kort,
Marcin Kowalczyk,
Jose Labra,
Jeff Lewis,
Mark Lillibridge,
Björn Lisper,
Sandra Loosemore,
Pablo Lopez,
Olaf Lubeck, 
Christian Maeder,
Ketil Malde,
Michael Marte,
Jim Mattson,
John Meacham,
Sergey Mechveliani,
Gary Memovich,
Randy Michelsen, 
Rick Mohr,
Andy Moran,
Graeme Moss,
Arthur Norman,
Nick North,
Chris Okasaki,
Bjarte M. Østvold,
Paul Otto, 
Sven Panne,
Dave Parrott,
Larne Pekowsky,
Rinus Plasmeijer,
Ian Poole,
Stephen Price,
John Robson, 
Andreas Rossberg,
George Russell,
Patrick Sansom,
Michael Schneider,
Felix Schroeter,
Julian Seward,
Nimish Shah,
Christian Sievers,
Libor Skarvada,
Jan Skibinski,
Lauren Smith, 
Raman Sundaresh,
Josef Svenningsson,
Ken Takusagawa,
Wolfgang Thaller,
Satish Thatte,
Tom Thomson,
Tommy Thorn,
Dylan Thurston,
Mike Thyer,
Mark Tullsen,
David Tweed,
Pradeep Varma,
Keith Wansbrough,
Tony Warnock,
Michael Webber,
Carl Witty,
Stuart Wray,
and Bonnie Yantis.

Finally, aside from the important foundational work laid by Church,
Rosser, Curry, and others on the lambda calculus, it is right to
acknowledge the influence of many noteworthy programming languages
developed over the years.  Although it is difficult to pinpoint the
origin of many ideas, the following languages were particularly influential:
Lisp (and its modern-day incarnations Common Lisp and
Scheme); Landin's ISWIM; APL; Backus's FP
@Backus1978; ML and Standard ML; Hope and Hope⁺; Clean; Id; Gofer;
Sisal; and Turner's series of languages culminating in 
Miranda #footnote("Miranda is a trademark of Research Software Ltd."). Without these forerunners Haskell would not have
been possible.

#context {if target() == "paged" {
  v(1in)
  }
}

Simon Marlow \
Cambridge, April 2010