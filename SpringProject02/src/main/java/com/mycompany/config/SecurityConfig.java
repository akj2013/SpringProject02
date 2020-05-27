package com.mycompany.config;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

import com.mycompany.controller.AuthProvider;

@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	AuthProvider authProvider;

	// 자바스크립트나 리소스 파일을 무시한다.
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/spring/resources/**");
	}

	@Override
	public void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
			.antMatchers("/spring/auth/user").access("ROLE_USER")
			.antMatchers("/spring/auth/admin").access("ROLE_ADMIN")
			.antMatchers("/", "/spring/auth/login", "/spring/auth/login-error", "/spring/auth/all").permitAll()
			.antMatchers("/spring/**").authenticated();

		// CROF 설정을 해제한다.
		http.csrf().disable();

		// 로그인 처리
		http.formLogin()
			.loginPage("/spring/auth")
			.loginPage("/spring/auth/login") // 해당 페이지에서 로그인을 실행한다.
			.loginProcessingUrl("/spring/auth/login-processing") // 로그인 버튼을 누를 시 해당 경로로 이동한다.
			.failureUrl("/spring/auth/login-error") // 로그인 실패할 경우 해당 경로로 이동한다.
			.defaultSuccessUrl("/spring/home", true) // 로그인 성공할 경우 해당 경로로 이동한다.
			.usernameParameter("username") // 아이디 파라미터
			.passwordParameter("password"); // 비밀번호 파라미터

		http.logout();

		http.authenticationProvider(authProvider);
	}
}
