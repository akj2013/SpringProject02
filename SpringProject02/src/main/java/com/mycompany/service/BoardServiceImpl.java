package com.mycompany.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycompany.domain.BoardAttachVO;
import com.mycompany.domain.BoardVO;
import com.mycompany.domain.Criteria;
import com.mycompany.mapper.BoardAttachMapper;
import com.mycompany.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{

	// 두 개의 Mapper 인터페이스를 주입하고 호출하기 때문에
	// 자동주입 대신 Setter 메서드를 이용한다.
	@Setter(onMethod_= @Autowired)
	private BoardMapper mapper;

	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;

	@Override	
	public void register(BoardVO board) {

		log.info("register.........." + board);
		mapper.insertSelectKey(board);
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get()");
		return mapper.read(bno);
	}

	/**
	 * 게시물의 수정
	 * 첨부파일을 DB에서 먼저 모두 삭제한다.
	 * 그리고 게시물을 DB에서 수정한다.
	 * 그리고 다시 첨부파일을 삽입한다.
	 */
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify................ " + board);
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board) == 1;
		if (modifyResult && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	/**
	 * 삭제 처리
	 * 1. 해당 게시물의 첨부파일 정보를 미리 준비
	 * 2. 데이터베이스 상에서 해당 게시물과 첨부파일 데이터 삭제
	 * 3. 첨부파일 목록을 이용해서 해당 폴더에서 섬네일 이미지와 일반 파일을 삭제
	 */
	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove.... " + bno); 
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		log.info("getList()");
//		return mapper.getList();
//	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList with criteria : " + cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach List by bno" + bno);
		return attachMapper.findByBno(bno);
	}
}
