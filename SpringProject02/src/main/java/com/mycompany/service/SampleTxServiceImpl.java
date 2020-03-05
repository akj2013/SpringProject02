package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycompany.mapper.Sample1Mapper;
import com.mycompany.mapper.Sample2Mapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/*
 * Part 5. 트랜잭션 관리
 * 트랜잭션 관련 mapper를 사용하는 인터페이스를 구현하는 클래스
 */
@Service
@Log4j
public class SampleTxServiceImpl implements SampleTxService {

	@Setter(onMethod_ = {@Autowired})
	private Sample1Mapper mapper1;
	
	@Setter(onMethod_ = {@Autowired})
	private Sample2Mapper mapper2;
	
	@Transactional
	@Override
	public void addData(String value) {
		log.info("mapper1 테스트");
		mapper1.insertCol1(value);
		
		log.info("mapper2 테스트");
		mapper2.insertCol2(value);

	}

}
