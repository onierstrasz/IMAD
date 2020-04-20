# IMAD

Experiments using Gt and Mondrian to build executable domain models.

Repo location: git@github.com:onierstrasz/ASA-GtExperiments.git

```
Metacello new
   baseline: 'IMAD';
   repository: 'github://onierstrasz/IMAD/src';
   load
```

## Domain modeling Card Decks (IMAD-Cards)

Interactive modeling of domain concepts using decks of cards.

Example of using a deck of cards, where each card represents a domain concept for the Faculty Doodle domain.
Browse: `FacultyDoodleModelingExamples`

Other stuff:

- `CardDeckTestExamples` — test functionality of Cards and Decks
- `CardRelationFilterTestExamples` — test functionality of filters
- `UsefulExamples` — technical examples showing how to solve various GT tasks

## FSA (IMAD-FSA)

Experiments to see how to model FSAs and Petri Nets with Mondrian.

```
FSA eg4nodes view.
FSA eg10nodes view.
```

## Executable Graph Models (IMAD-EGM)

Seminar Project by Louis Müller. An interactive graph editor building on the FSA project.

Inspect the following in the Morphic window:
```
Graph new
```

## Documents (doc folder)

Experiment to see how a Pillar document can be used to specify a TDD tutorial for Pharo.

Post Office TDD example:

```
FileLocator imageDirectory asFileReference / 'pharo-local/iceberg/onierstrasz/ASA-GtExperiments/doc/PostOffice'
```
