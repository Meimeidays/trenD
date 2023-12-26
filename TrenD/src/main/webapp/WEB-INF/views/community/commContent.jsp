<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <title>TrenD Community Content</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
          rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">

    <%@ include file="../include/header.jsp" %>


    <link href="css/post.css" rel="stylesheet">
</head>

<body>

<c:if test="${Character.toString(post.trDelYn) eq 'y'}">
    <script>
        alert('해당 글은 삭제되었습니다.');
        window.location.href = '/';
    </script>
</c:if>


<main id="main" class="main">


    <div class="pagetitle">

        <h1>커뮤니티 게시판</h1>
        <div class="title_left">
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">${post.categoryVO.cateNm}</li>
                    <li class="breadcrumb-item">${post.userId}</li>
                    <li class="breadcrumb-item">${post.trDate}</li>
                </ol>
            </nav>
        </div>

        <div class="title_right">
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="javascript:void(0);" onclick="deletePost()">삭제</a></li>
                    <li class="breadcrumb-item"><a href="javascript:void(0);" onclick="updateForm()">수정</a></li>
                    <li class="breadcrumb-item"><a href="/">목록</a></li>
                </ol>
            </nav>
        </div>
    </div><!-- End Page Title -->
    <!--본문-->
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">${post.trSubject}</h5>

            ${post.trContent}
        </div>
    </div>
    <!--end 본문-->

    <script>
        function updateForm() {
            location.href = "commUpdateForm?trNo=${post.trNo}"
        }

        function deletePost() {
            var check = confirm('글을 삭제하시겠습니까?');

            if (check) {
                location.href = "deletePost?trNo=${post.trNo}"
                alert('글이 삭제되었습니다.');
            }
            else {

            }
        }

    </script>


    <div>

        댓글 공간

    </div>


</main>


<!-- Vendor JS Files -->
<script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/chart.js/chart.umd.js"></script>
<script src="assets/vendor/echarts/echarts.min.js"></script>
<script src="assets/vendor/quill/quill.min.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/vendor/tinymce/tinymce.min.js"></script>
<script src="assets/vendor/php-email-form/validate.js"></script>

<!-- Template Main JS File -->
<script src="assets/js/main.js"></script>


<%@ include file="../include/footer.jsp" %>

</body>
</html>
