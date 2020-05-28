package com.mycompany.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import com.mycompany.exception.UnauthorizedException;
import com.mycompany.service.MemberService;

public class JwtInterceptor implements HandlerInterceptor {

	private static final String HEADER_AUTH = "Authorization";

	@Autowired
	private MemberService service;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		final String token = request.getHeader(HEADER_AUTH);
	
		if (token != null && service.isUsable(token)) {
			return true;
		} else {
			throw new UnauthorizedException();
		}
		
	}
}
