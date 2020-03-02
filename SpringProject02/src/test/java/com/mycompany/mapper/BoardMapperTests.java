package com.mycompany.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycompany.domain.BoardVO;
import com.mycompany.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.mycompany.config.RootConfig.class})
@Log4j
public class BoardMapperTests {

	@Setter(onMethod_= @Autowired)
	private BoardMapper mapper;
	/*
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
	}*/
/*
	@Test
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글입니당.222");
		board.setContent("테스트로 insert를 넣어보는 메서드입니다.222");
		board.setWriter("192페이지");
		
		//mapper.insert(board);
		mapper.insertSelectKey(board);
		
		log.info(board);
	}
	*/
//	@Test
//	public void testRead() {
//		// 존재하는 게시물 번호로 테스트
//		BoardVO board = mapper.read(25L);
//		log.info(board);
//	}
//	
//	@Test
//	public void testDelete() {
//		// log.info("DELETE COUNT : " + mapper.delete(41L)); 
//	}
//
//	@Test
//	public void testUpdate() {
//		BoardVO board = new BoardVO();
//		board.setBno(25L);
//		board.setTitle("변경된 제목1");
//		board.setContent("변경된 콘텐츠1");
//		board.setWriter("변경된 유1저");
//		
//		int count = mapper.update(board);
//		log.info("UPDATE COUNT : " + count);
//	}
//	@Test
//	public void testPaging() {
//		
//		Criteria cri = new Criteria();
//		
//		cri.setPageNum(3);
//		cri.setAmount(10);
//		
//		List<BoardVO> list = mapper.getListWithPaging(cri);
//		
//		list.forEach(board -> log.info(board.getBno()));
//	}
	@Test
	public void testSearch() {
		Criteria cri = new Criteria();
		cri.setKeyword("새로");
		cri.setType("TC");
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));
	}
}
