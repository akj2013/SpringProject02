package com.mycompany.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/upload/*")
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder = "C:\\upload";
		for (MultipartFile multipartFile : uploadFile) {
			log.info("----------------------------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	@PostMapping("/uploadAjaxAction")
	public void uploadAjaxAction(MultipartFile[] uploadFile) {
		String uploadFolder = "C:\\upload";
		// 결과 로그 출력을 위한 변수 생성
		int successedFileCount = uploadFile.length;
		int failedFileCount = 0;
		
		// 업로드 폴더 생성
		File uploadPath = new File(uploadFolder, getFolder());
		log.info("upload path: " + uploadPath);
		// 폴더 이름이 존재하지 않는다면, 생성한다.
		if (uploadPath.exists() == false) {
			boolean makeFolder = uploadPath.mkdirs();
			if (makeFolder) {
				log.info("오늘 날짜의 새로운 폴더를 생성하였습니다." + uploadPath.getName()); 
			}
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			log.info("----------------------------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize() + "bytes");
			
			String uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			
			// File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			// 새로 생성된 폴더에 파일을 저장한다.
			File saveFile = new File(uploadPath, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
				failedFileCount += 1; // 실패한 경우, 하나씩 더해준다.
				successedFileCount -= 1; // 성공한 경우, 하나씩 빼준다.
			} finally {
			}
			// 결과 로그 출력
			log.info("TOTAL : " + uploadFile.length + "건, " + "SUCCESS : " + successedFileCount + "건, " + "FAIL : " + failedFileCount + "건");
		}
	}
	
	/**
	 * 중복된 이름의 첨부파일 처리 </br>
	 * 파일 이름이 중복되지 않도록 처리하는 방법으로, 현재 시간을 폴더 이름으로 사용하기 위해 </br>
	 * 폴더 이름을 생성한다.
	 * @return FolderName
	 */
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator); // separator = /
	}
}
