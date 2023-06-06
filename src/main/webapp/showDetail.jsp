<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<%@ page import="save.data.Login" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <%
            try {
                loginBean = (Login) session.getAttribute("loginBean");
                if (loginBean == null) {
                    response.sendRedirect("login.jsp");//重定向到登录页面.
                    return;
                } else {
                    boolean b = loginBean.getLogname() == null ||
                            loginBean.getLogname().length() == 0;
                    if (b) {
                        response.sendRedirect("login.jsp");//重定向到登录页面。
                        return;
                    }
                }
            } catch (Exception exp) {
                response.sendRedirect("login.jsp");//重定向到登录页面。
                return;
            }
            String mobileID = request.getParameter("mobileID");
            if (mobileID == null) {
                out.print("没有产品号，无法查看细节");
                return;
            }
            //  数据库
            String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
            String username = "root";
            String passwordMySql = "yjc010203.";
            Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
            Connection connection =
                    DriverManager.getConnection(url, username, passwordMySql); // 使用 java.sql 包，jdk 自带
            connection.createStatement();
            // 初始化sql语句
            String insertCondition =
                    "SELECT * FROM mobileForm where mobile_version = '" + mobileID + "'";
            PreparedStatement sql =
                    connection.prepareStatement(insertCondition); // 用于向关系型数据库发送预编译的 SQL 语句
            try {
                ResultSet rs = sql.executeQuery();
                out.print("<table id=h border=2>");
                out.print("<tr>");
                out.print("<th>产品号");
                out.print("<th>名称");
                out.print("<th>制造商");
                out.print("<th>价格");
                out.print("<th>放入购物车<th>");
                out.print("</tr>");
                String picture = "defaultImg.webp"; // 默认图片名
                String detailMess = "";
                while (rs.next()) {
                    mobileID = rs.getString(1);
                    String name = rs.getString(2);
                    String maker = rs.getString(3);
                    String price = rs.getString(4);
                    detailMess = rs.getString(5);
                    picture = rs.getString(6);
                    out.print("<tr>");
                    out.print("<td>" + mobileID + "</td>");
                    out.print("<td>" + name + "</td>");
                    out.print("<td>" + maker + "</td>");
                    out.print("<td>" + price + "</td>");
                    String shopping =
                            "<a href ='putGoodsServlet?mobileID=" + mobileID + "'>添加到购物车</a>";
                    out.print("<td>" + shopping + "</td>");
                    out.print("</tr>");
                }
                out.print("</table>");
                out.print("产品详情:<br>");
                out.println("<div align=center>" + detailMess + "<div>");
                String pic = "<img src='images/" + picture + "' width=260 height=200 ></img>";
                out.print(pic); //产片图片
                connection.close(); //连接返回连接池。
            } catch (SQLException exp) {
            } finally {
                try {
                    connection.close();
                } catch (Exception ee) {
                }
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