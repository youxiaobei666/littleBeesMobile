<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="userBean" class="save.data.Register" scope="request"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <form action="registerServlet" method="post">
            <table id=c>
                <p id=c>用户名由字母、数字、下划线构成，*注释的项必须填写。</p>
                <tr>
                    <td>*用户名称:</td>
                    <td><input type=text id=c name="logname"/></td>
                    <td>*用户密码:</td>
                    <td><input type=password id=c name="password"></td>
                </tr>
                <tr>
                    <td>*重复密码:</td>
                    <td><input type=password id=c name="again_password"></td>
                    <td>联系电话:</td>
                    <td><input type=text id=c name="phone"/></td>
                </tr>
                <tr>
                    <td>邮寄地址:</td>
                    <td><input type=text id=c name="address"/></td>
                    <td>真实姓名:</td>
                    <td><input type=text id=c name="realname"/></td>
                    <td><input type=submit id=c value="提交"></td>
                </tr>
            </table>
        </form>
        <p id=c>注册反馈：</p>
        <jsp:getProperty name="userBean" property="backNews"/>
        <table id=c border=3>
            <tr>
                <td>ID:</td>
                <td>
                    <jsp:getProperty name="userBean" property="logname"/>
                </td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td>
                    <jsp:getProperty name="userBean" property="realname"/>
                </td>
            </tr>
            <tr>
                <td>地址:</td>
                <td>
                    <jsp:getProperty name="userBean" property="address"/>
                </td>
            </tr>
            <tr>
                <td>电话:</td>
                <td>
                    <jsp:getProperty name="userBean" property="phone"/>
                </td>
            </tr>
        </table>
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