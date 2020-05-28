package com.mycompany.controller;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.domain.MemberVO;
import com.mycompany.domain.Result;
import com.mycompany.service.MemberService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/member")
@Log4j
public class MemberController {

	@Autowired
	private MemberService service;

	@PostMapping(value="/signin")
	public Result signin(String username, String password, HttpServletResponse response) {
		Result result = Result.successInstance();
		MemberVO loginMember = service.login(username, password);
		String token = service.create("member", loginMember, "user");
		response.setHeader("Authorization", token);
		result.setData(loginMember);
		return result;
	}
	
	@GetMapping("/user")
	public void user() {
		log.info("유저 권한을 가진 사람이 접근할 수 있습니다.");
	}

	@GetMapping("/admin")
	public void admin() {
		log.info("관리자 권한을 가진 사람이 접근할 수 있습니다.");
	}

	@GetMapping("/login")
	public void login() {
		log.info("로그인 페이지에 접근합니다.");
	}

	@GetMapping("/login-error")
	public void loginFail() {
		log.info("로그인에 실패하였습니다.");
	}
}
