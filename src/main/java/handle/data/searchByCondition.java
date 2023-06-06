package handle.data;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import save.data.Record_Bean;

@WebServlet("/searchByConditionServlet")
public class searchByCondition extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    // 设置编码
    resp.setCharacterEncoding("utf-8");
    HttpSession session = req.getSession(); // 获取 session
    // 以下获取参数
    String searchMess = req.getParameter("searchMess");
    String radioMess = req.getParameter("radio");
    System.out.println(radioMess);
    // 判断错误情况
    if (searchMess == null || searchMess.length() == 0) {
      resp.getWriter().print("no params");
    }
    // 数据库部分
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
    String insertCondition = "";

    float max = 0, min = 0;
    // 通过不同的查询条件来更该查询语句
    if (radioMess.contains("mobile_name")) { // 手机名，模糊搜索
      insertCondition =
          "SELECT mobile_version,mobile_name,mobile_made,mobile_price"
              + "FROM mobileForm where mobile_name like '%"
              + searchMess
              + "%' ";
    } else if (radioMess.contains("mobile_version")) { // 版本唯一，精确搜索
      insertCondition =
          "SELECT mobile_version,mobile_name,mobile_made,mobile_price"
              + "FROM mobileForm where mobile_version = '"
              + searchMess
              + "'";
    } else if (radioMess.contains("mobile_price")) { // 价格搜索最复杂
      String priceMess[] = searchMess.split("[-]+"); // 分割 100-200 > 100,200
      // 得到价格区间
      min = Float.parseFloat(priceMess[0]);
      max = Float.parseFloat(priceMess[1]);
      insertCondition =
          "SELECT mobile_version,mobile_name,mobile_made,mobile_price"
              + "FROM mobileForm where mobile_price <= "
              + max
              + " and mobile_price >= "
              + min;
    }
    Record_Bean dataBean = null;
    try {
      dataBean = (Record_Bean) session.getAttribute("dataBean");
      if (dataBean == null) {
        dataBean = new Record_Bean();
        session.setAttribute("dataBean", dataBean);
      }
    } catch (Exception exception) {

    }
    try {
      PreparedStatement sql =
          connection.prepareStatement(insertCondition); // 用于向关系型数据库发送预编译的 SQL 语句
      ResultSet resultSet = sql.executeQuery();
      // 此时已经查询到了数据
      ResultSetMetaData metaData = resultSet.getMetaData();
      int columnCount = metaData.getColumnCount();
      resultSet.last();
      int rows = resultSet.getRow();
      String[][] tableRecord = dataBean.getTableRecord();
      tableRecord = new String[rows][columnCount];
      resultSet.beforeFirst();
      int i = 0;
      while (resultSet.next()) {
        for (int k = 0; k < columnCount; k++) {
          tableRecord[i][k] = resultSet.getString(k + 1);
          i++;
        }
      }
      dataBean.setTableRecord(tableRecord);
      connection.close();
      resp.sendRedirect("byPageShow.jsp");
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
