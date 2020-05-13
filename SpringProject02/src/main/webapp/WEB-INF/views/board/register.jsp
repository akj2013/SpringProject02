<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form role="form" action="/spring/board/register" method="post">
					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title'>
					</div>
					<!-- /.form-group_title -->
					<div class="form-group">
						<label>Text Area</label>
						<textarea class="form-control" rows="3" name='content'></textarea>
					</div>
					<!-- /.form-group_content -->
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name='writer'>
					</div>
					<!-- /.form-group_writer -->
					<button type="submit" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
				<!-- form : /board/register -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel panel-default -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<!-- 첨부파일을 추가할 수 있도록 더해준다. -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple>
				</div>
				<div class='uploadResult'>
					<ul>
					</ul>
				</div>
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel panel-default -->
	</div>
	<!--  end col-lg-12 -->
</div>
<!-- end row -->
<script>
	// 버튼을 클릭했을 때 기존 동작을 막는 처리.
	$(document).ready(function(e) {
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit clicked");
		});
	});

	// 별도의 업로드 버튼을 두지 않고, file의 내용이 변경되는 것을 감지해서 처리한다. 
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alx)$");
	var maxSize = 5242800; // 5MB
	function checkExtension(fileName, fileSize) {
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}

	$("input[type='file']").change(function(e) {
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;

		for (var i=0; i<files.length; i++) {
			if (!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}

		$.ajax({
			url: '/spring/upload/uploadAjaxAction',
			processData: false,
			contentType: false, 
			data: formData,
			type: 'POST',
			dataType:'json',
			success: function(result) {
				console.log("ajax success");
				console.log(result);
				showUploadResult(result); // 업로드 결과 처리 함수
			}
		});

		// 업로드 결과를 화면에 섬네일 등을 만들어서 처리.
		function showUploadResult(uploadResultArr) {
			console.log("showUploadRsult 시작");
			if (!uploadResultArr || uploadResultArr.length == 0) {
				console.log("리턴");
				return;
			}
			var uploadUL = $(".uploadResult ul");
			var str = "";
			$(uploadResultArr).each(function(i, obj) {
				// image type
				if (obj.image) {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					str += "<li><div>";
					str += "<span> " + obj.fileName + "</span>";
					str += "<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></li></button><br>";
					str += "<img src='/spring/upload/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				} else {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+boj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					str += "<li><div>";
					str += "<span> " + obj.fileName + "</span>";
					str += "<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></li></button><br>";
					str += "<img src='/spring/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			uploadUL.append(str);
		}
	});
</script>
<%@include file="../includes/footer.jsp"%>