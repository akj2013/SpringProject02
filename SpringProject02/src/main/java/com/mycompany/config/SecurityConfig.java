package com.mycompany.config;

import java.security.AuthProvider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

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

		http.csrf().disable();

		http.formLogin()
			.loginPage("/")
			.loginPage("/login")
			.loginProcessingUrl("/spring/auth/login-processing")
			.failureUrl("/spring/auth/login-error")
			.defaultSuccessUrl("/spring/home", true)
			.usernameParameter("id")
			.passwordParameter("password");

		http.logout();

		http.authenticationProvider((AuthenticationProvider) authProvider);
	}
}
