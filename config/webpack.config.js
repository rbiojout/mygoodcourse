// Example webpack configuration with asset fingerprinting in production.

var path = require('path');
var webpack = require('webpack');
var autoprefixer = require('autoprefixer');
var StatsPlugin = require('stats-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");


// must match config.webpack.dev_server.port
var devServerPort = 3808;

// set NODE_ENV=production on the environment to add asset fingerprints
var production = process.env.NODE_ENV === 'production';
// var production = true;

var config = {
    context: __dirname + "/../",
    entry: {
      global: ["./webpack/javascripts/global.js", "./webpack/stylesheets/global.scss"],
      // global: "./webpack/javascripts/global.js",

        // Sources are expected to live in $app_root/webpack
        // 'application': './webpack/application.js'

    },

    output: {
        // Build assets directly in to public/webpack/, let webpack know
        // that all webpacked assets start with webpack/

        // must match config.webpack.output_dir
        path: path.join(__dirname, '..', 'public', 'webpack'),
        publicPath: '/webpack/',
        // export itself to a global var
        libraryTarget: "var",
        // name of the global var: "Foo"
        library: "Turbolinks",

        filename: production ? '[name]-[chunkhash].js' : '[name].js'
    },

    resolve: {
        modules: [
            path.resolve(__dirname, "webpack"),
            "node_modules",
            path.resolve(__dirname, "lib/assets"),
            path.resolve(__dirname, "vendor/assets/javascripts"),
            path.resolve(__dirname, "vendor/assets/stylesheets")],
        alias: {
            jquery: 'jquery/dist/jquery',
            stellar: "jquery.stellar/jquery.stellar",
            'jquery-turbolinks': 'jquery.turbolinks/vendor/assets/javascripts/jquery.turbolinks.js'
        }
    },


    externals: {
        // This mean that require('jquery') will refer to global var jQuery
        // 'jquery': 'jQuery'
    },

    module: {
        rules: [
            // Process .js and .jsx files for ES6 and React
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                use: [
                    'babel-loader',
                ],
            },
            // Embed images
            {
                test: /\.(jpe?g|png|gif)$/i,
                use: 'file-loader?name=images/[name].[ext]'
            },
            {
                test: /\.(svg)$/i,
                use: 'file-loader?mimetype=image/svg+xml&name=images/[name].[ext]'
                //loader: 'url-loader?limit=10000&mimetype=image/svg+xml&name=images/[name].[ext]'
                //loader: 'svg-url-loader?name=images/[name].[ext]'
            },
            // Embed cursor pointers in Css
            {
                test: /\.(cur)$/i,
                use: 'file-loader?name=images/[name].[ext]'
            },
            // Process normal CSS files
            {
                test: /\.acss$/, // Only .css files
                use: ExtractTextPlugin.extract("css-loader?sourceMap!resolve-url-loader"),
                //, loaders: ['style-loader', 'css-loader', 'resolve-url-loader', 'postcss-loader']
                //loader: 'style!css!postcss'
            },
            // Process SASS files
            {
                test: /\.s?css$/,
                use: [{
                    loader: "style-loader"
                    },
                    {
                    loader: "css-loader",
                    query: {
                        modules: false,
                        sourceMap: true,
                        importLoaders: 2
                        }
                    },
                    {
                        loader: 'resolve-url-loader'
                    },
                    {
                    loader: "sass-loader",
                        query: {
                            sourceMap: true,
                            sourceMapContents: true
                        }
                }],
                //loaders: ['style-loader', 'css-loader', 'resolve-url-loader', 'sass-loader?sourceMap', 'postcss-loader']
                //loader: 'style!css!sass!postcss'
            },
            // Embed fonts
            {
              test: /\.woff(2)?([\?].*)?$/,
              use: 'url-loader?name=fonts/[name].[ext]&limit=10000&mimetype=application/font-woff'
            },
            {
              test: /\.(ttf|eot)([\?].*)?$/,
              use: 'file-loader?name=fonts/[name].[ext]'
            },
            // expose jQuery
            { test: require.resolve('jquery'), loader: 'expose-loader?jQuery' },
            { test: require.resolve('jquery'), loader: 'expose-loader?jquery' },
            { test: require.resolve('jquery'), loader: 'expose-loader?$' },

        ]
    },

    plugins: [
        new webpack.LoaderOptionsPlugin({
            debug: true
        }),
        new ExtractTextPlugin(production ? '[name]-[chunkhash].css' : '[name].css'),
        // if you want a module available as variable in every module,
        // such as making $ and jQuery available in every module without writing require("jquery").
        // You should use ProvidePlugin.
        // Expose some modules globally to every module (so you don't have to explicitly require them)
        new webpack.ProvidePlugin({
            // $: "jquery",
            jQuery: "jquery",
            jquery: "jquery",
            "window.jQuery": "jquery",
            React: "react"
        }),
        // must match config.webpack.manifest_filename
        new StatsPlugin('manifest.json', {
            // We only need assetsByChunkName
            chunkModules: false,
            source: false,
            chunks: false,
            modules: false,
            assets: true
        })]
};

if (production) {
    config.plugins.push(
    new webpack.NoErrorsPlugin(),
    new webpack.optimize.UglifyJsPlugin({
        debug: true,
        compressor: { warnings: false },
        test: /\.js($|\?)/i,
        sourceMap: true
    }),
    new webpack.DefinePlugin({
        'process.env': { NODE_ENV: JSON.stringify('production') }
    }),
    new webpack.optimize.DedupePlugin()
    );
} else {
    config.devServer = {
        port: devServerPort,
        headers: { 'Access-Control-Allow-Origin': '*' }
    };
    config.output.publicPath = '//localhost:' + devServerPort + '/webpack/';
    // Source maps
    config.devtool = 'cheap-module-eval-source-map';
}

module.exports = config;
