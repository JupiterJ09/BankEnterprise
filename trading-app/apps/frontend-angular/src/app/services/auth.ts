import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, map } from 'rxjs';
import { User } from '@trading-app/types';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})

export class AuthService {
  private readonly apiUrl = 'http://localhost:3000';
  private currentUserSubject = new BehaviorSubject<User | null>(null);
  public currentUser$ = this.currentUserSubject.asObservable();
  
  constructor(
    private http: HttpClient,
    private router: Router
  ){
    this.loadUserFromStorage();
  }

  private loadUserFromStorage(): void {
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser){
      this.currentUserSubject.next(JSON.parse(savedUser));
    }
  }
  /**
   * Simulates a Login request.
   * Since json-server doesn't have real auth logic, we query the users array
   * to find a match for the email.
   * * @param email - User's email
   * @param password - User's password
   * @returns Observable with the User object if found
   */
  login(email: string, password: string): Observable<User> {
    // In a real backend, this would be a POST to /auth/login
    // Here we simulate it by filtering the mock database
    return this.http.get<User[]>(`${this.apiUrl}/users?email=${email}`).pipe(
      map(users => {
        const user = users[0]; // Get the first match
        
        // Simple mock validation (In production, backend validates hash)
        if (user && user.passwordHash === 'hashed_secret') { // Mock password check
          this.saveSession(user);
          return user;
        } else {
          throw new Error('Invalid credentials');
        }
      })
    );
  }

  /**
   * Registers a new user in the Mock Database.
   * * @param user - The User object to create
   * @returns Observable of the created User
   */
  register(user: Omit<User, 'id'>): Observable<User> {
    return this.http.post<User>(`${this.apiUrl}/users`, user).pipe(
      map(newUser => {
        this.saveSession(newUser);
        return newUser;
      })
    );
  }

  /**
   * Clears the session and redirects to Login.
   */
  logout(): void {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('currentUser');
    this.currentUserSubject.next(null);
    this.router.navigate(['/login']);
  }

  /**
   * Helper to save user data and a fake token to LocalStorage.
   * @param user - The user to save
   */
  private saveSession(user: User): void {
    // Mock Token Generation (In real app, backend sends this)
    const mockToken = `fake-jwt-token-${user.id}-${Date.now()}`;
    
    localStorage.setItem('accessToken', mockToken);
    localStorage.setItem('currentUser', JSON.stringify(user));
    
    // Broadcast the new user to the app
    this.currentUserSubject.next(user);
  }

  /**
   * Returns true if a user is currently logged in.
   */
  isAuthenticated(): boolean {
    return this.currentUserSubject.value !== null;
  }

  recoverPassword(email: string): Observable<boolean> {
    return new Observable(observer => {
      setTimeout(() => {
        observer.next(true);
        observer.complete();
      }, 1500);
    });
  }

  updateProfile(userId: string, data: Partial<User>): Observable<User> {
    return this.http.patch<User>(`${this.apiUrl}/users/${userId}`, data).pipe(
      map(updatedUser => {
        const currentUser = this.currentUserSubject.value;
        const mergedUser = { ...currentUser, ...updatedUser } as User;
        this.saveSession(mergedUser);
        return mergedUser;
      })
    );
  }
}
