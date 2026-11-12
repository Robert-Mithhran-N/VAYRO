import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../../database/prisma.service';
import { UsersService } from '../users/users.service';
import { AuthService } from './auth.service';

describe('AuthService Unit Tests', () => {
  let service: AuthService;
  let mockUsersService: any;
  let mockJwtService: any;
  let mockConfigService: any;
  let mockPrisma: any;

  const mockUser = {
    id: 'user-uuid-1234',
    email: 'traveler@vayro.app',
    displayName: 'Test Traveler',
    passwordHash: '',
    role: 'USER',
    isActive: true,
  };

  beforeAll(async () => {
    mockUser.passwordHash = await bcrypt.hash('CorrectPassword123!', 10);
  });

  beforeEach(async () => {
    mockUsersService = {
      findByEmail: jest.fn(),
      findById: jest.fn(),
      create: jest.fn(),
    };

    mockJwtService = {
      signAsync: jest.fn().mockImplementation((payload) => {
        return Promise.resolve(`signed_token_${payload.sub || 'token'}`);
      }),
      verifyAsync: jest.fn(),
    };

    mockConfigService = {
      get: jest.fn().mockImplementation((key, defaultVal) => defaultVal || 'mock_secret'),
    };

    mockPrisma = {
      refreshToken: {
        create: jest.fn().mockResolvedValue({ id: 'rt-1' }),
        findFirst: jest.fn(),
        update: jest.fn().mockResolvedValue({ id: 'rt-1', isRevoked: true }),
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UsersService, useValue: mockUsersService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: ConfigService, useValue: mockConfigService },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should register a new user and return user info with tokens', async () => {
      mockUsersService.findByEmail.mockResolvedValue(null);
      mockUsersService.create.mockResolvedValue(mockUser);

      const result = await service.register({
        email: 'traveler@vayro.app',
        password: 'Password123!',
        displayName: 'Test Traveler',
      });

      expect(result.user.email).toBe('traveler@vayro.app');
      expect(result.tokens.accessToken).toBeDefined();
      expect(result.tokens.refreshToken).toBeDefined();
      expect(mockUsersService.create).toHaveBeenCalled();
    });

    it('should throw ConflictException if user email already exists', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      await expect(
        service.register({
          email: 'traveler@vayro.app',
          password: 'Password123!',
          displayName: 'Duplicate Traveler',
        }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    it('should authenticate user with valid credentials', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      const result = await service.login({
        email: 'traveler@vayro.app',
        password: 'CorrectPassword123!',
      });

      expect(result.user.id).toBe(mockUser.id);
      expect(result.tokens.accessToken).toBeDefined();
      expect(result.tokens.tokenType).toBe('Bearer');
    });

    it('should reject invalid password with UnauthorizedException', async () => {
      mockUsersService.findByEmail.mockResolvedValue(mockUser);

      await expect(
        service.login({
          email: 'traveler@vayro.app',
          password: 'WrongPassword!',
        }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should reject nonexistent email with UnauthorizedException', async () => {
      mockUsersService.findByEmail.mockResolvedValue(null);

      await expect(
        service.login({
          email: 'unknown@vayro.app',
          password: 'Password123!',
        }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('refreshToken', () => {
    it('should rotate tokens when provided valid refresh token', async () => {
      mockJwtService.verifyAsync.mockResolvedValue({ sub: mockUser.id });
      mockPrisma.refreshToken.findFirst.mockResolvedValue({
        id: 'rt-1',
        userId: mockUser.id,
        isRevoked: false,
        expiresAt: new Date(Date.now() + 100000),
      });
      mockUsersService.findById.mockResolvedValue(mockUser);

      const tokens = await service.refreshToken('valid_refresh_token_string');

      expect(tokens.accessToken).toBeDefined();
      expect(tokens.refreshToken).toBeDefined();
      expect(mockPrisma.refreshToken.update).toHaveBeenCalledWith(
        expect.objectContaining({ data: { isRevoked: true } }),
      );
    });

    it('should reject revoked refresh token', async () => {
      mockJwtService.verifyAsync.mockResolvedValue({ sub: mockUser.id });
      mockPrisma.refreshToken.findFirst.mockResolvedValue(null);

      await expect(service.refreshToken('revoked_token')).rejects.toThrow(
        UnauthorizedException,
      );
    });
  });
});
