package com.mycompany.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {

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
