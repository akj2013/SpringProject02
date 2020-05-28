package com.mycompany.domain;

import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Data;

/**
 * 로그인 유저 객체 VO이다.
 * 
 * @author akjak
 *
 */
@Data
public class MemberVO {

	String username;
	String password;
}
