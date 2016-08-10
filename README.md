one-player-core
===============

Latest release: v2.0.0-alpha15

The one-player-core is a Javascript library implementic a generic streaming video player using HTML5 Media Source and Encrypted Media extensions. It is entirely written in reactive-programming with ECMAScript 6.

It comes with a support for DASH and SmoothStreaming transports.

## API

[Read the detailed API](//github.com/canalplus/one-player-core/blob/master/API.md).

## Why a new player ? Why Rx ?

Building a streaming video player in javascript is a complex task due to the numerous interactions with the outside world it has to deal with. Whether they come from the user seeking at a particular moment of its movie, changing the current channel or the network congestion. The video player being the centerpiece of our applications, it needs to adapt very quickly to any of these inputs and stay resilient to various errors.

Many current video player implementations rely on classical object-oriented hierarchy and imperative event callbacks with shared mutable objects to manage all these asynchronous tasks and states. We found this approach to be the wrong abstraction to handle the complexity of a video player.

Rx on the contrary provides gracious interfaces and operators to compose asynchronous tasks together by representating changing states as observable stream of values. It also comes with a **cancelation** contract so that every asynchronous side-effect can be properly disposed when discarded by the system (this is still [a controversial issue in the JS community](https://github.com/whatwg/fetch/issues/27)).

This allowed us to implement some nice features quite easily. For instance, because in the one-player-core all asynchronous tasks are encapsulated in observable data-structures, we were able to add a transparent [retry system](https://github.com/canalplus/canal-js-utils/blob/master/rx-ext.js#L73-L100) with a simple observable operator to declaratively handle any failure and replay the whole process.

Another example is the way we abstracted our transport layer into an observable pipeline, allowing us to support different type of streaming systems with its own asynchronous specifities. And because Rx is message-driven, this encapsulation allows us isolate the transport I/O into a WebWorker without any effort, or add an offline support for any pipeline implementation.

### Architecture

TODO

## Demo

The demo is a small application written in [React](https://github.com/facebook/react) demonstrating a simple usage of the player.

To launch the demo yourself, run `make demo` and start a local webserver from the root directory of the repository. For instance:

```sh
python -m SimpleHTTPServer 8080 # open http://localhost:8080/demo
```
[View online Demo](http://canalplus.github.io/one-player-core/)

## Installation

The fastest way to use our player is to add this repository as a dependency of
your `package.json` dependency field:

```
npm install --save https://github.com/canalplus/one-player-core/
```

You can then either use directly the `dist/one-player-core.js` file:

```html
<script src="node_modules/one-player-core/dist/one-player-core.js"></script>
```

Or with tools like [Browserify](http://browserify.org/) or
[Webpack](http://webpack.github.io/) you can import the player as a CommonJS
or AMD dependency.

## Dependencies

- [RxJS](https://github.com/Reactive-Extensions/RxJS)
- [canal-js-utils](https://github.com/canalplus/canal-js-utils)
- [es6-promise](https://github.com/jakearchibald/es6-promise)

For the demo only:

- Font Awesome by Dave Gandy - http://fontawesome.io

## Build

A build is directly included at `dist/one-player-core.js` directory if you don't
want to build it yourself.

To bundle the application yourself, we use `make`. The important task to know:

```sh
make clean
# build dist/one-player-core.js
make build
# build dist/one-player-core.min.js
make min
# build and watch file change for rebuild
make dev
# lint the code with jshint
make lint
```

## Target support

Here are the supported platform that we plan to target with this player.

|          |    IE     |  Firefox  |   Chrome  |  Safari   |
|----------|-----------|-----------|-----------|-----------|
| Windows  |   >= 11   |  Nightly  |   >= 30   |           |
| OX X     |           |  Nightly  |   >= 30   |   >= 8    |
| Linux    |           |  Nightly  |   >= 37   |           |
| iOS      |           |           |           |           |
| Android  |           |           |   >= 30   |           |

- Internet Explorer 11 only on Windows >= 8.
- To test on Firefox, use Firefox Nightly and add in about-config:
     media.mediasource.enabled        true
     media.mediasource.ignore_codecs  true
- Android version >= 4.2

A good way to know if the browser should be supported by our player is to go
on the page https://www.youtube.com/html5 and check support for MSE & H.264.

## Launch tests


### Unit Testing
Tests are only usable from the browser for now due to dependencies on DOM
elements. We plan to add support for `node` only tests asap.

```sh
# starts a local webserver, open http://localhost:9999/webpack-dev-server/test
make test
```

### Functional Testing

See [this document](./test/func/README.md)
