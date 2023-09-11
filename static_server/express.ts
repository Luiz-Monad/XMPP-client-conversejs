import express from 'express'
import exceptionHandler from 'express-exception-handler'
import cors from 'cors'

import { getHttpLogger } from './logging'

exceptionHandler.handle()
const app = express()

const httpLogger = getHttpLogger()
if (httpLogger) {
    app.use(httpLogger)
}

app.options('*', cors())
app.use('/', express.static('./wwwroot'))

export default app
