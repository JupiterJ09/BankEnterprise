import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router'; 
import { ThemeService } from '../../../services/theme';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './sidebar.html', 
  styleUrl: './sidebar.scss' 
})
export class SidebarComponent {
  @Output() closeMenu = new EventEmitter<void>(); 

  constructor(public themeService: ThemeService,private router: Router) {}

  toggleTheme() {
    this.themeService.toggleTheme();
  }

  onClose() {
    this.closeMenu.emit();
  }
  logout() {
    localStorage.removeItem('accessToken');
    this.router.navigate(['/login']);
    this.onClose();
  }
}