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
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'vayro_dev_jwt_access_secret_super_secure_key_2026',
    accessExpiration: process.env.JWT_ACCESS_EXPIRATION || '15m',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'vayro_dev_jwt_refresh_secret_super_secure_key_2026',
    refreshExpiration: process.env.JWT_REFRESH_EXPIRATION || '7d',
  },
  cors: {
    origins: (process.env.CORS_ORIGINS || 'http://localhost:5173,http://localhost:3000').split(','),
  },
  swagger: {
    enabled: process.env.SWAGGER_ENABLED !== 'false',
  },
  logLevel: process.env.LOG_LEVEL || 'debug',
});
