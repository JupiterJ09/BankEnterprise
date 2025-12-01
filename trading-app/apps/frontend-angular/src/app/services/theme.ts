import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private darkMode = false;

  constructor() {
    // 1. Al iniciar, revisamos si el usuario ya tenía una preferencia guardada
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
      this.enableDarkMode();
    }
  }

  isDarkMode(): boolean {
    return this.darkMode;
  }

  toggleTheme() {
    if (this.darkMode) {
      this.disableDarkMode();
    } else {
      this.enableDarkMode();
    }
  }

  private enableDarkMode() {
    this.darkMode = true;
    document.body.classList.add('dark-theme'); // Agrega la clase al body
    localStorage.setItem('theme', 'dark');     // Guarda en memoria
  }

  private disableDarkMode() {
    this.darkMode = false;
    document.body.classList.remove('dark-theme'); // Quita la clase
    localStorage.setItem('theme', 'light');
  }
}