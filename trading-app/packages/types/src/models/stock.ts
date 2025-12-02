// packages/types/src/models/stock.ts

export interface Stock {
  symbol: string;
  name: string;
  exchange: string;
  sector: string;
  currentPrice: number;
  previousClose: number;
  changePercent: number;
  volume: number;
  marketCap: number | null;
  lastUpdated: string;
}