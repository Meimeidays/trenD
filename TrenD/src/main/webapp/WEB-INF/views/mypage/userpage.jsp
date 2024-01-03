<%--
  Created by IntelliJ IDEA.
  User: nasoo
  Date: 2023-12-21
  Time: 오후 5:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <title>마이페이지</title>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script>
        $(document).ready(function () {
            // 초기에는 boardlist 보이고 replylist 감춤
            boardlist(1);

            $("#board").click(function () {
                // boardlist 보이고 replylist 감춤
                $("#boardbody").show();
                $("#replybody").hide();
                boardlist(1); // page 인자 추가
            });

            $("#reply").click(function () {
                // boardlist 감추고 replylist 보임
                $("#boardbody").hide();
                $("#replybody").show();
                replylist(1); // page 인자 추가
            });
        });

        // 게시판 목록
        function boardlist(page) {
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/mypage/boardlist/" + page,
                success: function (result) {
                    console.log(result);
                    if (result.boardlist.length === 0) {
                        // 작성된 내용이 없을 때의 처리
                        $("#boardbody").html("<tr><td colspan='4'>작성된 내용이 없습니다.</td></tr>");
                        $("#pagination").html("");  // 페이지네이션 숨기기
                    } else {
                        var boardContent = "<tr><th>머릿말</th>";
                        if (result.isAdmin) {
                            boardContent += "<th>작성자</th>";
                        }
                        boardContent += "<th>제목</th><th>날짜</th><th>조회수</th></tr>";
                        var content = "";  // content 변수 선언

                        $.each(result.boardlist, function (index, item) {
                            content += "<tr><td>" + (item.categoryVO ? item.categoryVO.cateNm : 'N/A') + "</td>";
                            if (result.isAdmin) {
                                content += "<td>" + item.userVO.userName + "(" + item.userVO.userId + ")" + "</td>";
                            }
                            content += "<td><a href='javascript:boardcontent(" + item.trNo + "," + page + ")'>" + item.trSubject + "</a></td>";
                            content += "<td>" + formatDateTime(item.trDate) + "</td>";
                            content += "<td>" + item.trReadCount + "</td></tr>";
                        });
                        $("#replybody").hide();  // replybody 감추기
                        $("#boardbody").show();  // boardbody 보이기
                        $("#boardbody").html(boardContent + content);  // content를 boardContent에 추가

                        // 페이지네이션 업데이트
                        updatePagination(result.pageCount, page, 'boardlist');
                    }
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }

        // 댓글 목록
        function replylist(page) {
            $.ajax({
                type: "GET",
                url: "${pageContext.request.contextPath}/mypage/replylist/" + page,
                success: function (result) {
                    console.log(result);
                    if (result.replylist.length === 0) {
                        // 작성된 내용이 없을 때의 처리
                        $("#replybody").html("<tr><td colspan='2'>작성된 내용이 없습니다.</td></tr>");
                        $("#pagination").html("");  // 페이지네이션 숨기기
                    } else {
                        var replyContent = "<tr><th>내용</th>";
                        if (result.isAdmin) {
                            replyContent += "<th>작성자</th>";
                        }
                        replyContent += "<th>작성일</th></tr>";
                        $.each(result.replylist, function (index, item) {
                            // item.trReContent가 null 또는 undefined인 경우에 대한 처리
                            var trReContent = item.trReContent != null ? item.trReContent : 'N/A';

                            replyContent += "<tr><td><a href='javascript:replycontent(" + item.trNo + "," + page + ")'>" + trReContent + "</a></td>";
                            if (result.isAdmin) {
                                replyContent += "<td>" + item.userVO.userName + "(" + item.userVO.userId + ")" + "</td>";
                            }
                            replyContent += "<td>" + formatDateTime(item.trReDate) + "</td></tr>";
                        });
                        $("#boardbody").hide();  // boardbody 감추기
                        $("#replybody").show();  // replybody 보이기
                        $("#replybody").html(replyContent);  // replybody를 업데이트

                        // 페이지네이션 업데이트
                        updatePagination(result.pageCount, page, 'replylist');
                    }
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }



        // 페이지네이션 업데이트 함수
        function updatePagination(totalPages, currentPage, listType) {
            var paginationHtml = '<nav aria-label="Page navigation"><ul class="pagination">';

            // 이전 버튼
            var prevPage = currentPage - 10;
            if (prevPage < 1) {
                prevPage = 1;
            }
            paginationHtml += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '"><a class="page-link" href="javascript:' + listType + '(' + prevPage + ')">이전</a></li>';

            // 페이지 숫자 버튼
            for (var i = 1; i <= totalPages; i++) {
                var activeClass = i === currentPage ? 'active' : '';
                paginationHtml += '<li class="page-item ' + activeClass + '"><a class="page-link" href="javascript:' + listType + '(' + i + ')">' + i + '</a></li>';
            }

            // 다음 버튼
            var nextPage = currentPage + 10;
            if (nextPage > totalPages) {
                nextPage = totalPages;
            }
            paginationHtml += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '"><a class="page-link" href="javascript:' + listType + '(' + nextPage + ')">다음</a></li>';

            paginationHtml += '</ul></nav>';
            $("#pagination").html(paginationHtml);
        }

        // 날짜 년-월-일 시:분 으로 출력하기
        function formatDateTime(dateTimeString) {
            var date = new Date(dateTimeString);
            var year = date.getFullYear();
            var month = ("0" + (date.getMonth() + 1)).slice(-2);
            var day = ("0" + date.getDate()).slice(-2);
            var hours = ("0" + date.getHours()).slice(-2);
            var minutes = ("0" + date.getMinutes()).slice(-2);

            return year + "-" + month + "-" + day + " " + hours + ":" + minutes;
        }

    </script>
    <jsp:include page="../include/metalink.jsp"/>
</head>
<body>
<%-- header --%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/sidebar.jsp" %>

<main id="main" class="main">
    <div>
        <input type="button" id="board" value="게시글" onclick="boardlist(1);">
        <input type="button" id="reply" value="댓글" onclick="replylist(1);">
    </div>
    <table align="center" width=800 class="table table-hover">
        <%-- 트랜드 글목록 --%>
        <tbody id="boardbody"></tbody>
        <%-- 트랜드 댓글목록 --%>
        <tbody id="replybody"></tbody>
    </table>
    <!-- 페이지네이션 -->
    <div id="pagination"></div>
</main>


<%-- footer --%>
<%@ include file="../include/footer.jsp" %>
</body>
</html>