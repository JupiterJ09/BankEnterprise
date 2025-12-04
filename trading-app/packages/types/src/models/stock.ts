/**
 * @module @trading-app/types/models/stock
 */

import { Exchange } from '../enums';

/**
 * Acción del mercado
 */
export interface Stock {
  /** PRIMARY KEY - uppercase: AAPL, TSLA, AMZN */
  symbol: string;
  /** Nombre completo (max 100 caracteres): Apple Inc. */
  name: string;
  /** Bolsa donde cotiza */
  exchange: Exchange;
  /** Sector (Technology, Finance, Healthcare, etc.) */
  sector: string;
  /** Precio actual (decimal 10,4) */
  currentPrice: number;
  /** Cierre anterior (decimal 10,4) */
  previousClose: number;
  /** Cambio porcentual (decimal 6,2) */
  changePercent: number;
  /** Volumen de operaciones */
  volume: number;
  /** Capitalización de mercado */
  marketCap: number | null;
  /** Última actualización (ISO 8601 UTC) */
  lastUpdated: string;
}

/**
 * Historial de precios OHLCV
 * OHLCV = Open, High, Low, Close, Volume
 */
export interface StockPriceHistory {
  /** FK a Stock.symbol */
  symbol: string;
  /** Timestamp del dato (ISO 8601 UTC) */
  timestamp: string;
  /** Precio de apertura (decimal 10,4) */
  open: number;
  /** Precio máximo (decimal 10,4) */
  high: number;
  /** Precio mínimo (decimal 10,4) */
  low: number;
  /** Precio de cierre (decimal 10,4) */
  close: number;
  /** Volumen */
  volume: number;
  /** Cierre ajustado (decimal 10,4) */
  adjustedClose: number | null;
}

/**
 * Indicadores técnicos de una acción
 */
export interface TechnicalIndicators {
  /** FK a Stock.symbol */
  symbol: string;
  /** Timestamp (ISO 8601 UTC) */
  timestamp: string;
  /** Relative Strength Index (0-100) */
  rsi: number | null;
  /** Moving Average Convergence Divergence */
  macd: number | null;
  /** MACD Signal */
  macdSignal: number | null;
  /** Simple Moving Average 20 días */
  sma20: number | null;
  /** Simple Moving Average 50 días */
  sma50: number | null;
  /** Simple Moving Average 200 días */
  sma200: number | null;
  /** Exponential Moving Average 12 días */
  ema12: number | null;
  /** Exponential Moving Average 26 días */
  ema26: number | null;
  /** Banda superior de Bollinger */
  bollingerUpper: number | null;
  /** Banda media de Bollinger */
  bollingerMiddle: number | null;
  /** Banda inferior de Bollinger */
  bollingerLower: number | null;
  /** Average True Range */
  atr: number | null;
  /** Volumen */
  volume: number;
}
