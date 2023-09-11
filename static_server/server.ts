import dotenv from 'dotenv'
dotenv.config()

import getLogger from './logging'
const logger = getLogger('server')

import http from 'http'
import app from './express'

const port = process.env.PORT
const server = http.createServer(app)

server.listen(port, async () => {
    logger.info(`Listening on port ${port}`)
})

const unexpectedErrorHandler = (error: any) => {
    logger.error(error)
}

process.on('uncaughtException', unexpectedErrorHandler)
process.on('unhandledRejection', unexpectedErrorHandler)

process.on('SIGTERM', () => {
    logger.info('SIGTERM received')
    if (server) {
        server.close()
    }
})

export default server
