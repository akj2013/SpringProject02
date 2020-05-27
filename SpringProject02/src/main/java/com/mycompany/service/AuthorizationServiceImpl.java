package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;

import com.mycompany.domain.AuthorizationVO;
import com.mycompany.mapper.AuthorizationMapper;

import lombok.extern.log4j.Log4j;

@Log4j
public class AuthorizationServiceImpl implements AuthorizationService {

	@Autowired
	AuthorizationMapper mapper;
	
	@Override
	public User login(String id, String pw) {
		User user = mapper.getUser(id);
		if (user == null) {
			log.warn("해당 하는 아이디가 존재하지 않습니다.");
			return null;
		}
		if (user.getPassword().equals(pw) == false) {
			log.warn("비밀번호가 일치하지 않습니다.");
			return null;
		}
		return user;
	}

	@Override
	public User getCurrentUser() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication instanceof AuthorizationVO) {
			return ((AuthorizationVO) authentication).getUser();
		}
		return null;
	}

	/**
	 * 현재 로그인한 객체를 저장한다.
	 */
	@Override
	public void setCurrentUser(User user) {
		((AuthorizationVO) SecurityContextHolder.getContext().getAuthentication()).setUser(user);
	}

}
