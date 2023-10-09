// ==================================
// SECURITY CONFIGURATION
// ==================================
const PROTECT_ROUTES = !!(process.env.PROTECT_ROUTES && process.env.PROTECT_ROUTES === 'true')

// ==================================
// APPLICATION CONFIGURATION
// ==================================
const PORT = process.env.PORT || '3333'
const LOG_LEVEL = process.env.LOG_LEVEL || 'info'
const HTTP_LOG_LEVEL = process.env.HTTP_LOG_LEVEL || 'info'

// ==================================
// EXPORT
// ==================================
export default {
    port: PORT,
    log: {
        level: LOG_LEVEL,
        httpLevel: HTTP_LOG_LEVEL,
    },
    protectRoutes: PROTECT_ROUTES,
}
