#!/bin/sh
cd ~/Dev

read -p 'Enter App Name: ' app_name

mkdir $app_name
cd $app_name

git init

echo "node_modules
.env" >> .gitignore
echo "# $app_name" >> README.md

read -p "Description: " description

echo "Creating github repo..."
gh repo create $app_name -y -d "$description" --public

npm init -y

echo "Installing node modules..."
npm install react react-dom node-sass

echo "Installing dev node modules..."
npm install typescript @types/react @types/react-dom webpack webpack-cli webpack-dev-server ts-loader style-loader css-loader babel-loader @babel/preset-typescript @babel/preset-react @babel/preset-env @babel/preset-env @babel/core html-webpack-plugin dotenv-webpack --save-dev && 


mkdir src

echo '{
  "compilerOptions": {
    "outDir": "./dist/",
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": false,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
' >> tsconfig.json

echo "<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='UTF-8' />
    <meta http-equiv='X-UA-Compatible' content='IE=edge' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0' />
    <title>Document</title>
  </head>
  <body>
    <div id='root'></div>
  </body>
</html>
" >> src/index.html



echo "import React, { ReactElement } from 'react';

interface Props {}

export default function App({}: Props): ReactElement {
  return <div className='App'>React webpack starter</div>;
}" >> src/App.tsx

echo "import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.scss';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);" >> src/index.tsx


echo "
.App {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 90vh;
}" >> src/index.scss


echo '{
  "presets": ["@babel/env", "@babel/react", "@babel/preset-typescript"],
  "plugins": ["@babel/plugin-proposal-class-properties"]
}
' >> .babelrc


echo 'const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const Dotenv = require("dotenv-webpack");

module.exports = {
  entry: "./src/index.tsx",
  output: { path: path.join(__dirname, "build"), filename: "index.bundle.js" },
  mode: process.env.NODE_ENV || "development",
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  devServer: { contentBase: path.join(__dirname, "src"), port: 3000 },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ["babel-loader"],
      },
      {
        test: /\.(ts|tsx)$/,
        exclude: /node_modules/,
        use: ["ts-loader"],
      },
      {
        test: /\.(css|scss)$/,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(jpg|jpeg|png|gif|mp3|svg)$/,
        use: ["file-loader"],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(__dirname, "src", "index.html"),
    }),
    new Dotenv(),
  ],
};
' >> webpack.config.js

git add .
git commit -m "First commit"
git branch -M main
git push -u origin main

code .