import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'traveler@vayro.app', description: 'User email address' })
  @IsEmail({}, { message: 'A valid email address is required.' })
  email: string;

  @ApiProperty({ example: 'SecurePassword123!', description: 'Minimum 8 characters' })
  @IsString()
  @MinLength(8, { message: 'Password must be at least 8 characters long.' })
  password: string;

  @ApiProperty({ example: 'Alex Navigator', description: 'User display name' })
  @IsString()
  @IsNotEmpty({ message: 'Display name cannot be empty.' })
  displayName: string;
}
