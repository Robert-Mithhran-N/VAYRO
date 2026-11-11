import 'reflect-metadata';
import { validate } from './env.validation';

describe('Environment Validation Tests', () => {
  it('should accept valid environment configurations', () => {
    const config = {
      NODE_ENV: 'development',
      PORT: '3000',
      API_PREFIX: 'api/v1',
      DATABASE_URL: 'postgresql://vayro_user:secret@localhost:5432/vayro_db',
      REDIS_HOST: 'localhost',
      REDIS_PORT: '6379',
    };

    const validated = validate(config);
    expect(validated.PORT).toBe(3000);
    expect(validated.NODE_ENV).toBe('development');
    expect(validated.API_PREFIX).toBe('api/v1');
  });

  it('should throw an error when an invalid environment is supplied', () => {
    const invalidConfig = {
      NODE_ENV: 'invalid_env_mode',
      PORT: 'invalid_port_number',
    };

    expect(() => validate(invalidConfig)).toThrow();
  });
});
