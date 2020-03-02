package com.mycompany.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycompany.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.mycompany.config.RootConfig.class})
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_ = {@Autowired})
	private BoardService service;

//	@Test
//	public void testExist() {
//		log.info("testExist()");
//		log.info(service);
//		assertNotNull(service);
//	}
//
//	@Test
//	public void testRegister() {
//
//		BoardVO board = new BoardVO();
//		board.setTitle("new title");
//		board.setContent("new Content");
//		board.setWriter("new Writer");
//
//		service.register(board);
//
//		log.info("new Bno : " + board.getBno());
//	}

//	@Test
//	public void testGetList() {
//		service.getList().forEach(board -> log.info(board));
//	}
	
//	@Test
//	public void testGet() {
//		log.info("testGet()");
//		log.info(service.get(101L));
//	}
//	
//	@Test
//	public void testDelete() {
//		log.info("REMOVE RESULT : " + service.remove(103L));
//	}
//	
//	@Test
//	public void testUpdate() {
//		BoardVO board = service.get(105L);
//		
//		if(board == null) {
//			return;
//		}
//		
//		board.setTitle("update title");
//		log.info("MODIFY RESULT : " + service.modify(board));
//	}
	
	@Test
	public void testGetList() {
		service.getList(new Criteria(2,10)).forEach(board -> log.info(board));
	}
}
