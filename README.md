# tech\_radar [![Build Status](https://travis-ci.org/stitchfix/tech_radar.svg?branch=add_travis_yml)](https://travis-ci.org/stitchfix/tech_radar)

> A Rails engine for managing a [Tech Radar](https://www.thoughtworks.com/radar) for your team.  

It allows you to identify the technology in use on your team, where it is in your level of adoption and other bits of metadata, such as whitepapers, blog posts, etc.

The Tech Radar is a way you can manage the use of technology on your team.  This tool makes it easier to do that, but you'll still need
process and good communication to make the most of it.

## Install and Setup

You'll need to do four things to get this working:

1. Set up the engine
2. Fix any references to route helpers in your main applicaiton layout
3. Author your radar in the YAML file format
4. Modify any text or copy in your localization file

### Set up the engine

First, add to your `Gemfile`:

```ruby
gem 'tech_radar'
```

After a `bundle install`, mount it in your Rails app:

```ruby
# config/routes.rb
Rails.application.routes.draw do

  # ...

  mount TechRadar::Engine, at: "/tech-radar", as: :tech_radar
end
```

The radar is now available at `/tech-radar` in your Rails app. If your main applicaiton layout uses any route helpers (e.g. for a nav),
you'll need to change those. 

### Fix References to Route Helpers in Applicaiton Layout

The engine will use your applicaiton layout, so if your layout uses any route helpers, they won't work when on the tech radar's views.
To fix this, you must prepend `main_app.` to your routes.  

For example, if you have this:

```html
<nav>
  <ul>
    <li><%= link_to "Home",   root_path %></li>
    <li><%= link_to "Logout", signout_path %></li>
  </ul>
</nav>
```

You'll change it to this:

```html
<nav>
  <ul>
    <li><%= link_to "Home",   main_app.root_path %></li>
    <!--                      ^^^^^^^^ -->
    <li><%= link_to "Logout", main_app.signout_path %></li>
    <!--                      ^^^^^^^^ -->
  </ul>
</nav>
```

To create links to the radar's views, use `rake routes` to view them as you normally would.

With this in place, you now should author your radar.

### Authoring Your Radar

The Radar is expected to be in `config/tech-radar.yml`.  You should start with this YAML file:

```yaml
"Tools":
  "Adopt":
    "vi":
      purpose :"text editing"
      more_details_url: "http://vim.org"
      why_summary: "vi is a great text editor!"
      why_url: http://naildrivin5.com/blog/2013/04/24/how-to-switch-to-vim.html
  "Trial":
  "Assess":
  "Hold":
"Platforms":
  "Adopt":
  "Trial":
  "Assess":
  "Hold":
"Techniques":
  "Adopt":
  "Trial":
  "Assess":
  "Hold":
"Languages and Frameworks":
  "Adopt":
  "Trial":
  "Assess":
  "Hold":
```

Note that these keys are special.  If you are not using English, you can customize how these are displayed in your localization file, so
don't translate or change these values.

The top level are the _quadrants_ (e.g. “Techniques”).  These are used to partition your technologies by a rough type.  The next level
down are _rings_ (e.g.“Adopt”).  These rings represent a level of adoption in your organization.

Inside each Ring should be a hash, which has the name of a technology as a key, and some metadata:

* `purpose`: required, this is the explanation of what this technology is for.
* `more_details_url`: optional, a link to explain in more detail what the technology is.  If omitted, the engine will show a link to a
Google search for the technology.
* `why_summary`: optional, but recommended, this explains why this technology is in the ring that it's in.  In particular, this is useful
for technologies not in _Adopt_.
* `why_url`: optional, this is a link to a white paper or other explanation about why the technology in in the ring that it's in.  This is
where you'd reference a detailed analysis or experience report with the technology.

We'd recommend that, for your first pass, you document your current landscape, and not be too aspirational.

With this set up, you can see the radar in your app.  All copy is controllers by localization, and you can override it in your app.  This
is useful not just for translating the strings, but for customizing the messaging to your team.

### Modify any text or copy in your localization file

Examine the `config/en.yml` in this engine's source.  You can override any or all of those values for your team.  For example, the
default summary of the _Adopt_ ring is as follows:

> Use these, as they are supported and proven in production

Suppose that, for your team, you need to get approval of the architecture team to use technologies not in _Adopt_.  You could change that
by adding this to your application's `config/locales/en.yml`:

```yaml
en:
  tech_radar:
    radar:
      rings:
        "Adopt":
          summary: "Use these by default.  See the architecture team if you need something else."
```

All the text in the engine can be customized in this way.

## Configuration

To customize the configuration of this engine, create `config/initializers/tech_radar.rb`.  In there you can override any configuration
options you need.

### `warn_on_missing_why_summary`

If a technology is missing a `why_summary`, by defaut the engine's views will show a warning on that technology's page, urging you to
provide a summary.  You may only want this warning for certain rings.  In that case, you can set `warn_on_missing_why_summary` to a hash,
where each key is the ring name from the `config/tech-radar.yml` file, and the value is true or false, if a warning should be
shown when there is no `why_summary`.

```ruby
For "Adopt" and "Trial", it's OK if the why_summary is missing
TechRadar.warn_on_missing_why_summary = {
  "Hold" => true,
  "Assess" => true,
}

# Or, disable the warnings entirely
TechRadar.warn_on_missing_why_summary = Hash.new(false)
```

## Styling

The radar's views use [Bootstrap](https://getbootstrap.com), for a few reasons:

* We needed the default to look reasonably nice
* Bootstrap is widely used and understood
* Bootstrap can be brought in piecemeal alongside another framework, relatively easily

Currently, you'll need only part of Bootstrap's styles to make things work.  If you are using the SASS version of bootstrap, you can
bring in what you need like so:

```sass
@import "bootstrap-sprockets";
@import "bootstrap/variables";
@import "bootstrap/mixins";

@import "bootstrap/grid";
@import "bootstrap/navs";
@import "bootstrap/pagination";
@import "bootstrap/labels";
@import "bootstrap/alerts";
@import "bootstrap/panels";
```

You can, of course, create your own views by accessing the `TechRadar::Radar` model directly.

## Licence

*tech_radar* is released under the [MIT License](http://www.opensource.org/licenses/MIT).

## Contributing

*tech_radar* appreciates contributors!  Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Everyone interacting in *tech_radar*'s codebase, issue trackers, chat rooms, and mailing lists is expected to follow the *tech_radar* [code of conduct](CODE_OF_CONDUCT.md).

---

Provided with :heart: by your friends at [Stitch Fix Engineering](http://multithreaded.stitchfix.com/)
