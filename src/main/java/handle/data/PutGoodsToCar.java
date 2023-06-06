package handle.data;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import save.data.Login;

@WebServlet("/putGoodsServlet")
public class PutGoodsToCar extends HttpServlet {
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
  }

  public void service(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    //  数据库
    String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
    String username = "root";
    String passwordMySql = "yjc010203.";
    try {
      Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
    Connection connection;
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
    // 预处理语句和定义好结果
    String insertCondition = "";
    ResultSet rs;
    String mobileID = request.getParameter("mobileID");
    Login loginBean = null;
    HttpSession session = request.getSession(true);
    try {
      loginBean = (Login) session.getAttribute("loginBean");
      if (loginBean == null) {
        response.sendRedirect("login.jsp"); // 重定向到登录页面。
        return;
      } else {
        boolean b = loginBean.getLogname() == null || loginBean.getLogname().length() == 0;
        if (b) {
          response.sendRedirect("login.jsp"); // 重定向到登录页面。
          return;
        }
      }
    } catch (Exception exp) {
      response.sendRedirect("login.jsp"); // 重定向到登录页面。
      return;
    }
    try {
      String queryMobileForm = "select * from mobileForm where mobile_version =?"; // 查询商品表。
      String queryShoppingForm = "select goodsAmount from shoppingForm where goodsId =?"; // 购物车表。
      String updateSQL = "update shoppingForm set goodsAmount =? where goodsId=?"; // 更新购物车。
      String insertSQL = "insert into shoppingForm values(?,?,?,?,?)"; // 添加到购物车。
      PreparedStatement pre = connection.prepareStatement(queryShoppingForm);
      pre.setString(1, mobileID);
      rs = pre.executeQuery();
      if (rs.next()) { // 该货物已经在购物车中。
        int amount = rs.getInt(1);
        amount++;
        pre = connection.prepareStatement(updateSQL);
        pre.setInt(1, amount);
        pre.setString(2, mobileID);
        pre.executeUpdate(); // 更新购物车中该货物的数量。
      } else { // 向购物车添加商品。
        pre = connection.prepareStatement(queryMobileForm);
        pre.setString(1, mobileID);
        rs = pre.executeQuery();
        if (rs.next()) {
          pre = connection.prepareStatement(insertSQL);
          pre.setString(1, loginBean.getLogname());
          pre.setString(2, rs.getString("mobile_version"));
          pre.setString(3, rs.getString("mobile_name"));
          pre.setFloat(4, rs.getFloat("mobile_price"));
          pre.setInt(5, 1);
          pre.executeUpdate(); // 向购物车中添加该货物。
        }
      }
      connection.close();
      response.sendRedirect("lookShoppingCar.jsp"); // 查看购物车。
    } catch (SQLException exp) {
      response.getWriter().print("报错" + exp);
    } finally {
      try {
        connection.close();
      } catch (Exception ee) {
      }
    }
  }
}
