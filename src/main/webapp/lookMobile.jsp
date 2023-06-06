<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        选择某类手机,分页显示这类手机。
        <%

            //  数据库
            String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
            String username = "root";
            String passwordMySql = "yjc010203.";

            try {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
                Connection connection =
                        DriverManager.getConnection(url, username, passwordMySql); // 使用 java.sql 包，jdk 自带
                connection.createStatement();
                // 初始化sql语句
                String insertCondition = "SELECT * FROM mobileClassify";
                PreparedStatement sql =
                        connection.prepareStatement(insertCondition); // 查询分类表
                //读取mobileClassify表，获得分类：
                ResultSet rs = sql.executeQuery();

                out.print("<form action='queryServlet' id=e method ='post'>");
                out.print("<select id=e name='fenleiNumber'>");
                while (rs.next()) {
                    int id = rs.getInt(1);
                    String mobileCategory = rs.getString(2);
                    out.print("<option value =" + id + ">" + mobileCategory + "</option>");
                }
                out.print("</select>");
                out.print("<input type ='submit' id=e value ='提交'>");
                out.print("</form>");
                rs.close();
                connection.close();//连接返回连接池。
            } catch (SQLException e) {
                out.print(e);
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