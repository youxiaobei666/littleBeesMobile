<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <h1>欢迎光临小蜜蜂手机销售网主页</h1>
    </div>
</div>


<style>
    .changeArea {
        /*实现可变区域的居中*/
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translateX(-50%);
    }

    h1 {
        background-color: #8586e3;
    }
</style>

