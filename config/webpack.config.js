// Example webpack configuration with asset fingerprinting in production.
require('babel-polyfill');
require('es6-promise').polyfill();

var path = require('path');
var webpack = require('webpack');
var autoprefixer = require('autoprefixer');
var StatsPlugin = require('stats-webpack-plugin');
var ExtractTextPlugin = require("extract-text-webpack-plugin");


// must match config.webpack.dev_server.port
var devServerPort = 3808;

// set NODE_ENV=production on the environment to add asset fingerprints
// var production = process.env.NODE_ENV === 'production';
var production = true;

var config = {
    context: __dirname + "/../",
    entry: {
        global: ["./webpack/javascripts/global.js", "./webpack/stylesheets/global.scss"],
        // global: "./webpack/javascripts/global.js",
        // global: "./webpack/stylesheets/global.scss",

        // Sources are expected to live in $app_root/webpack
        // 'application': './webpack/application.js'
        faqApp: './webpack/components/faqApp.js',
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
        // library: "Turbolinks",

        filename: production ? '[name]-[hash].js' : '[name].js'
    },

    resolve: {
        modules: ["webpack", "node_modules", "lib/assets", "vendor/assets/javascripts", "vendor/assets/stylesheets"],
        extensions: ['.js', '.jsx', '.css', '.scss'],
        alias: {
            jquery: 'jquery/dist/jquery',
            stellar: "jquery.stellar/jquery.stellar"
            //,
            //'jquery-turbolinks': 'jquery.turbolinks/vendor/assets/javascripts/jquery.turbolinks.js'
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
                test: /\.js$/,
                exclude: /(node_modules)/,
                loader: "babel-loader?presets[]=react,presets[]=es2015"
            },
            // Embed images
            {
                test: /\.(jpe?g|png|gif)$/i,
                use: {
                    loader: 'file-loader',
                    options: {name: 'images/[name].[ext]'}
                },
                //loader: 'file-loader?name=images/[name].[ext]'
            },
            {
                test: /\.svg/,
                use: {
                    loader: 'svg-url-loader',
                    options: {name: 'images/[name].[ext]'}
                },
                //loader: 'svg-url-loader?name=images/[name].[ext]'
            },
            // Embed cursor pointers in Css
            {
                test: /\.(cur)$/i,
                use: {
                    loader: 'file-loader',
                    options: {name: 'images/[name].[ext]'}
                },
                //loader: 'file-loader?name=images/[name].[ext]'
            },

            // Process SASS files
            {
                test: /\.s?css$/,
                use: ExtractTextPlugin.extract({
                    //fallback: "style-loader",
                    use: [
                        {
                            loader: "css-loader",
                            options: {
                                sourceMap: true,
                            }
                        },
                        {
                            loader: "resolve-url-loader",
                            options: {
                                sourceMap: true,
                            }
                        },
                        {
                            loader: "sass-loader",
                            options: {
                                sourceMap: true,
                            }
                        },

                    ]
                }),
                // loader: ExtractTextPlugin.extract('css-loader?sourceMap!resolve-url-loader?sourceMap!sass-loader?sourceMap'),
                //loader: ExtractTextPlugin.extract('css-loader?sourceMap!resolve-url-loader!sass-loader?sourceMap'),
                //loaders: ['style-loader', 'css-loader', 'resolve-url-loader', 'sass-loader?sourceMap', 'postcss-loader']
                //loader: 'style!css!sass!postcss'
            },
            // Embed fonts
            {
                test: /\.woff(2)?([\?].*)?$/,
                use: {
                    loader: 'url-loader',
                    options: {
                        name: 'fonts/[name].[ext]',
                        limit: 100000,
                        mimetype: 'application/font-woff'
                    }
                },
                // loader: 'url-loader?name=fonts/[name].[ext]&limit=100000&mimetype=application/font-woff'
            },
            {
                test: /\.(ttf|eot)([\?].*)?$/,
                use: {
                    loader: 'url-loader',
                    options: {
                        name: 'fonts/[name].[ext]',
                        limit: 100000
                    }
                },
                //loader: 'url-loader?&limit=100000&name=fonts/[name].[ext]'
            },
            // expose jQuery
            { test: require.resolve('jquery'), loader: 'expose-loader?jQuery' },
            { test: require.resolve('jquery'), loader: 'expose-loader?jquery' },
            { test: require.resolve('jquery'), loader: 'expose-loader?$' },

        ]
    },


    plugins: [
        new webpack.LoaderOptionsPlugin({
            options: {
                context: path.join(__dirname, '..'),
                debug: true,
                output: {
                    path: path.join(__dirname, '..', 'public', 'webpack')
                }
            }
        }),
        new ExtractTextPlugin({
            filename: production ? '[name]-[hash].css' : '[name].css',
            allChunks: true,
            ignoreOrder: true
        }),
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
        new webpack.NoEmitOnErrorsPlugin(),
        new webpack.optimize.UglifyJsPlugin({
            screw_ie8: true,
            compressor: { warnings: false },
            sourceMap: true
        }),
        new webpack.DefinePlugin({
            'process.env': { NODE_ENV: JSON.stringify('production') }
        })
    )
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
