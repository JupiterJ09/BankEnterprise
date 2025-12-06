import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Account, Transaction} from '@trading-app/types';

@Injectable({
  providedIn: 'root',
})
export class AccountService {
  private readonly apiUrl = 'http://localhost:3000';

  constructor(private http: HttpClient){}

  getAccounts(userId: string): Observable<Account[]>{
    return this.http.get<Account[]>(`${this.apiUrl}/accounts?userId=${userId}`);
  }
  
  getAccountById(accountId: string): Observable<Account>{
    return this.http.get<Account>(`${this.apiUrl}/accounts/${accountId}`);
  }

  getTransactions(accountId: string): Observable<Transaction[]> {
    // _sort y _order son trucos de json-server para ordenar por fecha
    return this.http.get<Transaction[]>(
      `${this.apiUrl}/transactions?accountId=${accountId}&_sort=createdAt&_order=desc`
    );
  }
}
