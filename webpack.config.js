const path = require('path');

const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    mode: 'development',
    entry: [
        './src/coffee/index.coffee',
        './src/less/style.less'
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].js'
    },
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.coffee$/,
                use: ['coffee-loader']
            },
            {
                test: /\.less$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    { loader: 'less-loader', options: { sourceMap: true } }
                ]
            },
            { test: /\.html$/, use: 'html-loader' }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({template: './src/markup/index.html'}),
        new MiniCssExtractPlugin({
            filename: '[name].css',
            chunkFilename: '[id].css' 
        })
    ]
};