import { Injectable, LoggerService } from "@nestjs/common";
import { Logger } from "pino";
import pino from "pino";

@Injectable()
export class PinoLoggerService implements LoggerService {
  private readonly logger: Logger;

  constructor() {
    this.logger = pino();
  }

  debug(message: any, ...optionalParams: any[]): any {
    this.logger.debug(optionalParams, message);
  }

  error(message: any, ...optionalParams: any[]): any {
    this.logger.error(optionalParams, message);
  }

  log(message: any, ...optionalParams: any[]): any {
    this.logger.info(optionalParams, message);
  }

  verbose(message: any, ...optionalParams: any[]): any {
    this.logger.trace(optionalParams, message);
  }

  warn(message: any, ...optionalParams: any[]): any {
    this.logger.warn(optionalParams, message);
  }
}
