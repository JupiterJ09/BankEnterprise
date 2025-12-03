import { CanActivateFn, Router } from '@angular/router';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth';

/**
 * AuthGuard (Functional Guard)
 * Protects routes from unauthenticated access.
 * * Logic:
 * 1. Check if user is logged in via AuthService.
 * 2. If YES -> Allow access (return true).
 * 3. If NO -> Redirect to /login and block access (return false).
 */
export const authGuard: CanActivateFn = (route, state) => {
  // Inyectamos los servicios necesarios (Angular 17 style)
  const authService = inject(AuthService);
  const router = inject(Router);

  if (authService.isAuthenticated()) {
    return true; // Pase usted, jefe.
  } else {
    // ¡Alto ahí! No tienes credenciales.
    router.navigate(['/login']);
    return false;
  }
};