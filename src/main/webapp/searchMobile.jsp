<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <p>可以输入手机号或者手机名称或者价格，输入价格是在2个值之间的价格，格式是：价格1-价格2。例如：897.98-10000。</p>
        <form action="searchByConditionServlet" id=g method="post">
            <br>输入查询信息:<input type=text id=g name="searchMess" value="3333-6666"><br>
            <input type=radio name="radio" id=g value="mobile_version"/>手机版本号
            <input type=radio name="radio" id=g value="mobile_name">手机名称
            <input type=radio name="radio" value="mobile_price" checked="ok">手机价格<br>
            <input type=submit id=g value="提交">
        </form>
    </div>
</div>


<style>
    .changeArea {
        /*实现可变区域的居中*/
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -20%);

        background-color: #8586e3;
        border-radius: 10px;
    }

    h1 {
        background-color: #8586e3;
    }
</style>