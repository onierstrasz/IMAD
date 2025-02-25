# IMAD

## Overview

“IMAD” stands for “Interactive Modeling for Agile Development.”

In this project, we are exploring “interactive modeling” as a paradigm for iteratively producing executable models of application domain concepts, scenarios and requirements within an agile development process. 
We are developing a prototype of an interactive tool to specify and describe domain entities.
We are also developing an approach to incrementally attribute behaviour to these entities in concrete scenarios. 

We also plan to explore how such executable models can then be exploited to support testing, analysis and live documentation of the evolving software project.

This work is being carried out in the context of the SNSF project [Agile Software Assistance](http://scg.unibe.ch/staff/oscar) (#200020-181973), and in particular the second track of this project on Executable domain models.

See the [IMAD Project Board](https://github.com/onierstrasz/IMAD/projects/1) for ongoing tasks

## How to load IMAD

First download the latest version of [Glamorous Toolkit](https://gtoolkit.com/download/) from [feenk](https://feenk.com).
Then within a GT Playground, execute the following snippet to load this repository:

```
Metacello new
   baseline: 'IMAD';
   repository: 'github://onierstrasz/IMAD/src';
   load.
#BaselineOfIMAD asClass loadLepiter
```

## Hypernode graphs

This is a reimplementation of the Card Decks described below.
See the Hypernodes package for a prototype of an interactive editor of nested hypernode graphs.

## Domain modeling Card Decks (IMAD-Cards)

Interactive modeling of domain concepts using decks of cards.

Example of using a deck of cards, where each card represents a domain concept for the Faculty Doodle domain.

Inspect: 
- `CardDeckExamples new facultyDoodleDomain `
- `CardDeck new`

Other stuff:

- `CardDeckTestExamples` — test functionality of Cards and Decks
- `CardRelationFilterTestExamples` — test functionality of filters
- `UsefulExamples` — technical examples showing how to solve various GT tasks

## Related stuff

- FSA (IMAD-FSA): Experiments to see how to model FSAs and Petri Nets with Mondrian.
  - Inspect: `FSAExamples`

- Executable Graph Models (IMAD-EGM): Seminar Project by Louis Müller. An interactive graph editor building on the FSA project.
  - Inspect the following in the Morphic window: `Graph new`
