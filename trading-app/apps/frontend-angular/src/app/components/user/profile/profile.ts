import { Component, OnInit} from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder,FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../../services/auth';
import { User } from '@trading-app/types';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FormsModule],
  templateUrl: './profile.html',
  styleUrl: './profile.scss',
})
export class ProfileComponent implements OnInit {
  user: User | null = null;
  profileForm: FormGroup;
  activeTab: 'personal' | 'security' = 'personal';
  isEditing = false;


  showQrCode = false;
  twoFaCode: string = '';
  isTwoFaEnabled = false;

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
        this.isTwoFaEnabled = user.twoFactorEnabled;

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
      this.ngOnInit(); 
    }
  }

  /**
   * Saves profile changes
   */
  saveChanges() {
    if (this.profileForm.valid && this.user) {
      const updatedData = this.profileForm.value;
      this.authService.updateProfile(this.user.id, updatedData).subscribe({
        next: (newUser) => {
          console.log('¡Guardado en DB!', newUser);
          this.isEditing = false;
        },
        error: (err) => {
          console.error('Error al guardar', err);
          alert('Hubo un error al guardar los cambios.');
        }
      });
    }
  }

  initiateTwoFaSetup() {
    this.showQrCode = true;
    this.twoFaCode = ''; 
  }

  cancelTwoFaSetup() {
    this.showQrCode = false;
    this.twoFaCode = '';
  }

  verifyTwoFaCode() {
    // accept anywhere code 
    if (this.twoFaCode.length === 6 && this.user) {
      console.log('Verificando código 2FA:', this.twoFaCode);
      
      this.authService.updateProfile(this.user.id, { twoFactorEnabled: true }).subscribe(() => {
        this.isTwoFaEnabled = true;
        this.showQrCode = false; 
        alert('¡Seguridad 2FA Activada con Éxito!');
      });
    } else {
      alert('El código debe tener 6 dígitos.');
    }
  }

  disableTwoFa() {
    if (confirm('¿Seguro que quieres desactivar la seguridad extra?') && this.user) {
      this.authService.updateProfile(this.user.id, { twoFactorEnabled: false }).subscribe(() => {
        this.isTwoFaEnabled = false;
      });
    }
  }
}
