package com.mycompany.domain;

import lombok.Data;
/**
 * 첨부파일 정보를 가지고 있는 테이블의 VO
 * 테이블 : tbl_attach
 * 
 * @author akjak
 *
 */
@Data
public class BoardAttachVO {

	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private Long bno;
}
