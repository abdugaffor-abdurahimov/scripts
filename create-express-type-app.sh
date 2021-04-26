#!/bin/sh
cd ~/Dev

echo "Enter App Name"
read app_name

mkdir $app_name
cd $app_name

echo "Description"
read description

# Create github repo
git init

echo "node_modules
.env" >> .gitignore
echo "# $app_name" >> README.md

gh repo create $app_name -y -d "$description" --public


npm init -y

echo "Installing node modules..."
npm i cors express express-list-endpoints helmet

npm i -D typescript @types/cors @types/dotenv @types/express @types/express-list-endpoints ts-node-dev @types/helmet dotenv @types/node

tsc --init


mkdir src src/middlewares src/common

# Error handler middleware
echo "import HttpExeption from '../common/http-exception';
import { Request, Response, NextFunction } from 'express';

export const errorHandler = (
  error: HttpExeption,
  request: Request,
  response: Response,
  next: NextFunction
) => {
  const status = error.statusCode || error.status || 500;

  response.status(status).send(error);
};" >> src/middlewares/error.middleware.ts


# Not found middleware
echo "import { Request, Response, NextFunction } from 'express';

export const notFoundHandler = (
  request: Request,
  response: Response,
  next: NextFunction
) => {
  const message = 'Resource not found';
  response.status(404).send(message);
};" >> src//middlewares/not-found.middleware.ts


# Creating basic server
echo "import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import expressListEndpoint from 'express-list-endpoints';

import { errorHandler } from './middlewares/error.middleware';
import { notFoundHandler } from './middlewares/not-found.middleware';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

app.use(errorHandler);
app.use(notFoundHandler);

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(expressListEndpoint(app));
  console.log('App is running on port ' + port);
});
" >> ./src/server.ts


# Creating http-exeption
echo "export default class HttpExeptions extends Error {
  statusCode?: number;
  status?: number;
  message: string;
  error: string | null;

  constructor(statusCode: number, message: string, error?: string) {
    super(message);

    this.statusCode = statusCode;
    this.message = message;
    this.error = error || null;
  }
}" >> src/common/http-exception.ts





git add .
git commit -m "first commit"
git branch -M main
git push -u origin main

echo "dev: ts-node-dev -r dotenv/config --respawn --pretty --transpile-only src/server.ts"

code .
