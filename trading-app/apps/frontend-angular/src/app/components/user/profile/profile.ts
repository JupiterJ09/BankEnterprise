import { Component, OnInit} from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder,FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../../services/auth';
import { User } from '@trading-app/types';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './profile.html',
  styleUrl: './profile.scss',
})
export class ProfileComponent implements OnInit {
  user: User | null = null;
  profileForm: FormGroup;
  activeTab: 'personal' | 'security' = 'personal';
  isEditing = false;

  constructor(
    private authService: AuthService,
    private fb: FormBuilder
  ){
    this.profileForm = this.fb.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: [{ value: '', disable: true }],
      phone: [''],
      bio: ['']
    });
  }

  ngOnInit(): void {
    this.authService.currentUser$.subscribe(user => {
      if (user){
        this.user = user;
        this.profileForm.patchValue({
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          phone: user.phoneNumber || ''
        });
      }
    });
  }

  /**
   * Switch between tabs (Personal Info vs Security)
   * @param tab - The tab name to activate
   */
  setActiveTab(tab: 'personal' | 'security') {
    this.activeTab = tab;
  }

  /**
   * Enables edit mode for the form
   */
  toggleEdit() {
    this.isEditing = !this.isEditing;
    if (!this.isEditing) {
      // Si cancelamos, reseteamos los valores
      this.ngOnInit(); 
    }
  }

  /**
   * Saves profile changes
   */
  saveChanges() {
    if (this.profileForm.valid && this.user) {
      // 1. Obtenemos solo los valores del form
      const updatedData = this.profileForm.value;
      
      // 2. Llamamos al servicio nuevo
      this.authService.updateProfile(this.user.id, updatedData).subscribe({
        next: (newUser) => {
          console.log('¡Guardado en DB!', newUser);
          this.isEditing = false; // Salimos del modo edición
          // No hace falta recargar, el servicio actualiza la vista automáticamente
        },
        error: (err) => {
          console.error('Error al guardar', err);
          alert('Hubo un error al guardar los cambios.');
        }
      });
    }
  }
}
