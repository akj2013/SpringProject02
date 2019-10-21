<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 입력</title>
</head>
<body>
게시글 입력 페이지입니다.<br>
화면을 구현합니다.<hr>
	<form action="/mypage/board/boardWrite" method="post">
		<table class="write">
			<div>
				<input type="text" name="title" placeholder="title">
			</div>
			<div>
				<input type="text" name="context" placeholder="context">
			</div>
			<div>
				<input type="password" name="password" placeholder="password"> 
			</div>
			<div>
				<input type="submit" name="제출">
			</div>
			<div>
				<button name="취소" onclick="redirect:/board/list">취소</button>
			</div>
		</table>
	</form>

</body>
</html>