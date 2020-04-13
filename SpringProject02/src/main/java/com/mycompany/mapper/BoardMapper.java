package com.mycompany.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.mycompany.domain.BoardVO;
import com.mycompany.domain.Criteria;

public interface BoardMapper {

	// @Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
	
	public void insert(BoardVO board);
	
	public int insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public List<BoardVO> getListWithPaging(Criteria cri); // 페이징 처리
	
	public int getTotalCount(Criteria cri); // 전체 데이터 개수 처리
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount); 
}
