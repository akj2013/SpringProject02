package com.mycompany.sample;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mycompany.config.RootConfig;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) // 현재 테스트 코드가 스프링을 실행하는 역할을 할 것이다.
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class SampleTests {
	
	@Setter(onMethod_ = { @Autowired }) // 스프링 내부에서 자신이 특정한 객체에 의존적이므로 자신에게 해당 타입의 빈을 주입해주라는 표시.
	private Restaurant restaurant;
	
	@Test // JUnit에서 테스트 대상임을 표시.
	public void testExist() {
		assertNotNull(restaurant); // null이 아니어야만 테스트 성공.
		
		log.info(restaurant);
		log.info("-----------------------------------");
		log.info(restaurant.getChef());
	}
}
