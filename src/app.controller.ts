import { Body, Controller, Get, Post } from "@nestjs/common";
import { AppService } from "./app.service";
import { CalculatePriceDto } from "./calculate-price.dto";

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Post()
  async calculatePrice(
    @Body() body: CalculatePriceDto,
  ): Promise<{ price: number }> {
    const vatRates = await this.appService.getTaxRates();

    return {
      price: body.items.reduce((out, curr) => {
        out +=
          (curr.standardVAT
            ? curr.price + curr.price * parseFloat(vatRates.standard)
            : curr.price) * curr.qty;

        return out;
      }, 0),
    };
  }

  @Get("healthz")
  getHealthz(): string {
    return "OK";
  }
}
