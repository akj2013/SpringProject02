<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<!-- 섬네일의 실제 원본 이미지를 보여주는 영역을 작성한다. -->
	<div class='bigPictureWrapper'>
		<div class='bigPicture'>
		</div>
	</div>

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
		align-content: center;
		text-align: center;
	}

	.uploadResult ul li img {
		width: 100px;
	}

	.uploadResult ul li span {
		color: white;
	}

	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background:reba(255,255,255,0.5);
	}

	.bigPicture {
		postion: relative;
		display: flex; /* 화면 정중앙에 배치한다. */
		justify-content: center; /* 콘텐츠의 좌우 관계 상태를 정의한다. */
		align-itmes: center;
	}

	.bigPicture img {
		width: 600px;
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
						// $(".uploadDiv").html(cloneObj.html());
						// $(".uploadResult").html(cloneObj.html());
					}
				}); //$.ajax
			});

			// uploadResult div에 업로드할 파일의 섬네일을 보여준다.
			var uploadResult = $(".uploadResult ul");
			function showUploadedFile(uploadResultArr) {
				console.log("showUploadFile function");
				var str = ""; // String이 없으니까 ""로 처리해준다.

				$(uploadResultArr).each(
					function(i, obj) {
						// 이미지 파일이 아닌 경우, attach.png 파일을 섬네일로 보여준다.
						if (!obj.image) {
							var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
							var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
							str += "<li><div><a href='/spring/upload/download?fileName="+fileCallPath+"'>"
									+"<img src='/spring/resources/img/attach.png'>"+obj.fileName+"</a>"
									+"<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"
									+"<div></li>";
						// 이미지 파일인 경우, 이미지 파일을 섬네일로 보여준다.
						} else {
							// str += "<li>" + obj.fileName + "</li>";
							// 한글 이름이나 공백 문자를 URI 호출에 적합한 문자열로 인코딩 처리해야 하기 때문에 encodeURIComponent를 사용해준다.
							var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
							var originPath = obj.uploadPath + "\\"+obj.uuid + "_" + obj.fileName;
							originPath = originPath.replace(new RegExp(/\\/g),"/");
							str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/spring/upload/display?fileName="+fileCallPath+"'></a>"
									+"<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+"<li>";
						}
					});
				uploadResult.append(str);
			}
		});
		
		// 원본 이미지를 보여줄 <div> 처리
		// 일반 첨부파일과 달리 섬네일이 보여지는 이미지 파일의 경우 섬네일을 클릭하면 원본 이미지를 볼 수 있게 처리한다.
		// <a> 태그에서 직접 호출할 수 있도록 바깥에 작성한다.
		function showImage(fileCallPath) {
			// alert(fileCallPath);
			$(".bigPictureWrapper").css("display","flex").show();

			$(".bigPicture").html("<img src='/spring/upload/display?fileName="+fileCallPath+"'>").animate({width:'100%', height:'100%'}, 1000); // 1000은 1초
		}

		// 화면에 출력된 원본 이미지를 마우스로 다시 한번 클릭하면 사라지도록 이벤트를 처리한다.
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			setTimeout(function() {
				$('.bigPictureWrapper').hide();
			}, 1000);
		});

		// 섬네일의 'x' 표시에 대한 처리
		// 첨부파일의 경로와 이름, 파일의 종류를 전송한다.
		$(".uploadResult").on("click","span", function(e) {
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);
			
			$.ajax( {
				url: 'deleteFile',
				data: {fileName: targetFile, type:type},
				dataType: 'text',
				type: 'POST',
					success: function(result) {
						alert(result);
					}
			}); // $.ajax
		});
	</script>
</body>
</html>