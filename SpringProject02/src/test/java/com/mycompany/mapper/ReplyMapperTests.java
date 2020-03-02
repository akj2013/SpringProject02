package com.mycompany.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycompany.domain.Criteria;
import com.mycompany.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.mycompany.config.RootConfig.class})
@Log4j
public class ReplyMapperTests {

	@Setter(onMethod_= @Autowired)
	private ReplyMapper mapper;
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(1, 10);
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 204L);
		replies.forEach(reply -> log.info(reply));
	}
}
