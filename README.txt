IdeaMachine - A generative grammar for fun and profit

IdeaMachine is a fairly simple generative grammar originally used for a silly idea generator, available in the examples/ideas directory.  We also have a simple planet description generator in examples/planets.

To see it in action, just run:
  ruby examples/ideas/generate_ideas.rb
or
  ruby examples/ideas/generate_planets.rb

The grammar files consist of entries like
  RESULT  {a|FRUIT}
  FRUIT   {apple,plum,orange}
This would result in "a plum", "an apple", and "an orange" 1/3 of the time each.  There can be many RESULT lines, one will be selected at random to output.  {A|FRUIT} would give "A plum", "An apple", and "An orange".

  FRUIT   {apple,plum,orange}
is equivalent to
  FRUIT   apple
  FRUIT   plum
  FRUIT   orange

You can use {c|SOMETHING} to capitalize SOMETHING.  I.e., {c|FRUIT} might return "Apple" or "Orange".

To pluralize, use {FRUIT|s}, giving, for example, "apples" or "oranges".

Here is a more complex example:
  RESULT    {A|SIZE} {PLANET_STATE} {PLANET_TYPE} {orbiting,drifting around} {a|STAR_TYPE}, {named,called} {NAME} in the {NAME} language.
  SIZE      {large,small,medium size,inconsequential}
  PLANET_TYPE   {brown,white,sub-brown} dwarf
  ... see examples/planets/parts/planets.txt for the whole thing.

Possible results include:
  A large inhospitable double planet drifting around a photometric-standard star, named Muse'slo minor in the Hofuqa language.
  A medium size inhospitable Earth-type planet orbiting a blue supergiant star, named Manuseraslo I in the Dosera'mu language.



Oh, also, here are some possible names for a site based on the ideas example:
  idealibs.com
  codewritersblock.com
  thoughtprovokr.com
  ideaprovoker.com
  projectsuggester.com
  projectsuggest.com
  whatshouldicreate.com

If you build one of these, let me know!