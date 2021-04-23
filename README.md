# [Developing...]

# jekyll-aplayer
Embed aplayer in Jekyll posts/pages

## Table of Contents

...

## Requirements

- Ruby >= 2.3.0

## Installation

Add jekyll-aplayer plugin in your site's `Gemfile`, and run `bundle install`.

```ruby
gem 'jekyll-aplayer'
```

Add jekyll-aplayer to the `plugins:` section in your site's `_config.yml`

```yml
plugins:
  - jekyll-aplayer
```

## Configuration

This plugin runs with the following configuration options by default.

Alternative settings for these options can be explicitly specified in the configuration file `_config.yml`.

You can check the [Aplayer Docs](https://aplayer.js.org/) to know how to use them.

```yml
# Where things are
jekyll-aplayer:
  # default use 'default' processor
  processor: 'default' # 'netease'
  assets:
    css:
      - //unpkg.com/aplayer/dist/APlayer.min.css
    js:
      - //unpkg.com/aplayer/dist/APlayer.min.js
  class: 'jekyll-aplayer'
  fixed: false
  mini: false
  autoplay: false
  theme: '#b7daff'
  loop: 'all'
  order: 'random'
  preload: 'auto'
  volume: 0.7
  # audio:
  #   -
  #     name: 'name1',
  #     artist: 'artist1',
  #     url: 'url1.mp3',
  #     cover: 'cover1.jpg',
  #     lrc: 'lrc1.lrc',
  #     theme: '#ebd0c2'
  #   -
  #     name: 'name2',
  #     artist: 'artist2',
  #     url: 'url2.mp3',
  #     cover: 'cover2.jpg',
  #     lrc: 'lrc2.lrc',
  #     theme: '#46718b'
  audio: []
  mutex: true
  lrcType: 3
  listFolded: false
  listMaxHeight: 90
  storageName: 'aplayer-setting'
```

## Usage

### Markdown

#### default

````
```aplayer
{
  "processor": "default",
  // "id": "aplayer1", # Of course, you can set id byself, but i suggest not do it, because it will generate automatically.
  "fixed": true,
  "mini": false,
  "audio": [
    {
      "name": "Hahah",
      "artist": "artist",
      "url": "/audios/hikarunara.mp3",
      "cover": "/img/cover/hikarunara.jpg"
    }
  ]
}
```
````

#### netease (NeteaseMusic)

````
```aplayer
{
  "processor": "netease",
  ...
}
```
````

### Html


#### default

````html
<!-- Of course, you can set id byself, but i suggest not do it, because it will generate automatically. -->
<aplayer id="aplayer1" processor="default" fixed="true" mini="false" audio="[{ 'name': 'Hahah', 'artist': 'artist', 'url': '/audios/hikarunara.mp3', 'cover': '/img/cover/hikarunara.jpg' }]"></aplayer>
````

#### netease (NeteaseMusic)

````html
<aplayer id="aplayer1" processor="netease" ...></aplayer>
````

## Credits

- [Jekyll](https://github.com/jekyll/jekyll) - A blog-aware static site generator in Ruby.
- [APlayer](https://github.com/DIYgod/APlayer) - Wow, such a lovely HTML5 music player
- [Jekyll Spaceship](https://github.com/jeffreytse/jekyll-spaceship) - A Jekyll plugin to provide powerful supports for table, mathjax, plantuml, mermaid, emoji, video, audio, youtube, vimeo, dailymotion, soundcloud, spotify, etc.

## Contributing

Issues and Pull Requests are greatly appreciated. If you've never contributed to an open source project before I'm more than happy to walk you through how to create a pull request.

You can start by [opening an issue](https://github.com/Oscaner/jekyll-aplayer/issues/new) describing the problem that you're looking to resolve and we'll go from there.

## License

This software is licensed under the [MIT license](https://opensource.org/licenses/mit-license.php) © Oscaner Miao.
