package com.mycompany.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;

	private int replyCnt;

	// 게시글을 등록할 때 첨부파일도 함께 등록할 수 있도록 인스턴스를 추가한다.
	private List<BoardAttachVO> attachList;
}
