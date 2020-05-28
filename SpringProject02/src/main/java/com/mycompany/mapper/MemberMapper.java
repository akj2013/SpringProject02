package com.mycompany.mapper;

import com.mycompany.domain.MemberVO;

public interface MemberMapper {

	/* 로그인 유저를 DB에서 검색한다. */
	public MemberVO getUser(String id);
}
