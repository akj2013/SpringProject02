package com.mycompany.mapper;

import java.util.List;

import com.mycompany.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	/** 특정 게시물의 번호로 첨부파일을 찾는 처리. */
	public List<BoardAttachVO> findByBno(Long bno);
	/** 특정 게시물의 번호로 첨부파일을 삭제하는 처리. */
	public void deleteAll(Long bno);
	/** 데이터베이스에서 어제 등록된 모든 파일의 목록을 가져올 때 쓰는 처리. */
	public List<BoardAttachVO> getOldFiles();
}
