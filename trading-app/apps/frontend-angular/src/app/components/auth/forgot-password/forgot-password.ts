import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../../services/auth';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './forgot-password.html',
  styleUrl: './forgot-password.scss'
})
export class ForgotPasswordComponent {
  forgotForm: FormGroup;
  isSubmitting = false;
  isSuccess = false; // Controla si mostramos el mensaje de éxito

  constructor(
    private fb: FormBuilder,
    private authService: AuthService
  ) {
    this.forgotForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]]
    });
  }

  onSubmit() {
    if (this.forgotForm.valid) {
      this.isSubmitting = true;
      const { email } = this.forgotForm.value;

      this.authService.recoverPassword(email).subscribe({
        next: () => {
          this.isSubmitting = false;
          this.isSuccess = true; // Cambiamos a la vista de éxito
        },
        error: () => {
          this.isSubmitting = false;
          // En este caso simulado no debería fallar, pero manejamos el error
        }
      });
    } else {
      this.forgotForm.markAllAsTouched();
    }
  }
}