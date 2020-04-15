<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Upload With Ajax</h1>
	<div class='uploadDiv'>
		<input type = 'file' name = 'uploadFile' multiple>
	</div>
	<button id='uploadBtn'>Upload</button>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"
		integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
		crossorigin="anonymous"></script>
	
	<script>
	/* 아래 새로운 처리를 위해 코멘트 아웃
		$(document).ready(function(){
			$("#uploadBtn").on("click",function(e) {
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				console.log(files);
				
				// add filedate to formdata
				for(var i=0; i<files.length;i++) {
					formData.append("uploadFile",files[i]);
				}
				
				$.ajax({
					url : 'uploadAjaxAction',
						processData: false,
						contentType: false,
						data: formData,
						type: 'POST',
						success: function(result) {
							alert("Uploaded 22");
						}
				});
			});
		});
		*/
	
	
		/*
		파일 확장자나 크기의 사전 처리 p.506
		첨부파일을 이용한 웹 공격을 막기 위해 확장자를 제한한다.
		*/
		$(document).ready(function(){
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$"); // 여기에 해당하는 파일은 첨부 불가
			var maxSize = 5242880; // 5MB
			
			function checkExtension(fileName, fileSize) {
				// 파일 사이즈 체크
				if(fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				// 파일 확장자 체크
				if(regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				// 위에서부터 모든 체크를 통과하고 여기까지 내려오는 경우에만 true를 리턴한다.
				return true;
			}
			
			$("#uploadBtn").on("click", function(e) {
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				console.log(files);
				
				for(var i=0; i<files.length; i++) {
					// 체크 처리를 통과하지 못하면 업로드를 종료한다.
					if(!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					// 체크 처리를 통과한 파일은 업로드 대상으로 지정한다.
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url: 'uploadAjaxAction',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					success: function(result) {
						alert("Uploaded 11");
					}
				}); //$.ajax
			});
		});
	</script>
</body>
</html>