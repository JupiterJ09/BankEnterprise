import { Routes } from '@angular/router';
import { DashboardLayoutComponent } from './components/layout/dashboard-layout/dashboard-layout';
import { LoginComponent } from './components/auth/login/login';
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
    path: 'dashboard', 
    component: DashboardLayoutComponent,
    children: [
    ]
  },
  {
    
    path: '**',
    redirectTo: 'login'
  }
];