import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

export class SmokeTestQueryDto {
  @ApiPropertyOptional({
    description: 'Client identifier performing the smoke test',
    example: 'vayro-mobile-client',
  })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  client?: string;

  @ApiPropertyOptional({
    description: 'Optional note or build identifier',
    example: 'initial-setup-verification',
  })
  @IsOptional()
  @IsString()
  @MaxLength(128)
  note?: string;
}

