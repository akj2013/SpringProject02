console.log("Reply Module!! !!");

var  replyService = (function() {
//	return {name:"즉시실행 함수"};
	function add(reply, callback, error) {
		console.log("add reply.......이 로그 다음에 아작스가 호출됩니다. post의 new");
		
		$.ajax({
			type : 'post',
			url : '/spring/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}
	
	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/spring/replies/pages/" + bno + "/" + page + ".json",
				function(data) {
					if (callback) {
						// callback(data); //댓글 목록만 가져오는 경우
						callback(data.replyCnt, data.list); // 댓글 숫자와 목록을 가져오는 경우
					}
				}).fail(function(xhr, status, err) {
					if (error) {
						error();
					}
				}) ;
	}
	
	function remove(rno, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/spring/replies/' + rno,
			success : function(deleteResult, status, xhr) {
				if (callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, err) {
				if (error) {
					error(err);
				}
			}
		});
	}
	
	function update(reply, callback, error) {
		console.log("RNO : " + reply.rno);
		
		$.ajax({
			type : 'put',
			url : '/spring/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			},
			complete : function() {
				console.log("update complete 콜백함수")
			}
		});
	}
	
	function get(rno, callback, error) {
		$.get("/spring/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		}) ;
	}
	
	function displayTime(timeValue) {
		var today = new Date();
		var gap = today.getTime() - timeValue;
		var dateObj = new Date(timeValue);
		var str = "";

		if (today.getFullYear() == dateObj.getFullYear() && today.getDate() == dateObj.getDate() && dateObj.getMonth() == today.getMonth()) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth(	) is zero-based 
			var dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
			
			// TEST TEXT
		};
	}
	
	// 현재 이 게시글이 가지고 있는 댓글의 갯수를 가지고 오는 함수
	function getReplyCount(bno, callback, error) {
		$.get("/spring/replies/getReplyCount/" + bno + ".json", function(data) {
			if (callback) {
				callback(data); //
			}
		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		}) ;
	}
	
	return {
		add:add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime,
		getReplyCount : getReplyCount
	};
})();