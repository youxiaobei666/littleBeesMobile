<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<style>
    .title {
        font-size: 58px;
        color: #ffba10;
        background-color: #8586e3;
    }

    .container {
        width: 100%;
        height: 100%;
        text-align: center;
        background: url("images/bees.jpeg");
    }

    .inner-box {
        margin: -30px auto;
        width: 1000px;
        height: 100px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #8586e3;
        border: #ffffff solid 2px;
        border-radius: 10px;
    }

    .list {
        width: 25%;
    }

    a {
        text-decoration: none;
        color: white;
        font-size: 20px;
    }

    a:hover {
        /*font-size: 25px;*/
        color: #f5bd44;
    }
</style>

<div class="container">
    <p class="title">小蜜蜂手机销售网</p>
    <div class="inner-box">
        <div class="list">
            <a href="inputRegisterMess.jsp">注册</a>
        </div>
        <div class="list">
            <a href="login.jsp">登陆</a>
        </div>
        <div class="list">
            <a href="lookMobile.jsp">浏览手机</a>
        </div>
        <div class="list">
            <a href="searchMobile.jsp">查询手机</a>
        </div>
        <div class="list">
            <a href="lookShoppingCar.jsp">查看购物车</a>
        </div>
        <div class="list">
            <a href="lookOrderForm.jsp">查看订单</a>
        </div>
        <div class="list">
            <a href="${pageContext.request.contextPath}/exitServlet">退出登陆</a>
        </div>
        <div class="list">
            <a href="index.jsp">主页</a>
        </div>
    </div>
</div>