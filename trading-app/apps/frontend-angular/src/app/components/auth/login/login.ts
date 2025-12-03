import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../../services/auth'; // Importar servicio

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './login.html',
  styleUrl: './login.scss'
})
export class LoginComponent {
  loginForm: FormGroup;
  isSubmitting = false;
  errorMessage: string | null = null;

  constructor(
    private fb: FormBuilder,
    private router: Router,
    private authService: AuthService // Inyectar servicio
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }

  onSubmit() {
    if (this.loginForm.valid) {
      this.isSubmitting = true;
      this.errorMessage = null;

      const { email, password } = this.loginForm.value;

      // LLAMADA REAL AL SERVICIO
      this.authService.login(email, password).subscribe({
        next: (user) => {
          console.log('Bienvenido:', user.firstName);
          this.router.navigate(['/dashboard']);
        },
        error: (err) => {
          console.error('Error:', err);
          this.errorMessage = 'Usuario no encontrado o contraseña incorrecta.';
          this.isSubmitting = false;
        }
      });

    } else {
      this.loginForm.markAllAsTouched();
    }
  }
}