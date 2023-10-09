import express from 'express'
import exceptionHandler from 'express-exception-handler'
import cors from 'cors'
import config from './config'
import { getHttpLogger } from './logging'

exceptionHandler.handle()
const app = express()

if (!config.protectRoutes) {
    app.options('*', cors())
}

const httpLogger = getHttpLogger()
if (httpLogger) {
    app.use(httpLogger)
}

app.use('/', express.static('./wwwroot'))

export default app
