package com.mycompany.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.mycompany.domain.Criteria;
import com.mycompany.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO vo);
	public ReplyVO read(Long bno);
	public int delete(Long rno);
	public int update(ReplyVO reply);
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno); // @Param 이 매퍼.xml의 파라미터와 매칭되어 사용된다.
	public int getReplyCount(@Param("bno") Long bno);
	public int getCountByBno(Long bno);
}
