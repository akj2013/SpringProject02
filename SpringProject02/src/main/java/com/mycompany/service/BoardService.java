package com.mycompany.service;

import java.util.List;

import com.mycompany.domain.BoardAttachVO;
import com.mycompany.domain.BoardVO;
import com.mycompany.domain.Criteria;

public interface BoardService {

	public void register(BoardVO board);

	public BoardVO get(Long bno);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

//	public List<BoardVO> getList();

	public List<BoardVO> getList(Criteria cri);

	public int getTotal(Criteria cri);

	// 특정 bno를 파라미터로 첨부파일을 리스트로 가져온다.
	public List<BoardAttachVO> getAttachList(Long bno);
}
