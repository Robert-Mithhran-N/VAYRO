import { HttpException, HttpStatus } from '@nestjs/common';
import { AllExceptionsFilter } from './all-exceptions.filter';

describe('AllExceptionsFilter Error Handling Tests', () => {
  let filter: AllExceptionsFilter;
  let mockJson: jest.Mock;
  let mockStatus: jest.Mock;
  let mockHost: any;

  beforeEach(() => {
    filter = new AllExceptionsFilter();
    mockJson = jest.fn();
    mockStatus = jest.fn().mockReturnValue({ json: mockJson });

    mockHost = {
      switchToHttp: () => ({
        getResponse: () => ({
          status: mockStatus,
        }),
        getRequest: () => ({
          url: '/api/v1/health',
          method: 'GET',
        }),
      }),
    };
  });

  it('should format HttpException without leaking internal information', () => {
    const exception = new HttpException('Resource forbidden', HttpStatus.FORBIDDEN);

    filter.catch(exception, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.FORBIDDEN);
    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        status: 'error',
        service: 'vayro-backend',
        version: '1.0.0',
        error: expect.objectContaining({
          message: 'Resource forbidden',
        }),
      }),
    );
  });

  it('should catch generic Error and return 500 status', () => {
    const exception = new Error('Database unexpected failure');

    filter.catch(exception, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        status: 'error',
        service: 'vayro-backend',
      }),
    );
  });
});

