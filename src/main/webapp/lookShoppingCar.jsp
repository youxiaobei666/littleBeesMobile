<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<%@ page import="save.data.Login" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>查看购物车</title>

<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <%
            // 判断一些权限问题
            if (loginBean == null) {
                response.sendRedirect("login.jsp");
                return;
            } else {
                if (loginBean.getLogname() == null || loginBean.getLogname().length() == 0) {
                    response.sendRedirect("login.jsp");
                }
            }
            // 数据库操作
            //  数据库
            String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
            String username = "root";
            String passwordMySql = "yjc010203.";

            // 输出模版
            out.print("<table border=1>");
            out.print("<tr>");
            out.print("<th id=j width=160>" + "手机标识(id)");
            out.print("<th id=j width=160>" + "手机名称");
            out.print("<th id=j width=160>" + "手机价格");
            out.print("<th id=j width=160>" + "购买数量");
            out.print("<th id=j width=160>" + "修改数量");
            out.print("<th id=j width=160>" + "删除商品");
            out.print("</tr>");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
                Connection connection = DriverManager.getConnection(url, username, passwordMySql); // 使用 java.sql 包，jdk 自带
                connection.createStatement();
                // 初始化sql语句
                String insertCondition = "SELECT goodsId,goodsName,goodsPrice,goodsAmount FROM shoppingForm" +
                        " where logname ='" + loginBean.getLogname() + "'";
                PreparedStatement sql = connection.prepareStatement(insertCondition); // 用于向关系型数据库发送预编译的 SQL 语句
                ResultSet rs = sql.executeQuery(); // 查shoppingForm表。
                String goodsId = "";
                String name = "";
                float price = 0;
                int amount = 0;
                String orderForm = null; //订单
                while (rs.next()) {
                    goodsId = rs.getString(1);
                    name = rs.getString(2);
                    price = rs.getFloat(3);
                    amount = rs.getInt(4);
                    out.print("<tr>");
                    out.print("<td id=j>" + goodsId + "</td>");
                    out.print("<td id=j>" + name + "</td>");
                    out.print("<td id=j>" + price + "</td>");
                    out.print("<td id=j>" + amount + "</td>");
                    // 更新
                    String update = "<form  action='updateServlet' method = 'post'>" +
                            "<input type ='text'id=j name='update' size =3 value= " + amount + " />" +
                            "<input type ='hidden' name='goodsId' value= " + goodsId + " />" +
                            "<input type ='submit' id=j value='更新数量'  ></form>";
                    // 删除
                    String del = "<form  action='deleteServlet' method = 'post'>" +
                            "<input type ='hidden' name='goodsId' value= " + goodsId + " />" +
                            "<input type ='submit' id=j value='删除该商品' /></form>";
                    out.print("<td id=j>" + update + "</td>");
                    out.print("<td id=j>" + del + "</td>");
                    out.print("</tr>");
                }
                out.print("</table>");
                orderForm = "<form action='buyServlet' method='post'>" +
                        "<input type ='hidden' name='logname' value= '" + loginBean.getLogname() + "'/>" + "<br>" +
                        "<input type ='submit' id=j value='生成订单(同时清空购物车)'></form>";
                out.print(orderForm);
                connection.close();//把连接返回连接池。
            } catch (SQLException e) {
                out.print("<h1>" + e + "</h1>");
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
        transform: translateX(-50%);

        background-color: #8586e3;
    }

    h1 {
        background-color: #8586e3;
    }
</style>

