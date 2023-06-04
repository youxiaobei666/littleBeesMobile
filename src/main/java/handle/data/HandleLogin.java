package handle.data;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import save.data.Login;

@WebServlet("/loginServlet")
public class HandleLogin extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setCharacterEncoding("utf-8"); // 字符
    // 这里并不需要 bean,从 session 中获取，在 success 中搞定当然 fail 也可以
    // 获取参数
    String logname = request.getParameter("logname").trim();
    String password = request.getParameter("password"); // 获取密码
    password = Encrypt.encrypt(password, "mySecret0428"); // 加密
    boolean flag = (logname.length() > 0 && password.length() > 0); // 判断是否合规格式

    //  数据库
    String url = "jdbc:mysql://127.0.0.1/mobileDatabase";
    String username = "root";
    String passwordMySql = "yjc010203.";

    try {
      Class.forName("com.mysql.cj.jdbc.Driver"); // 获取引擎，不需要导入，会去jar包中找
      Connection connection =
          DriverManager.getConnection(url, username, passwordMySql); // 使用 java.sql 包，jdk 自带
      connection.createStatement();
      // 初始化sql语句
      String insertCondition =
          "select * from user where logname = '" + logname + "'and password = '" + password + "'";
      PreparedStatement sql =
          connection.prepareStatement(insertCondition); // 用于向关系型数据库发送预编译的 SQL 语句
      // 当符合输入的格式
      if (flag) {
        // 执行 sql，得到返回的结果
        ResultSet rs = sql.executeQuery();
        if (rs.next()) {
          System.out.println("success");
          // 调用登录成功的方法:
          success(request, response, logname, password);
          RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp"); // 转发
          System.out.println("dispatch");
          dispatcher.forward(request, response);
        } else {
          String backNews = "您输入的用户名不存在，或密码不匹配";
          // 调用登录失败的方法:
          fail(request, response, logname, backNews);
        }
      } else {
        String backNews = "请输入用户名和密码";
        fail(request, response, logname, backNews);
      }
      connection.close(); // 连接返回连接池。
    } catch (ClassNotFoundException | SQLException e) {
      String backNews = "没有设置连接池" + e;
      fail(request, response, logname, backNews);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }

  public void success(
      HttpServletRequest request, HttpServletResponse response, String logname, String password) {
    Login loginBean = null; // 声明Login对象loginBean，并初始化为null
    HttpSession session = request.getSession(true); // 获取session对象

    try {
      // 从session中获取loginBean对象
      loginBean = (Login) session.getAttribute("loginBean");

      // 如果loginBean为null，说明是新用户，创建新的数据模型
      if (loginBean == null) {
        loginBean = new Login(); // 创建新的数据模型
        // 注意，此时 session 中并没有 LoginBean 所以，这里才第一次新建这个 bean
        session.setAttribute("loginBean", loginBean); // 将新的数据模型保存到session中
        loginBean = (Login) session.getAttribute("loginBean"); // 重新从session中获取loginBean对象
      }

      // 获取当前登录用户的用户名
      String name = loginBean.getLogname();
      System.out.println(name);
      System.out.println(logname);
      // 如果当前登录用户与请求中传入的用户名一致，说明该用户已经登录过了
      if (name.equals(logname)) {
        System.out.println("已经登录过了");
        loginBean.setBackNews(logname + "已经登录了"); // 设置返回消息
        loginBean.setLogname(logname); // 设置当前登录用户名
        System.out.println(loginBean.getLogname());
      } else { // 否则说明是新的登录用户
        System.out.println("新的");
        loginBean.setBackNews(logname + "登录成功"); // 设置返回消息
        loginBean.setLogname(logname); // 设置当前登录用户名
      }
    } catch (Exception ee) { // 捕获异常
      loginBean = new Login(); // 创建新的数据模型
      session.setAttribute("loginBean", loginBean); // 将新的数据模型保存到session中
      loginBean.setBackNews(ee.toString()); // 设置返回消息为异常信息
      loginBean.setLogname(logname); // 设置当前登录用户名
    }
  }

  public void fail(
      HttpServletRequest request, HttpServletResponse response, String logname, String backNews) {
    response.setContentType("text/html;charset=utf-8");
    try {
      PrintWriter out = response.getWriter();
      out.println("<html><body>");
      out.println("<h2>" + logname + "登录反馈结果<br>" + backNews + "</h2>");
      out.println("返回登录页面或主页<br>");
      out.println("<a href =login.jsp>登录页面</a>");
      out.println("<br><a href =index.jsp>主页</a>");
      out.println("</body></html>");
    } catch (IOException ignored) {
    }
  }
}
