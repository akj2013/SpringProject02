package com.mycompany.service;

import java.util.List;

import com.mycompany.domain.Criteria;
import com.mycompany.domain.ReplyPageDTO;
import com.mycompany.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO vo);
	public ReplyVO get(Long rno);
	public int modify(ReplyVO vo);
	public int remove(Long rno);
	public List<ReplyVO> getList(Criteria cri, Long bno);
	public int getReplyCount(Long bno);
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
}
