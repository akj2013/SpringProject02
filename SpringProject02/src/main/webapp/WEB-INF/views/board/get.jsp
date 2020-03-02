<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h1 class='page-header'> Board Read</h1>
		</div>
	</div>
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Read Page</div>
				<div class="panel-body">
					<div class="form-group">
						<label>Bno</label> <input class="form-control" name='bno' value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title' value='<c:out value="${board.title }"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Text area</label> <textarea class="form-control" row="3" name='content' readonly="readonly"><c:out value="${board.content }"/></textarea>
					</div>
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name='writer' value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>
					<button data-oper='modify' class="btn btn-default">Modify</button>
					<button data-oper='list' class="btn btn-info">List</button>
					
					<form id='operForm' action="/spring/board/modify" method="get">
						<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno }"/>'>
						<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
						<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
						<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
						<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class='row'>
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i>Reply
					<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
				</div>
				<div class="panel-body">
					<ul class="chat">
						<li class="left clearfix" data-rno='12'>
							<div>
								<div class="header">
									<strong class="primary-font">user00</strong>
									<small class="pull-right text-muted">2020-02-26 21:56</small>
								</div>
								<p>Good Job!</p>
							</div>
						</li>
					</ul>
				</div>
				<div class="panel-footer">
				
				</div>
			</div>
		</div>
	</div>

	<!-- 댓글 등록 모달창 -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>Reply</label>
						<input class="form-control" name='reply' value='New Reply!!!'>
					</div>
					<div class="form-group">
						<label>Replyer</label>
						<input class="form-control" name='replyer' value='replyer'>
					</div>
					<div class="form-group">
						<label>Reply Date</label>
						<input class="form-control" name='replyDate' value=''>
					</div>
				</div>
				<div class="modal-footer">
					<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
					<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
					<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
					<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 댓글 처리 모듈 -->
	<script type="text/javascript" src="/spring/resources/js/reply.js?var=3"></script>
	<script>
		$(document).ready(function() {
			var bnoValue = '<c:out value="${board.bno}"/>';
			var replyUL = $(".chat");
			
			showList(1);
			
			function showList(page) {
				replyService.getList({bno:bnoValue, page: page || 1 }, function(replyCnt, list) {
					console.log(replyCnt);
					console.log(list);
					if(page == -1) {
						pageNum = Math.ceil(replyCnt/10.0);
						showList(pageNum);
						return;
					}
					
					var str = "";
					
					if(list == null || list.length == 0) {
						return;
					}
					
					for (var i = 0, len = list.length || 0; i < len; i++) {
						str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
						str += "<div><div class='header'><strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";
						str += "<small class='pull-right text-muted'>" +replyService.displayTime(list[i].replyDate)+"</small></div>";
						str += "<p>"+list[i].reply+"</p></div></li>";
					}

					replyUL.html(str);
					showReplyPage(replyCnt);
				}); // end function
			} // end shoList
			
			// 댓글 추가 시작 시 버튼 이벤트 처리
			var modal = $(".modal");
			var modalInputReply = modal.find("input[name='reply']");
			var modalInputReplyer = modal.find("input[name='replyer']");
			var modalInputReplyDate = modal.find("input[name='replyDate']");
			
			var modalModBtn = $("#modalModBtn");
			var modalRemoveBtn = $("#modalRemoveBtn");
			var modalRegisterBtn = $("#modalRegisterBtn");
			
			$("#addReplyBtn").on("click", function(e) {
				modal.find("input").val("");
				modalInputReplyDate.closest("div").hide();
				modal.find("button[id != 'modalCloseBtn']").hide();
				
				modalRegisterBtn.show();
				
				$(".modal").modal("show");
			});
			
			// 새로운 댓글 추가 처리
			modalRegisterBtn.on("click", function(e) {
				var reply = {
						reply : modalInputReply.val(),
						replyer : modalInputReplyer.val(),
						bno : bnoValue
				};
				replyService.add(reply, function(result) {
					alert(result);
					modal.find("input").val("");
					modal.modal("hide");
					
					//showList(1);
					showList(-1);
				});
			});
			
			// 댓글 클릭 이벤트 처리 (이벤트 위임)
			// 이벤트 위임 : DOM에서 이벤트 리스너를 등록하는 것은 반드시 해당 DOM 요소가 존재해야만 가능하다.
			// 위와 같이 동적으로 AJAX를 통해서 <li> 태그들이 만들어지면 이후에 이벤트를 등록해야 하기 때문에 일반적 방식이 아니라 이벤트 위임(delegation) 형태로 작성해야 한다.
			// 이벤트 위임은 이벤트를 동적으로 생성되는 요소가 아닌 이미 존재하는 요소에 이벤트를 걸어주고, 나중에 이벤트의 대상을 변경해 주는 방식이다.
			// jQuery는 on()을 통해서 쉽게 처리할 수 있다.
			$(".chat").on("click", "li", function(e) {
				var rno = $(this).data("rno");
				console.log("댓글 클릭 이벤트 처리(이벤트 위임) / rno 값 : " + rno);
				
				replyService.get(rno, function(reply) {
					modalInputReply.val(reply.reply);
					modalInputReplyer.val(reply.replyer);
					modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
					modal.data("rno", reply.rno);
					
					modal.find("button[id != 'modalCloseBtn']").hide();
					modalModBtn.show();
					modalRemoveBtn.show();
					
					$(".modal").modal("show");
				});
			});
			
			// 댓글 수정 이벤트 처리
			modalModBtn.on("click", function(e) {
				var reply = {rno:modal.data("rno"), reply:modalInputReply.val()};
				
				replyService.update(reply, function(result) {
					alert("댓글 수정 처리 결과 : " + result);
					modal.modal("hide");
					showList(pageNum);
				});
			});
			
			// 댓글 삭제 이벤트 처리
			modalRemoveBtn.on("click", function(e) {
				var rno = modal.data("rno");
				
				replyService.remove(rno, function(result) {
					alert("댓글 삭제 처리 결과 : " + result);
					modal.modal("hide");
					showList(pageNum);
				});
			});
			
			// 댓글 자동 추가 이벤트 처리
			// get.jsp로 화면이 넘어올 때 자동으로 하나씩 댓글이 추가되도록 이벤트를 추가한다.

//			replyService.getReplyCount(bnoValue, function(result) {
//				alert("댓글 갯수 확인 함수 결과 : " + result);
//			});
			var addReply = {
					reply : "아라비아",
					replyer : "아자아자",
					bno : bnoValue
			}
			
			replyService.add(addReply, function(result) {
				alert("댓글 자동 추가 이벤트 처리 결과 : " + result);
			});
			// 댓글 페이지 번호를 출력하는 로직
			var pageNum = 1;
			var replyPageFooter = $(".panel-footer");

			function showReplyPage(replyCnt) {
				var endNum = Math.ceil(pageNum/10.0) * 10;
				var startNum = endNum - 9; // endNum이 10번이라면 1번
				var prev = startNum != 1; // 1번이 아니라면 true
				var next = false; // 일단 false
				
				// 100개보다 적다면
				if(endNum * 10 >= replyCnt) {
					endNum = Math.ceil(replyCnt/10.0);
				}
				
				if(endNum * 10 < replyCnt) {
					next = true;
				}
				
				var str = "<ul class='pagination pull-right'>";
				
				if(prev) {
					str += "<li class='page-item'><a class='page-link' href='"+(startNum -1) +"'>Previous</a></li>";
				}
				
				for(var i = startNum ; i <= endNum; i++) {
					var active = pageNum == i ? "active" : "";
					
					str += "<li class='page-item "+active+" '><a class='page-link' href ='"+i+"'>"+i+"</a></li>";
				}
				
				if(next) {
					str += "<li class='page-item'><a class='page-link' href ='"+(endNum +1)+"'>Next</a></li>";
				}
				
				str += "</ul></div>";
				console.log(str);
				replyPageFooter.html(str);
			}
			
			// 댓글의 페이지 번호를 클릭했을 때
			replyPageFooter.on("click", "li a", function(e) {
				e.preventDefault();
				console.log("page click");
				var targetPageNum = $(this).attr("href");
				console.log("targetPageNum : " + targetPageNum);
				pageNum = targetPageNum;
				showList(pageNum);
			});
		});
	</script>
	<!-- js 함수 호출 -->

	<!-- 이벤트 처리 -->
	<script type="text/javascript">
		$(document).ready(function() {
			
			var operForm = $("#operForm");
			
			$("button[data-oper='modify']").on("click", function(e){
				
				operForm.attr("action","/spring/board/modify").submit();

			});
			
			$("button[data-oper='list']").on("click", function(e){
				
				operForm.find("#bno").remove();
				operForm.attr("action","/spring/board/list");
				operForm.submit();
			})
		});

	</script>
<%@include file="../includes/footer.jsp"%>

