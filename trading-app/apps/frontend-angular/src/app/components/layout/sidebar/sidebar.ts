import { Component } from '@angular/core';
import { ThemeService } from '../../../services/theme';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './sidebar.html',
  styleUrl: './sidebar.scss',
})
export class SidebarComponent {
  //service 
  constructor(public themeService: ThemeService) {}

  // This function will be called by the HTML when you click the switch
  toggleTheme() {
    this.themeService.toggleTheme();
  }
}
