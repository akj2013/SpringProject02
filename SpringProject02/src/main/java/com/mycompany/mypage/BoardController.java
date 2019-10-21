package com.mycompany.mypage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/*
 * CRUD 게시판 컨트롤러 클래스
 * [역할]
 * 		1. 게시판 화면을 호출한다.
 * 		2. DB와 연동하여 VO를 만든다.
 * 	[메소드]
 * 		1. 게시글 입력 페이지 호출
 * 		2. 입력 서비스 호출
 * 		3. 게시글 출력 페이지 호출
 * 		4. 출력 서비스 호출
 * 		5. 게시글 수정 페이지 호출
 * 		6. 수정 서비스 호출
 * 		7. 게시글 삭제 페이지 호출
 * 		8. 삭제 서비스 호출
 * 		9. 게시글 리스트 페이지 호출
 * 
 */

@Controller
@RequestMapping(value="/board")
public class BoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	/*
	 * 1. 게시글 입력 페이지 호출
	 */
	@GetMapping("/write")
	public void write() {
		System.out.println("게시글 입력 페이지를 호출합니다.");
	}
	
	/*
	 * 2. 입력 서비스 호출
	 */
	@PostMapping("/boardWrite")
	public String boardWrite() {
		System.out.println("입력 서비스를 호출합니다.");
		return "redirect:/board/list";
	}
	
	/*
	 * 9. 게시글 리스트 페이지 호출
	 */
	@GetMapping("/list")
	public void list() {
		System.out.println("게시글 리스트 페이지를 호출합니다.");
	}
}
