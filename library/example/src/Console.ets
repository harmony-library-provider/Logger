import { logger } from '../../Index'

// Error
const fatal = new Error('logger.fatal')
const error = new Error('logger.error')

// logger.debug
logger.debug('Test logger.debug: message...')

// logger.info
logger.info('Test logger.info: message...')

// logger.warn
logger.warn('Test logger.warn: message...')

// logger.error
logger.error('Test logger.error: message...', error.message, error.stack)

// logger.fatal
logger.fatal('Test logger.fatal: message...', fatal.message, fatal.stack)