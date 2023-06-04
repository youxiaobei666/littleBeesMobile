<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <form action="loginServlet" method="post">
            <table>
                <tr>
                    <td>登陆名称：
                        <label>
                            <input type="text" name="logname">
                        </label>
                    </td>

                </tr>
                <tr>
                    <td>输入密码：
                        <label>
                            <input type="password" name="password">
                        </label>
                    </td>
                </tr>
            </table>
            <input type="submit" value="提交">
        </form>
        <div>
            <p>登陆反馈：</p>
            <jsp:getProperty name="loginBean" property="backNews"/>
            <p>登陆名：
                <jsp:getProperty name="loginBean" property="logname"/>
            </p>
        </div>
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