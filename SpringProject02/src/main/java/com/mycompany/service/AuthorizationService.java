package com.mycompany.service;

import org.springframework.security.core.userdetails.User;

public interface AuthorizationService {

	public User login(String username, String password);

	public User getCurrentUser();

	public void setCurrentUser(User user);
}
