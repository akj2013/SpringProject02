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
				}
				formObj.submit();
			});
		});
	</script>
<%@include file="../includes/footer.jsp"%>