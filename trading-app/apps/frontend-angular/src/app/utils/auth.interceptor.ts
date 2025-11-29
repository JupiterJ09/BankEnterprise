import { HttpInterceptorFn } from '@angular/common/http';

/**
 * HTTP Interceptor to attach JWT tokens to outgoing requests.
 * * This function intercepts every HTTP request sent by the application.
 * If an access token exists in localStorage, it clones the request
 * and adds the 'Authorization' header with the Bearer token.
 * * @param req - The outgoing HttpRequest object.
 * @param next - The next interceptor in the chain or the backend handler.
 * @returns An Observable of the HttpEvent.
 */
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  // Retrieve the access token from local storage
  const token = localStorage.getItem('accessToken');

  // If token exists, clone the request and attach the header
  if (token) {
    const clonedRequest = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
    return next(clonedRequest);
  }

  // If no token, pass the original request without modification
  return next(req);
};