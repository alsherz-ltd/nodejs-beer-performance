import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { PinoLoggerService } from "./logger.service";
import { Pool } from "pg";

@Module({
  imports: [],
  controllers: [AppController],
  providers: [
    PinoLoggerService,
    AppService,
    {
      provide: Pool,
      useValue: new Pool({
        host: process.env.DB_HOST || "localhost",
        database: process.env.DB_NAME || "postgres",
        user: process.env.DB_USER || "postgres",
        password: process.env.DB_PASS || "example",
        port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 5432,
        min: 1,
        max: 10,
        // TODO: replace with proper DA cert
        ssl: process.env.DB_HOST ? { rejectUnauthorized: false } : void 0,
        connectionTimeoutMillis: 1000,
      }),
    },
  ],
})
export class AppModule {}
