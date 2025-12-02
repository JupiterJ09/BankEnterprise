import { Routes } from '@angular/router';
import { DashboardLayoutComponent } from './components/layout/dashboard-layout/dashboard-layout';
import { LoginComponent } from './components/auth/login/login';
import { authGuard } from './guards/auth-guard';
import { RegisterComponent } from './components/auth/register/register';
import { ForgotPasswordComponent} from './components/auth/forgot-password/forgot-password';
/**
 * Main Application Routes Configuration.
 * * Defines the navigation structure. The DashboardLayoutComponent acts as the
 * main shell (Sidebar + Header), and child views will be rendered inside it.
 */

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full'
  },
  {
    path: 'login',
    component: LoginComponent
  },
  { 
    path: 'register', 
    component: RegisterComponent 
  },
  { 
    path: 'forgot-password', 
    component: ForgotPasswordComponent 
  },
  {
    path: 'dashboard', 
    component: DashboardLayoutComponent,
    canActivate: [authGuard],
    children: [
    ]
  },
  {
    path: '**',
    redirectTo: 'login'
  }
];