<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>자유게시판</title>
    <jsp:include page="../include/metalink.jsp"/>


    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script>

        function goBackList() {
            // 페이지가 제공되지 않으면 기본값으로 1을 사용
            if($('#searchInput').val() != ""){
                $('#searchInput').val("");
            }

            $.ajax({
                url: "/community/list/1",
                type: "GET",
                success: function (data) {
                    displayCommList(data);
                },
                error: function () {
                    alert("목록을 불러오는데 오류가 발생합니다.");
                }
            });
        }

        function searchComm(page, selectedCateCd) {
            var searchTerm = $('#searchInput').val();
            var search = $('#searchHead').val();
            // 페이지가 제공되지 않으면 기본값으로 1을 사용
            $.ajax({
                url: "/community/list/" + (page || 1),
                type: "GET",
                data: { "keyword": searchTerm,
                    "cateCd": selectedCateCd,
                    "search": search},
                success: function (data) {
                    displayCommList(data);
                },
                error: function () {
                    alert("검색 중 오류가 발생했습니다.");
                }
            });
        }


        $(document).ready(function() {
            searchComm(1); // 페이지 로딩 시 검색 결과 표시

            // 검색 버튼에 클릭 이벤트 바인딩
            $('#searchButton').click(function() {
                searchComm(1); // 검색 버튼 클릭 시 페이지 초기화 후 검색 수행
            });

            $(document).on('click', '#pagingUl a', function(e) {
                e.preventDefault(); // 페이지를 새로 고침하지 않아도 검색결과가 갱신되도록 하는 메소드
                var page = $(this).data('page');
                searchComm(page); // 페이지 번호 클릭 시 검색 결과 갱신
            });

            // 드롭다운 변경 이벤트 처리 함수
            $('#cateCd').change(function() {
                var selectedCateCd = $(this).val();
                searchComm(1, selectedCateCd); // 페이지 초기화 후 해당 카테고리의 리스트 검색
            });
        });

        function displayCommList(data) {
            $('#commTableBody').empty();
            $('#pagingUl').empty();
            var no = data.listCount - (data.page - 1) * 10;
            var row='';

            $.each(data.commList, function(index, community) {
                row = '<tr>' +
                    '<td>' + community.categoryVO.cateNm + '</td>' +
                    '<td><a href="/post?trNo=' + community.trNo + '">' + community.trSubject + '</a></td>' +
                    '<td>' + community.userVO.userName + '</td>' +
                    '<td>' + formatDate(community.trDate) + '</td>' +
                    '<td>' + community.trReadCount + '</td>' +
                    '</tr>';
                $('#commTableBody').append(row);
            });

            // Add Previous Button
            if (data.page > 1) {
                var prevPage = data.page - 1;
                var prevButton = '<a href="javascript:searchComm(' + prevPage + ')" data-page="' + prevPage + '">이전</a>';
                $('#pagingUl').append(prevButton);
            }

            // Add Page Numbers
            // Array.from메소드를 사용하여 전달받은 pageCount만큼의 배열을 생성
            // index에 1을 더하고 data-page속성을 사용하여 페이지 번호를 나타낸다.
            $.each(Array.from({ length: data.pageCount }, (_, i) => i + 1), function(index, pageNumber) {
                var li = '<a href="javascript:searchComm(' + pageNumber + ')" data-page="' + pageNumber + '">' + pageNumber + '</a>';
                $('#pagingUl').append(li);
            });

            // Add Next Button
            if (data.page < data.pageCount) {
                var nextPage = data.page + 1;
                var nextButton = '<a href="javascript:searchComm(' + nextPage + ')" data-page="' + nextPage + '">다음</a>';
                $('#pagingUl').append(nextButton);
            }

            // 여기에 cateList를 사용하여 추가적인 처리를 하도록 작성
            var dropdown = $('#cateCd');
            dropdown.empty(); // 기존 옵션을 모두 제거

            $.each(data.cateList, function(index, category) {
                dropdown.append($('<option>').val(category.cateCd).text(category.cateNm));
            });
        }

        // 원하는 날짜 형태를 options에 저장하고
        // toLocaleDateString메소드에 전달하여 리턴
        // toLocaleDateString('원하는 지역', 날짜형식 지정한 객체)
        function formatDate(dateString) {
            var date = new Date(dateString);
            var options = { year: 'numeric', month: '2-digit', day: '2-digit', weekday: 'long' };
            return date.toLocaleDateString('ko-KR', options);
        }

    </script>

</head>

<body>
<jsp:include page="../include/header.jsp"/>
<jsp:include page="../include/sidebar.jsp"/>

<main id="main" class="main">

    <div>
        <a href="javascript:goBackList()"><h2>자유게시판</h2></a>
    </div>
    <div align="left" id="categoryDiv">
        <select id="cateCd"></select>
        <a href="/commForm">글 작성</a>
    </div>
    <!-- 게시물 목록 테이블 -->
    <table id="communityTable" align="center" border="1" class="table">
        <thead>
        <tr>
            <th>머릿말</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>조회수</th>
        </tr>
        </thead>
        <tbody id="commTableBody">
        <!-- 데이터가 출력될 곳 -->
        </tbody>
    </table>

    <!-- 페이징 -->
    <div id="pagingDiv" align="center">
        <ul id="pagingUl"class="">
            <!-- 페이징 출력될 곳 -->
        </ul>
    </div>

    <!-- 검색창 -->
    <div id="searchDiv" align="center">
        <select id="searchHead">
            <option value="trSubject">제목</option>
            <option value="userName">작성자</option>
            <option value="trContent">내용</option>
        </select>
        <input type="text" id="searchInput" placeholder="제목을 입력하세요">
        <button onclick="searchComm()" class="btn btn-primary">검색</button>
    </div>

</main>

<jsp:include page="../include/footer.jsp"/>

</body>
</html>