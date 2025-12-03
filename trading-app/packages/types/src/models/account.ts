// packages/types/src/models/account.ts
import { AccountType, AccountStatus } from '../enums';

export interface Account {
  id: string;
  userId: string;
  accountNumber: string;
  accountType: AccountType;
  balance: number;
  currency: string;
  status: AccountStatus;
  interestRate: number | null;
  createdAt: string;
  updatedAt: string;
}