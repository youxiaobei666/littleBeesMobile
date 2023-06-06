<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <%
            if (loginBean == null) {
                response.sendRedirect("login.jsp");
                return;
            } else {
                boolean b = loginBean.getLogname() == null || loginBean.getLogname().length() == 0;
                if (b) {
                    response.sendRedirect("login.jsp");
                    return;
                }
            }
            // 数据库部分
            //  数据库
            String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
            String username = "root";
            String passwordMySql = "yjc010203.";
            Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
            Connection connection = null; // 使用 java.sql 包，jdk 自带
            connection = DriverManager.getConnection(url, username, passwordMySql);
            connection.createStatement();
            String insertCondition = "";
            // 打印基本部分
            out.print("<table border=1>");
            out.print("<tr>");
            out.print("<th width=100>" + "订单序号");
            out.print("<th width=100>" + "用户名称");
            out.print("<th width=200>" + "订单信息");
            out.print("</tr>");
            try {
                insertCondition = "SELECT * FROM where logname ='" + loginBean.getLogname() + "'";
                PreparedStatement sql =
                        connection.prepareStatement(insertCondition);
                ResultSet resultSet = sql.executeQuery();
                while (resultSet.next()) {
                    out.print("<tr>");
                    out.print("<td>" + resultSet.getString(1) + "</td>");
                    out.print("<td>" + resultSet.getString(2) + "</td>");
                    out.print("<td>" + resultSet.getString(3) + "</td>");
                    out.print("</tr>");
                }
                out.print("</table>");
                connection.close();
            } catch (Exception exception) {

            }
        %>
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