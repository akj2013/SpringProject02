<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<!-- attach.png 파일의 이미지가 보이도록 스타일을 수정한다. -->
	<style>
	.uploadResult {
		width:100%;
		background-color: gray;
	}

	.uploadResult ul {
		display:flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}

	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}

	.uploadResult ul li img {
		width: 20px;
	}
	</style>
<body>
	<h1>Upload With Ajax</h1>
	<div class='uploadDiv'>
		<input type = 'file' name = 'uploadFile' multiple>
	</div>

	<!-- 특정한 <ul> 태그 내에 업로드된 파일의 이름을 보여준다. -->
	<div class='uploadResult'>
		<ul>
		</ul>
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

			// <input type='file'> DOM 요소를 초기화 시켜주기 위한 변수.
			var cloneObj = $(".uploadDiv").clone();
			// var cloneObj = $(".uploadResult").clone();

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
					dataType: 'json',
					success: function(result) {
						console.log(result);
						// 업로드할 파일의 섬네일을 보여준다.
						showUploadedFile(result);
						// DOM 요소를 초기화
						$(".uploadDiv").html(cloneObj.html());
						// $(".uploadResult").html(cloneObj.html());
					}
				}); //$.ajax
			});

			// uploadResult div에 업로드할 파일의 섬네일을 보여준다.
			var uploadResult = $(".uploadResult ul");
			function showUploadedFile(uploadResultArr) {
				var str = ""; // String이 없으니까 ""로 처리해준다.

				$(uploadResultArr).each(
					function(i, obj) {
						// 이미지 파일이 아닌 경우, attach.png 파일을 섬네일로 보여준다.
						if (!obj.image) {
							str += "<li><img src='/spring/resources/img/attach.png'>" + obj.fileName + "</li>";
						// 이미지 파일인 경우, 이미지 파일을 섬네일로 보여준다.
						} else {
							// str += "<li>" + obj.fileName + "</li>";
							// 한글 이름이나 공백 문자를 URI 호출에 적합한 문자열로 인코딩 처리해야 하기 때문에 encodeURIComponent를 사용해준다.
							var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
							str += "<li><img src='/spring/upload/display?fileName="+fileCallPath+"'>" + obj.fileName +"<li>";
						}
					});
				uploadResult.append(str);
			}
		});
	</script>
</body>
</html>