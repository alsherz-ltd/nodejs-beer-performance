import {
  ArrayContains,
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsInt,
  IsNotEmpty,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from "class-validator";
import { Type } from "class-transformer";

export class CalculatePriceDtoLineItem {
  @IsNotEmpty()
  @MinLength(1)
  @MaxLength(255)
  name: string;

  @IsNotEmpty()
  @Min(0.01)
  @Max(99999.99)
  price: number;

  @IsNotEmpty()
  @Min(1)
  @Max(1000)
  @IsInt()
  qty: number;

  @IsNotEmpty()
  standardVAT: boolean;
}

export class CalculatePriceDto {
  @IsNotEmpty()
  @ArrayMinSize(1)
  @ArrayMaxSize(100)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CalculatePriceDtoLineItem)
  items: CalculatePriceDtoLineItem[];
}
