export default () => ({
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  apiPrefix: process.env.API_PREFIX || 'api/v1',
  database: {
    url: process.env.DATABASE_URL || 'postgresql://vayro_user:vayro_secret_dev_password@localhost:5432/vayro_db',
  },
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
    password: process.env.REDIS_PASSWORD || 'vayro_redis_dev_secret',
  },
  cors: {
    origins: (process.env.CORS_ORIGINS || 'http://localhost:5173,http://localhost:3000').split(','),
  },
  swagger: {
    enabled: process.env.SWAGGER_ENABLED !== 'false',
  },
  logLevel: process.env.LOG_LEVEL || 'debug',
});

