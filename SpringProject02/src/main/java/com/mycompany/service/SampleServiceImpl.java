package com.mycompany.service;

import org.springframework.stereotype.Service;

@Service
public class SampleServiceImpl implements SampleService {

	@Override
	public Integer doAdd(String srt1, String str2) throws Exception {
		return Integer.parseInt(srt1) + Integer.parseInt(str2);
	}
	
}
