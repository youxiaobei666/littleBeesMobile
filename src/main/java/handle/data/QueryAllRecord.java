package handle.data;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import save.data.Record_Bean;

@WebServlet("/queryServlet")
public class QueryAllRecord extends HttpServlet {
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
  }

  public void service(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setCharacterEncoding("utf-8");
    String idNumber = request.getParameter("fenleiNumber");
    if (idNumber == null) idNumber = "1";
    int id = Integer.parseInt(idNumber);
    HttpSession session = request.getSession(true);
    Connection con = null;
    Record_Bean dataBean = null;
    try {
      dataBean = (Record_Bean) session.getAttribute("dataBean");
      if (dataBean == null) {
        dataBean = new Record_Bean(); // 创建bean。
        session.setAttribute("dataBean", dataBean); // 是session bean。
      }
    } catch (Exception exp) {
    }
    try {
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
          "SELECT mobile_version,mobile_name,mobile_made,mobile_price "
              + "FROM mobileForm where id="
              + id;

      PreparedStatement sql =
          connection.prepareStatement(
              insertCondition, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

      ResultSet rs = sql.executeQuery();
      ResultSetMetaData metaData = rs.getMetaData();
      int columnCount = metaData.getColumnCount(); // 得到结果集的列数。
      rs.last();
      int rows = rs.getRow(); // 得到记录数。
      String[][] tableRecord = dataBean.getTableRecord();
      tableRecord = new String[rows][columnCount];
      rs.beforeFirst();
      int i = 0;
      while (rs.next()) {
        for (int k = 0; k < columnCount; k++) tableRecord[i][k] = rs.getString(k + 1);
        i++;
      }
      dataBean.setTableRecord(tableRecord); // 更新bean。
      connection.close(); // 连接返回连接池。
      response.sendRedirect("byPageShow.jsp"); // 重定向。
    } catch (Exception e) {
      response.getWriter().print("咋回事" + e);
    }
  }
}
