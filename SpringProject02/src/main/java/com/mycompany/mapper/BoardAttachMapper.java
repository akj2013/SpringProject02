package com.mycompany.mapper;

import java.util.List;

import com.mycompany.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	// 특정 게시물의 번호로 첨부파일을 찾는 처리.
	public List<BoardAttachVO> findByBno(Long bno);
}
