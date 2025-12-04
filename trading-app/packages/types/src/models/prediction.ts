/**
 * @module @trading-app/types/models/prediction
 */

import { PredictionDirection } from '../enums';

/**
 * Predicción de precio generada por ML
 */
export interface StockPrediction {
  /** FK a Stock.symbol */
  symbol: string;
  /** Fecha de la predicción (ISO 8601 date) */
  predictionDate: string;
  /** Precio predicho (decimal 10,4) */
  predictedPrice: number;
  /** Nivel de confianza (decimal 5,4 - rango 0.0 a 1.0) */
  confidence: number;
  /** Dirección de la predicción */
  direction: PredictionDirection;
  /** Fecha objetivo de la predicción (ISO 8601 date) */
  targetDate: string;
  /** Nombre del modelo ML usado (RandomForest, LSTM, etc.) */
  model: string;
  /** Features usadas {nombreFeature: valor} */
  features: Record<string, any>;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
}
