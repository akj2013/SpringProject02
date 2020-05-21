package com.mycompany.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.mycompany.domain.BoardAttachVO;
import com.mycompany.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/**
 * 첨부파일 중에 잘못 업로드된 파일이 있는지 확인하여 수정하는 클래스.
 * 
 * @author akjak
 *
 */
@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = { @Autowired })
	private BoardAttachMapper attachMapper;

	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	@Scheduled(cron="0 0 2 * * *") // cron : 주기를 제어하는 속성. 매분 0초마다 한 번씩 실행되도록 설정 매시간 0분마다, 매일 2시마다?
	// cron 설정 : 순서대로 초,분,시간,일,월,day of week(1~7)
	public void checkFiles() throws Exception {

		log.warn("File Chek Task 시작");
		log.warn("====================");
		log.warn(new Date());
		// file list in database
		// 어제 등록된 파일을 모두 가져온다.
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();

		// ready for check file in directroy with database file list
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName())).collect(Collectors.toList());

		// image file has thumnail file
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName())).forEach(p -> fileListPaths.add(p));

		log.warn("====================");

		fileListPaths.forEach(p -> log.warn(p));

		// files in yesterday directory
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();

		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);

		log.warn("====================");

		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}
