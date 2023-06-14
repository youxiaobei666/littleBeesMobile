package handle.data;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import save.data.Login;

@WebServlet("/buyServlet")
public class HandleBuyGoods extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setCharacterEncoding("utf-8");
    String logname = req.getParameter("logname");
    //  注册 bean
    Login loginBean = new Login();
    HttpSession session = req.getSession(true);
    //  数据库
    String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
    String username = "root";
    String passwordMySql = "yjc010203.";
    try {
      Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
    Connection connection = null; // 使用 java.sql 包，jdk 自带
    try {
      connection = DriverManager.getConnection(url, username, passwordMySql);
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
    try {
      connection.createStatement();
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
    // 初始化sql语句
    String querySQL = "select * from shoppingForm where logname = ?"; // 购物车。
    String insertSQL = "insert into orderForm values(?,?,?)"; // 订单表。
    String deleteSQL = "delete from shoppingForm where logname =?";
    PreparedStatement sql = null; // 用于向关系型数据库发送预编译的 SQL 语句

    try {
      loginBean = (Login) session.getAttribute("loginBean");
      if (loginBean == null) {
        resp.sendRedirect("login.jsp"); // 重定向到登录页面。
        return;
      } else {
        boolean b = loginBean.getLogname() == null || loginBean.getLogname().length() == 0;
        if (b) {
          resp.sendRedirect("login.jsp"); // 重定向到登录页面。
          return;
        }
      }
    } finally {

    }
    try {
      sql = connection.prepareStatement(querySQL); // 查询那块
      sql.setString(1, logname);
      ResultSet rs = sql.executeQuery();
      StringBuffer buffer = new StringBuffer();
      float sum = 0;
      boolean canCreateForm = false; // 是否可以产生订单。
      while (rs.next()) {
        canCreateForm = true;
        String goodsId = rs.getString(1);
        logname = rs.getString(2);
        String goodsName = rs.getString(3);
        float price = rs.getFloat(4);
        int amount = rs.getInt(5);
        sum += price * amount;
        buffer.append("<br>商品id:" + goodsId + ",名称:" + goodsName + "单价" + price + "数量" + amount);
      }
      if (canCreateForm == false) {
        resp.setContentType("text/html;charset=utf-8");
        PrintWriter out = resp.getWriter();
        out.println("<html><body>");
        out.println("<h2>" + logname + "请先选择商品添加到购物车");
        out.println("<br><a href =index.jsp>主页</a></h2>");
        out.println("</body></html>");
        return;
      }
      String strSum = String.format("%10.2f", sum);
      buffer.append("<br>").append(logname).append("<br>购物车的商品总价:").append(strSum);
      sql = connection.prepareStatement(insertSQL);
      sql.setInt(1, 0); // 订单号会自动增加。
      sql.setString(2, logname);
      sql.setString(3, new String(buffer));
      sql.executeUpdate(); // 添加到订单表。
      sql = connection.prepareStatement(deleteSQL);
      sql.setString(1, logname);
      sql.executeUpdate(); // 删除logname的购物车中货物。
      connection.close(); // 连接放回连接池。
      resp.sendRedirect("lookOrderForm.jsp"); // 查看订单。
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    doGet(req, resp);
  }
}
