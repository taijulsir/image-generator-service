import * as fs from 'fs';
import * as path from 'path';

export class Logger {
    private static logsDir = path.join(process.cwd(), 'logs');
    private static isInitialized = false;

    private static initialize(): void {
        if (!this.isInitialized) {
            // Create logs directory if it doesn't exist
            if (!fs.existsSync(this.logsDir)) {
                fs.mkdirSync(this.logsDir, { recursive: true });
            }
            this.isInitialized = true;
        }
    }

    private static getLogFileName(type: 'combined' | 'error'): string {
        const date = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
        return path.join(this.logsDir, `${type}-${date}.log`);
    }

    private static writeToFile(level: string, message: string, meta?: any): void {
        this.initialize();

        const logMessage = this.formatMessage(level, message, meta);
        const logLine = `${logMessage}\n`;

        // Write to combined log
        fs.appendFileSync(this.getLogFileName('combined'), logLine);

        // Write errors to separate error log
        if (level === 'ERROR') {
            fs.appendFileSync(this.getLogFileName('error'), logLine);
        }
    }

    private static formatMessage(level: string, message: string, meta?: any): string {
        const timestamp = new Date().toISOString();
        const metaStr = meta ? ` ${JSON.stringify(meta)}` : '';
        return `[${timestamp}] [${level}] ${message}${metaStr}`;
    }

    static info(message: string, meta?: any): void {
        const formatted = this.formatMessage('INFO', message, meta);
        console.log(formatted);
        this.writeToFile('INFO', message, meta);
    }

    static error(message: string, meta?: any): void {
        const formatted = this.formatMessage('ERROR', message, meta);
        console.error(formatted);
        this.writeToFile('ERROR', message, meta);
    }

    static warn(message: string, meta?: any): void {
        const formatted = this.formatMessage('WARN', message, meta);
        console.warn(formatted);
        this.writeToFile('WARN', message, meta);
    }

    static debug(message: string, meta?: any): void {
        if (process.env.NODE_ENV === 'development') {
            const formatted = this.formatMessage('DEBUG', message, meta);
            console.debug(formatted);
            this.writeToFile('DEBUG', message, meta);
        }
    }
}
