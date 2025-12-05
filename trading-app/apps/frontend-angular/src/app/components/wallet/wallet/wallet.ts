import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AccountService } from '../../../services/account';
import { AuthService } from '../../../services/auth';
import { Account } from '@trading-app/types';

@Component({
  selector: 'app-wallet',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './wallet.html',
  styleUrl: './wallet.scss',
})
export class WalletComponent implements OnInit{

  accounts: Account[] = [];
  isLoading = true;
  totalBalance = 0;

  constructor(private accountService: AccountService, private authService: AuthService){}

  ngOnInit(): void {
    this.authService.currentUser$.subscribe(user => {
      if (user) {
        this.loadAccounts(user.id);
      }
    });
  }

  loadAccounts(userId: string) {
    this.isLoading = true;
    this.accountService.getAccounts(userId).subscribe({
      next: (data) => {
        this.accounts = data;
        this.calculateTotal();
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error cargando cuentas', err);
        this.isLoading = false;
      }
    });
  }

  calculateTotal() {
    // Sumamos el saldo de todas las cuentas
    this.totalBalance = this.accounts.reduce((acc, curr) => acc + curr.balance, 0);
  }

}
