import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

describe('AuthController Unit Tests', () => {
  let controller: AuthController;
  let mockAuthService: any;

  beforeEach(async () => {
    mockAuthService = {
      register: jest.fn().mockResolvedValue({
        user: { id: 'u1', email: 'test@vayro.app', displayName: 'Tester' },
        tokens: { accessToken: 'at-1', refreshToken: 'rt-1' },
      }),
      login: jest.fn().mockResolvedValue({
        user: { id: 'u1', email: 'test@vayro.app', displayName: 'Tester' },
        tokens: { accessToken: 'at-1', refreshToken: 'rt-1' },
      }),
      refreshToken: jest.fn().mockResolvedValue({
        accessToken: 'at-2',
        refreshToken: 'rt-2',
      }),
      logout: jest.fn().mockResolvedValue({ message: 'Logged out successfully.' }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [{ provide: AuthService, useValue: mockAuthService }],
    }).compile();

    controller = module.get<AuthController>(AuthController);
  });

  it('register should invoke AuthService.register', async () => {
    const dto = {
      email: 'test@vayro.app',
      password: 'Password123!',
      displayName: 'Tester',
    };
    const res = await controller.register(dto);
    expect(res.user.email).toBe(dto.email);
    expect(mockAuthService.register).toHaveBeenCalledWith(dto);
  });

  it('login should invoke AuthService.login', async () => {
    const dto = { email: 'test@vayro.app', password: 'Password123!' };
    const res = await controller.login(dto);
    expect(res.tokens.accessToken).toBe('at-1');
    expect(mockAuthService.login).toHaveBeenCalledWith(dto);
  });

  it('refreshToken should invoke AuthService.refreshToken', async () => {
    const res = await controller.refreshToken({ refreshToken: 'rt-1' });
    expect(res.accessToken).toBe('at-2');
    expect(mockAuthService.refreshToken).toHaveBeenCalledWith('rt-1');
  });

  it('logout should invoke AuthService.logout with userId', async () => {
    const res = await controller.logout('u1', { refreshToken: 'rt-1' });
    expect(res.message).toBe('Logged out successfully.');
    expect(mockAuthService.logout).toHaveBeenCalledWith('u1', 'rt-1');
  });

  it('getProfile should return authenticated user object', () => {
    const user = { id: 'u1', email: 'test@vayro.app' };
    const res = controller.getProfile(user);
    expect(res).toBe(user);
  });
});
