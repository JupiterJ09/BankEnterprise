import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AccountService } from '../../../services/account';
import { Transaction } from '@trading-app/types';


@Component({
  selector: 'app-transaction-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './transaction-list.html',
  styleUrl: './transaction-list.scss',
})
export class TransactionListComponent implements OnChanges{
  @Input() accountId: string = '';

  transactions: Transaction[] = [];
  isLoading = false;

  // Variables de Paginación
  currentPage = 1;
  pageSize = 5; // Mostramos 5 por página
  paginatedTransactions: Transaction[] = [];
  totalPages = 0;

  constructor(private accountService: AccountService) {}

  // Este método se ejecuta cada vez que cambia el accountId (ej: si seleccionas otra tarjeta)
  ngOnChanges(changes: SimpleChanges): void {
    if (changes['accountId'] && this.accountId) {
      this.loadTransactions();
    }
  }

  loadTransactions() {
    this.isLoading = true;
    this.accountService.getTransactions(this.accountId).subscribe({
      next: (data) => {
        this.transactions = data;
        this.calculatePagination();
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error cargando movimientos', err);
        this.isLoading = false;
      }
    });
  }

  /* --- LÓGICA DE PAGINACIÓN --- */
  calculatePagination() {
    this.totalPages = Math.ceil(this.transactions.length / this.pageSize);
    this.updatePageData();
  }

  updatePageData() {
    const startIndex = (this.currentPage - 1) * this.pageSize;
    const endIndex = startIndex + this.pageSize;
    this.paginatedTransactions = this.transactions.slice(startIndex, endIndex);
  }

  prevPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.updatePageData();
    }
  }

  nextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.updatePageData();
    }
  }

}
