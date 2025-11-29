import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from './utils/auth.interceptor';
import { routes } from './app.routes';

/**
 * Global application configuration.
 * Defines providers available globally (Standalone mode).
 */
export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),

    // 2. Ahora sí funcionará esto porque ya lo importamos arriba:
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
};