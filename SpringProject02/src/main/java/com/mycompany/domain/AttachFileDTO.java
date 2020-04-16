package com.mycompany.domain;

import lombok.Data;

/**
 * 첨부파일의 정보들을 저장한다.
 * @author akjak
 *
 */
@Data // 모든 필드의 getter를 생성한다.
public class AttachFileDTO {
	/** 파일 이름 */
	private String fileName;
	/** 저장 경로 */
	private String uploadPath;
	/** 중복 방지를 위한 덧붙인 이름 */
	private String uuid;
	/** 이미지 파일인지 아닌지 판단 */
	private boolean image;
}
