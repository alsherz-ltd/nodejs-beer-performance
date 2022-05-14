import { Injectable } from "@nestjs/common";
import { Pool } from "pg";
import { getTaxRates } from "./tax-rates.generated-queries";

@Injectable()
export class AppService {
  constructor(private readonly pool: Pool) {}

  getHello(): string {
    return "Hello World!";
  }

  async getTaxRates(): Promise<{
    childrensClothes: string;
    food: string;
    standard: string;
  }> {
    const results = await getTaxRates.run(null, this.pool);

    return results[0];
  }
}
