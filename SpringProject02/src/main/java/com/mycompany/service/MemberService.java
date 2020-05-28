package com.mycompany.service;

import java.util.Map;

import com.mycompany.domain.MemberVO;

public interface MemberService {

	public MemberVO login(String username, String password);

	<T> String create(String key, T data, String subject);
	Map<String, Object> get(String key);
	int getMemberId();
	boolean isUsable(String jwt);

}
