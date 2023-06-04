package handle.data;

import java.io.IOException;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import save.data.Register;

@WebServlet("/registerServlet")
public class HandleRegister extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setCharacterEncoding("utf-8"); // 字符

    Register userBean = new Register(); // 创建bean。
    request.setAttribute("userBean", userBean);
    //    获取参数
    String logname = request.getParameter("logname").trim();
    String password = request.getParameter("password").trim();
    String again_password = request.getParameter("again_password").trim();
    String phone = request.getParameter("phone").trim();
    String address = request.getParameter("address").trim();
    String realname = request.getParameter("realname").trim();

    // 拒绝null 报错，而是空字符串
    if (logname == null) logname = "";
    if (password == null) password = "";
    //  处理输入两次密码不一样的情况
    if (!password.equals(again_password)) {
      userBean.setBackNews("两次密码不同，注册失败，");
      // 返回注册重来
      RequestDispatcher dispatcher = request.getRequestDispatcher("inputRegisterMess.jsp");
      dispatcher.forward(request, response); // 转发，继续执行下去
      return;
    }
    boolean isLD = true;
    for (int i = 0; i < logname.length(); i++) {
      char c = logname.charAt(i);
      if (!(Character.isLetterOrDigit(c) || c == '_')) isLD = false;
    }
    boolean boo = logname.length() > 0 && password.length() > 0 && isLD;
    String backNews = "";

    //  数据库
    String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
    String username = "root";
    String passwordMySql = "yjc010203.";
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection connection = DriverManager.getConnection(url, username, passwordMySql);

      Statement statement = connection.createStatement(); // 连接实例

      ResultSet resultSet = null;
      if (boo) {
        // 初始化sql语句
        String insertCondition = "insert into  user values (?,?,?,?,?)";
        PreparedStatement sql = connection.prepareStatement(insertCondition);
        sql.setString(1, logname);
        password = Encrypt.encrypt(password, "mySecret0428"); // 给用户密码加密。
        sql.setString(2, password);
        sql.setString(3, phone);
        sql.setString(4, address);
        sql.setString(5, realname);
        // 执行查询
        int res = sql.executeUpdate();
        if (res != 0) { // sql 成功,成功影响了一行
          backNews = "注册成功"; // 提示
          // bean 操作
          userBean.setBackNews(backNews);
          userBean.setLogname(logname);
          userBean.setPhone(phone);
          userBean.setAddress(address);
          userBean.setRealname(realname);
        }
      } else {
        backNews = "信息填写不完整或名字中有非法字符";
        userBean.setBackNews(backNews);
      }
      // 以下是关闭数据库连接的操作
      statement.close();
      connection.close();
    } catch (SQLException exp) {
      backNews = "该会员名已被使用，请您更换名字" + exp;
      userBean.setBackNews(backNews);
    } catch (ClassNotFoundException exp) {
      backNews = "没有设置连接池" + exp;
      userBean.setBackNews(backNews);
    }
    RequestDispatcher dispatcher = request.getRequestDispatcher("inputRegisterMess.jsp");
    dispatcher.forward(request, response); // 转发,然后页面使用 bean 中的数据
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    doGet(req, resp);
  }
}
