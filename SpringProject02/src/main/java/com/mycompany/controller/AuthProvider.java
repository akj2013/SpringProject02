package com.mycompany.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import com.mycompany.domain.AuthorizationVO;
import com.mycompany.service.AuthorizationService;

public class AuthProvider implements AuthenticationProvider {

	@Autowired
	AuthorizationService service;

	// 로그인 버튼을 누를 경우
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		String id = authentication.getName();
		String pw = authentication.getCredentials().toString();
		return authenticate(id, pw);
	}

	public Authentication authenticate(String id, String pw) throws AuthenticationException {
		User user = service.login(id, pw);

		if (user == null) {
			return null;
		}

		// 롤을 추가한다.
		List<GrantedAuthority> grantedList = new ArrayList<GrantedAuthority>();
		String role = "ROLE_USER";

		grantedList.add(new SimpleGrantedAuthority(role));
		return new AuthorizationVO(id, pw, grantedList, user);
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}
