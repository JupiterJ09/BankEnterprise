import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Account } from '@trading-app/types';

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
}
