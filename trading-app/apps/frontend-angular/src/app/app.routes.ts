import { Routes } from '@angular/router';
import { DashboardLayoutComponent } from './components/layout/dashboard-layout/dashboard-layout';

/**
 * Main Application Routes Configuration.
 * * Defines the navigation structure. The DashboardLayoutComponent acts as the
 * main shell (Sidebar + Header), and child views will be rendered inside it.
 */

export const routes: Routes = [
  {
    path: '', 
    component: DashboardLayoutComponent,
    children: [
    ]
  },
  {
    
    path: '**',
    redirectTo: ''
  }
];