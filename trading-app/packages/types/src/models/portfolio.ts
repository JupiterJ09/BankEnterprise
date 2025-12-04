/**
 * @module @trading-app/types/models/portfolio
 */

/**
 * Posición individual en el portfolio
 */
export interface PortfolioPosition {
  /** UUID v4 */
  id: string;
  /** FK a User.id */
  userId: string;
  /** FK a Stock.symbol */
  symbol: string;
  /** Cantidad (integer - siempre > 0) */
  quantity: number;
  /** Precio promedio de compra (decimal 10,4) */
  averageBuyPrice: number;
  /** Precio actual (decimal 10,4 - actualizado en tiempo real) */
  currentPrice: number;
  /** Costo total (decimal 15,2 - quantity * averageBuyPrice) */
  totalCost: number;
  /** Valor actual (decimal 15,2 - quantity * currentPrice) */
  currentValue: number;
  /** Ganancia/Pérdida no realizada (decimal 15,2 - puede ser negativo) */
  unrealizedPnL: number;
  /** Porcentaje de ganancia/pérdida (decimal 6,2) */
  unrealizedPnLPercent: number;
  /** Última actualización (ISO 8601 UTC) */
  updatedAt: string;
}

/**
 * Resumen completo del portfolio
 */
export interface PortfolioSummary {
  /** FK a User.id */
  userId: string;
  /** Valor total del portfolio (decimal 15,2) */
  totalValue: number;
  /** Efectivo disponible (decimal 15,2) */
  cashBalance: number;
  /** Valor invertido en acciones (decimal 15,2) */
  investedValue: number;
  /** Ganancia/pérdida total (decimal 15,2) */
  totalPnL: number;
  /** Porcentaje total de ganancia/pérdida (decimal 6,2) */
  totalPnLPercent: number;
  /** Array de posiciones */
  positions: PortfolioPosition[];
  /** Diversificación por sector {sector: porcentaje} */
  diversification: Record<string, number>;
  /** Última actualización (ISO 8601 UTC) */
  updatedAt: string;
}
