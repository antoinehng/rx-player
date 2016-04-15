/* eslint-env node */
const path = require("path");

const ONE_PLAYER_CORE_ENV = process.env.ONE_PLAYER_CORE_ENV || "production";

if (["development", "production"].indexOf(ONE_PLAYER_CORE_ENV) < 0) {
  throw new Error("unknown ONE_PLAYER_CORE_ENV " + ONE_PLAYER_CORE_ENV);
}

const webpack = require("webpack");

module.exports = {
  output: {
    library: "RxPlayer",
    libraryTarget: "umd",
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: "babel",
        query: {
          "presets": ["es2015-loose"],
        },
      },
    ],
  },
  resolve: {
    alias: {
      main: __dirname + "/src",
      test: __dirname + "/test",
    },
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.DefinePlugin({
      "__DEV__": ONE_PLAYER_CORE_ENV === "development",
      "process.env": {
        NODE_ENV: JSON.stringify(ONE_PLAYER_CORE_ENV),
      },
    }),
  ],
  node: {
    console: false,
    global: true,
    process: false,
    Buffer: false,
    __filename: false,
    __dirname: false,
    setImmediate: false,
  },
  resolveLoader: {
    root: path.join(__dirname, "node_modules"),
  },
};
