<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board Modify Page</h1>
		</div>
	</div>

	<!-- 첨부파일을 보여줄 장소 -->
	<div class='bigPictureWrapper'>
		<div class='bigPicture'>
		</div>
	</div>

	<style>
		.uploadResult {
			width:100%;
			background-color: gray;
		}
		.uploadResult ul {
			display: flex;
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
			background: rgba(255,255,255,0.5);
		}
		.bigPicture {
			position: relative;
			display: flex;
			justify-content: center;
			align-items: center;
		}
		.bigPicture img {
			width: 600px;
		}
	</style>

	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Files</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name='uploadFile' multiple="multiple">
					</div>
					<div class='uploadResult'>
						<ul>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 첨부파일 부분 끝. -->

	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					Board Modify Page
				</div>
				<div class="panel-body">
					<form role="form" action="/spring/board/modify" method="post">
						<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
						<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
						<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
						<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
						<div class="form-group">
							<label>Bno</label>
							<input class="form-control" name='bno' value='<c:out value="${board.bno }"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>Title</label>
							<input class="form-control" name='title' value='<c:out value="${board.title }"/>'>
						</div>
						<div class="form-group">
							<label>Text area</label>
							<textarea class="form-control" rows="3" name='content'><c:out value="${board.content }"/></textarea>
						</div>
						<div class="form-group">
							<label>Writer</label>
							<input class="form-control" name='writer' value='<c:out value="${board.writer }"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>RegDate</label>
							<input class="form-control" name='regDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate }" />' readonly="readonly">
						</div>
						
						<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
						<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
						<button type="submit" data-oper='list' class="btn btn-info">List</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			var formObj = $("form");
			
			$('button').on("click", function(e) {

				e.preventDefault(); // form 태그의 모든 버튼은 기본적으로 submit으로 처리하기 때문에 기본 동작을 막고 마지막에 직접 submit()을 수행한다.
				var operation = $(this).data("oper");
				console.log(operation);
				
				if(operation === 'remove') {
					formObj.attr("action", "/spring/board/remove");
				}else if(operation === 'list') {
					// move to list
					formObj.attr("action","/spring/board/list").attr("method","get");
					var pageNumTag = $("input[name='pageNum']").clone();
					var amountTag = $("input[name='amount']").clone();
					var keywordTag = $("input[name='keyword']").clone();
					var typeTag = $("input[name='type']").clone();
					
					formObj.empty();
					formObj.append(pageNumTag);
					formObj.append(amountTag);
					formObj.append(typeTag);
					formObj.append(keywordTag);
				}else if(operation === 'modify') {
					console.log("submit clicked");
					var str = "";
					$(".uploadResult ul li").each(function(i, obj) {
						var jobj = $(obj);
						console.log(jobj);
						str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
					});
					formObj.append(str).submit();
				}
				formObj.submit();
			});
		});
	</script>

	<!-- 첨부파일 관련 스크립트 -->
	<script>
		$(document).ready(function() {
			(function() {
				var bno = '<c:out value="${board.bno}"/>';
				$.getJSON("/spring/board/getAttachList", {bno: bno}, function(arr) {
					console.log(arr);
					var str = "";
					$(arr).each(function(i, attach) {
						// 이미지 타입
						if (attach.fileType) {
							var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
							str += "<span> " + attach.fileName+"</span>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
							str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
							str += "<img src='/spring/upload/display?fileName="+fileCallPath+"'>";
							str += "</div>";
							str + "</li>";
						} else {
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
							str += "<span> " + attach.fileName+"</span><br/>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
							str += " class='btn btn-warning btn-circle'><li class='fa fa-times'></i></button><br>";
							str += "<img src='/spring/resources/img/attach.png'></a>";
							str += "</div>";
							str + "</li>";
						}
					});
					$(".uploadResult ul").html(str);
				}); // end getJSON
			})(); // end function
			// 첨부파일 삭제 이벤트
			$(".uploadResult").on("click", "button", function(e) {
				console.log("파일을 삭제합니다.");
				if (confirm("이 파일을 삭제하시겠습니까?")) {
					var targetLi = $(this).closest("li");
					targetLi.remove();
				}
			});
	
			// 첨부파일 추가
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; // 5MB
	
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
			});
	
			function showUploadResult(arr) {
				console.log("showUploadRsult 시작");
				if (!arr || arr.length == 0) {
					console.log("리턴");
					return;
				}
				var uploadUL = $(".uploadResult ul");
				var str = "";
				$(arr).each(function(i, obj) {
					// image type
					if (obj.image) {
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						str += "<li data-path='"+obj.uploadPath+"'";
						str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'";
						str += "><div>";
						str += "<span> " + obj.fileName + "</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\' ";
						str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/spring/upload/display?fileName="+fileCallPath+"'>";
						str += "</div>";
						str += "</li>";
					} else {
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
						str += "<li ";
						str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
						str += "<span> " + obj.fileName + "</span>";
						str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
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