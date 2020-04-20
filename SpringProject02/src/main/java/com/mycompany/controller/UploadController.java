package com.mycompany.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mycompany.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

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
	
//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxAction(MultipartFile[] uploadFile) {
//		String uploadFolder = "C:\\upload";
//		// 결과 로그 출력을 위한 변수 생성
//		int successedFileCount = uploadFile.length;
//		int failedFileCount = 0;
//		
//		// 업로드 폴더 생성
//		File uploadPath = new File(uploadFolder, getFolder());
//		log.info("upload path: " + uploadPath);
//		// 폴더 이름이 존재하지 않는다면, 생성한다.
//		if (uploadPath.exists() == false) {
//			boolean makeFolder = uploadPath.mkdirs();
//			if (makeFolder) {
//				log.info("오늘 날짜의 새로운 폴더를 생성하였습니다." + uploadPath.getName()); 
//			}
//		}
//		
//		for (MultipartFile multipartFile : uploadFile) {
//			log.info("----------------------------------");
//			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
//			log.info("Upload File Size : " + multipartFile.getSize() + "bytes");
//			
//			String uploadFileName = multipartFile.getOriginalFilename();
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
//			log.info("only file name : " + uploadFileName);
//			
//			// 중복되는 이름을 방지하기 위한 UUID 적용
//			UUID uuid = UUID.randomUUID();
//			uploadFileName = uuid.toString() + "_" + uploadFileName;
//			
//			// File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
//			// 새로 생성된 폴더에 파일을 저장한다.
//			
//			try {
//				File saveFile = new File(uploadPath, uploadFileName);
//				multipartFile.transferTo(saveFile);
//				// 이미지 파일 체크
//				if (checkImageType(saveFile)) {
//					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName)); // 섬네일의 경우에는 '_s'로 시작한다.
//					// 섬네일 이미지 파일 생성
//					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 150, 100); // width, height 순
//					thumbnail.close();
//				}
//			} catch (Exception e) {
//				log.error(e.getMessage());
//				failedFileCount += 1; // 실패한 경우, 하나씩 더해준다.
//				successedFileCount -= 1; // 성공한 경우, 하나씩 빼준다.
//			} finally {
//			}
//			// 결과 로그 출력
//			log.info("TOTAL : " + uploadFile.length + "건, " + "SUCCESS : " + successedFileCount + "건, " + "FAIL : " + failedFileCount + "건");
//		}
//	}
	
	/**
	 * 중복된 이름의 첨부파일 처리 </br>
	 * 파일 이름이 중복되지 않도록 처리하는 방법으로, 현재 시간을 폴더 이름으로 사용하기 위해 </br>
	 * 새롭게 생성한 폴더 이름을 반환한다.
	 * @return FolderName
	 */
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator); // separator = /
	}

	/**
	 * 특정한 파일이 이미지 타입인지를 검사하는 메서드
	 * @param file
	 * @return true : 이미지 파일, false : 이미지 파일 이외
	 */
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 업로드된 파일의 정보를 브라우저로 전송한다.
	 * 1. 업로드된 파일의 이름과 원본 파일의 이름
	 * 2. 파일이 저장된 경로
	 * 3. 업로드된 파일이 이미지인지 아닌지에 대한 정보
	 * 
	 * @param uploadFile
	 * @return JSON data
	 */
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody // 리턴 바디가 존재한다.
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";

		// 결과 로그 출력을 위한 변수 생성
		int successedFileCount = uploadFile.length;
		int failedFileCount = 0;

		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		// 생성한 경로의 폴더가 존재하지 않는다면, 폴더를 신규생성
		if (uploadPath.exists() == false) {
			if (uploadPath.mkdirs()) {
				log.info("오늘 날짜의 새로운 폴더를 생성하였습니다." + uploadPath.getName()); 
			}
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			String uploadFileName = multipartFile.getOriginalFilename();
			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("||") + 1);
			log.info("only file name : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 저장한 첨부파일이 이미지 파일이라면, 섬네일을 생성하여 반환한다.
				if (checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 150, 100);
					thumbnail.close();
				}
				list.add(attachDTO);
			} catch (Exception e) {
				failedFileCount += 1; // 실패한 경우, 하나씩 더해준다.
				successedFileCount -= 1; // 성공한 경우, 하나씩 빼준다.
				e.printStackTrace();
			}
		}
		// 결과 로그 출력
		log.info("TOTAL : " + uploadFile.length + "건, " + "SUCCESS : " + successedFileCount + "건, " + "FAIL : " + failedFileCount + "건");
		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	/**
	 * 특정한 파일 이름을 받아서 이미지 데이터를 전송한다.</br>
	 * 문자열로 파일의 경로가 포함된 파라미터를 받아 byte[]를 전송한다.
	 * 
	 * @param fileName
	 * @return ResponseEntity<byte[]> result
	 */
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("display fileName : " + fileName);
		File file = new File("c:\\upload\\" + fileName);
		log.info("file : " + file);
		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();
			/* 브라우저에 보내는 MIME 타입이 파일의 종류에 따라 달라질 수 있도록 'probeContentType'을 이용한다.
			* MIME : Multipurpose Internet Mail Extensions
			* 이메일과 함께 동봉할 파일을 텍스트 문자로 전환해서 이메일 시스템을 통해 전달하기 위해 사용하는 인코딩 타입.
			*/
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
}
