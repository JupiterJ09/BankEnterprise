import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from '../header/header';
import { SidebarComponent } from '../sidebar/sidebar';
import { CommonModule } from '@angular/common'; // Importante para *ngIf y [class]

@Component({
  selector: 'app-dashboard-layout',
  standalone: true,
  // Importamos los componentes que vamos a usar aquí
  imports: [CommonModule, RouterOutlet, HeaderComponent, SidebarComponent],
  templateUrl: './dashboard-layout.html',
  styleUrl: './dashboard-layout.scss'
})
export class DashboardLayoutComponent {
  // Variable para controlar el menú en celular
  isMobileMenuOpen = false;

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  // Cierra el menú cuando haces clic en el fondo oscuro (Backdrop)
  closeMobileMenu() {
    this.isMobileMenuOpen = false;
  }
}