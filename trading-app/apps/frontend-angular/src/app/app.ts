import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet], // Solo necesitamos el RouterOutlet
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  // No necesitas lógica aquí por ahora
}