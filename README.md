# GPOBA styleguide
#### Branding &amp; tone guidelines for GPOBA

## Content

Content is organized in "chapters" and "sections." Essentially, a page of the styleguide is a "chapter" and each scrolling section on the page is a "section." Each section is a separate markdown file with its own front-matter. They are grouped in folders which are used to generate chapter pages. Content is managed by Middleman's [blogging extension](https://middlemanapp.com/basics/blogging/) using [collections](https://middlemanapp.com/basics/blogging/#custom-article-collections).

### To edit content:

1. Open the section file you need to edit on github or in your favorite editor.
2. Make you changes and, if you're working on github, press the "commit" button below. If you're working locally in your own editor, commit your changes to the repository and deploy to Heroku.

### To add a new section:

1. Navigate to the chapter folder you want (e.g. "01-Logo"), and create a new markdown file. Middleman uses several file extensions to render content, so it's best to name your file `FILENAME.html.md.erb`
2. Add front matter:
    - `title`: your section title
    - `weight`: the order where you'd like your section to appear. The higher the number the more "weight" it has and therefore the lower it will sink on the page. A weight of 0 or 1, for instance, will place it at or near the top, while a weight of 1000 will place it at or near the bottom.
    - `date`: this is required by Middleman but not used otherwise. It's easiest to just put in today's date in this format: `MM-DD-YYYY`. (Note that if two sections have the same `weight` number, the one with the more recent date will rise higher.)
3. Commit your changes and behold the terrible glory of the monster you have created.

### To add a new chapter:

"Chapters" are really just folders of section files. They need to be named a certain way, however.

1. The folder name should start with a number, e.g. "01," which will be the "weight" of the chapter. Just as with sections, it's weight determines the order in which it is placed in the main navigation.
2. After the number, add a dash and then the title of the chapter, such as "01-logo" or "02-typography." The title will be capitalized in the templates. If the title has more than one word, just use hyphens, e.g. "03-tone-and-style." Try to keep the title relatively short, as it will be used in the navigation.
3. Add sections to your new folder (see instructions above). Note that Git does not recognize empty folders, so your chapter cannot be committed to the repository until it contains at least 1 section.

## Development

### To create a local copy:

1. Clone this repository.
2. Install [Ruby](https://www.ruby-lang.org/en/), [Bundler](http://bundler.io), and [Node.js](https://nodejs.org/en/) if you don't already have them.
3. Open Terminal and run `bundle install` and then `npm install` to install dependencies.
4. If all that went okay, run `bundle exec middleman` to start a Middleman server and watch for changes. (Middleman will automatically run the NPM pipeline for CSS, JS and such.)
5. `Control + C` to shut down the server.
