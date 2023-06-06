# 小蜜蜂🐝手机销售网

## 1. 项目介绍

预览：
![img1](https://pic1.zhimg.com/80/v2-0ca98959cbf3e495e6bbe9b51007b744_r.jpg)
![img2](https://picx.zhimg.com/80/v2-93ce06a2244e4f8cfd3ca47030f0075b_r.jpg)
![img3](https://pic1.zhimg.com/80/v2-2150a109800576ad81ddf1e64ea4e8d0_r.jpg)
![img4](https://pic4.zhimg.com/80/v2-ef0b16979c01bba5871c1a20d148f523_r.jpg)

### 1.1 搭建环境

**jdk-19.0.2/tomcat-8.5.89/编辑器-intellJ Idea2023.1.2/mysql-8.0.31**

### 1.2 系统模块构成

![img1](https://pic4.zhimg.com/80/v2-bc896280a2ef1145cd67901296a4bfe1_r.jpg)

## 2. 数据库的设计

数据库名 **mobileDatabase**

### 2.1 user表(用户表)

| key  | 备注  |
|:----------|:----------|
| logname     | 用户名（字符型，主键）    |
| password    | 用户密码  （字符型）  |
| phone       | 电话号码  （字符型）|
| address     | 用户地址   （字符型） |
| realname    | 用户真实姓名 （字符型）|

### 2.2 mobileClassify

储存手机的类别，例如可以按照系统分为IOS手机、安卓手机

| key  | 备注  |
|:----------|:----------|
| id    | 手机分类号（int,号码自动增加，主键）    |
| name | 手机分类的名称    |

### 2.3 mobileForm

mobileForm 表储存手机的基本信息

| key  | 备注  |
|:----------|:----------|
| mobile_version    | 手机的产品标识号，主键，字符型    |
| mobile_name    | 手机的名称，字符型   |
| mobile_made    | 手机的厂商，字符型    |
| mobile_price    | 手机的价格，单精度浮点型    |
| mobile_mess  | 手机的产品介绍，字符型    |
| mobile_pic   | 储存手机相关的一副图片的名字，字符型  |
| id  |  作为手机分类表mobileClassify的外键    |

### 2.4 shoppingForm 表的结构

用户选择商品添加到购物车之后，可能不会马上购买该商品。此处不使用 session 担当购物车的角色，毕竟session一旦销毁后购物车也会消失。所以我们使用数据库表存放购物车的手机们。

表：**shoppingForm** 如下：

| key  | 备注  |
|:----------|:----------|
| logname    | 注册的用户名，字符型，作为user表的logname外键    |
| goodsId    | 商品id,字符型    |
| goodsName    | 商品的名称，字符型   |
| goodsPrice   | 商品的单价，单精度浮点型    |
| goodsAmount | 商品的数量，int型    |

### 2.5 orderForm 表的结构

orderForm 表储存订单信息，主键是orderNumber

| key  | 备注  |
|:----------|:----------|
| orderNumber    | 储存的订单序号，int型，自增    |
| logname    | 储存注册的用户名，字符型    |
| mess    | 订单信息，字符型    |

### 2.6 插入数据

```sql
insert into mobileClassify values (1,'ios'),(2,'Android手机'); 

insert into mobileForm values 
("A2223","Apple iPhone11","苹果公司",5999,"128G 黑色","apple1.jpg", 1),
("A1699","Apple iPhone6S plus","苹果公司",3499,"128G 金色","apple2.jpg", 1),
("HW896","HUAWEI Mate30","华为公司",3444,"128G 白色","huawei1.jpg", 2),
("HW222","HUAWEI P30","华为公司",5000,"64G 黑色","huawei2.jpg", 2),
("XM1222","XIAOMI K50","小米公司",1222,"64G 绿色","xiaomi1.jpg", 2),
("XM199","XIAOMI note8","小米公司",899,"128G 紫色","xiaomi2.jpg", 2)
```

### 2.7 连接池连接数据库

```xml
<?xml version="1.0" encoding="utf-8" ?>
<Context>
    <Resource
            name="mobileConn"
            type="javax.sql.DataSource"
            driverClassName="com.mysql.cj.jdbc.Driver"
            url="jdbc:mysql://127.0.0.1:3306/mobileDatabase?useSSL=false&amp;serverTimezone=CST&amp;characterEncoding=utf-8"
            username="root"
            password="yjc010203."
            maxTotal="15"
            maxIdle="15"
            minIdle="1"
            maxWaitMillis="1000"
    />
</Context>
```

## 3. Web应用模块管理

采用 MVC 开发模式，即分为 JSP页面，JavaBean 和 Servlet 三个模块

### 3.1 页面管理

1. bean类的包名均为 save.data
2. servlet 类的包名均为 handle.data
3. 图片均在 webapp 下的 images 里
4. jsp 文件均在 webapp 目录下

### 3.2 主页和其他页面

主页和其他页面会共享一部分 html css 我们把它抽离至 Layout.jsp 中，在其他页面导入，在特定的 div 盒子里放置每个部分特殊的部分就行。

```jsp
<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <h1>欢迎光临小蜜蜂手机销售网主页</h1>
    </div>
</div>


<style>
    .changeArea {
        /*实现可变区域的居中*/
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translateX(-50%);
    }

    h1 {
        background-color: #8586e3;
    }
</style>

```

公共部分：

此处可以实现点击跳转不同的 servlet 服务。

```jsp
<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<style>
    .title {
        font-size: 58px;
        color: #ffba10;
        background-color: #8586e3;
    }

    .container {
        width: 100%;
        height: 100%;
        text-align: center;
        background: url("images/bees.jpeg");
    }

    .inner-box {
        margin: -30px auto;
        width: 1000px;
        height: 100px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #8586e3;
        border: #ffffff solid 2px;
        border-radius: 10px;
    }

    .list {
        width: 25%;
    }

    a {
        text-decoration: none;
        color: white;
        font-size: 20px;
    }

    a:hover {
        font-size: 25px;
    }
</style>

<div class="container">
    <p class="title">小蜜蜂手机销售网</p>
    <div class="inner-box">
        <div class="list">
            <a href="inputRegisterMess.jsp">注册</a>
        </div>
        <div class="list">
            <a href="login.jsp">登陆</a>
        </div>
        <div class="list">
            <a href="lookMobile.jsp">浏览手机</a>
        </div>
        <div class="list">
            <a href="searchMobile.jsp">查询手机</a>
        </div>
        <div class="list">
            <a href="lookShoppingCar.jsp">查看购物车</a>
        </div>
        <div class="list">
            <a href="lookOrderForm.jsp">查看订单</a>
        </div>
        <div class="list">
            <a href="exitServlet.jsp">退出登陆</a>
        </div>
        <div class="list">
            <a href="index.jsp">主页</a>
        </div>
    </div>
</div>
```

### 3.3 jsp 页面如何调用 servlet 

有关 jsp 页面如何调用 servlet 这里主要使用 form 表单元素的 action 属性指定 Servlet 的名称。在必要的情况下指定方法为 post

## 4. 会员注册

当新会员注册时，该模块要求用户必须输入会员名、密码、否则不允许注册。用户的注册信息存入数据库的user表。

### 4.1 视图（jsp页面）

该模块视图部分由一个jsp页面构成。

```jsp
<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="userBean" class="save.data.Register" scope="request"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <form action="registerServlet" method="post">
            <table id=c>
                <p id=c>用户名由字母、数字、下划线构成，*注释的项必须填写。</p>
                <tr>
                    <td>*用户名称:</td>
                    <td><input type=text id=c name="logname"/></td>
                    <td>*用户密码:</td>
                    <td><input type=password id=c name="password"></td>
                </tr>
                <tr>
                    <td>*重复密码:</td>
                    <td><input type=password id=c name="again_password"></td>
                    <td>联系电话:</td>
                    <td><input type=text id=c name="phone"/></td>
                </tr>
                <tr>
                    <td>邮寄地址:</td>
                    <td><input type=text id=c name="address"/></td>
                    <td>真实姓名:</td>
                    <td><input type=text id=c name="realname"/></td>
                    <td><input type=submit id=c value="提交"></td>
                </tr>
            </table>
        </form>
        <p id=c>注册反馈：</p>
        <jsp:getProperty name="userBean" property="backNews"/>
        <table id=c border=3>
            <tr>
                <td>ID:</td>
                <td>
                    <jsp:getProperty name="userBean" property="logname"/>
                </td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td>
                    <jsp:getProperty name="userBean" property="realname"/>
                </td>
            </tr>
            <tr>
                <td>地址:</td>
                <td>
                    <jsp:getProperty name="userBean" property="address"/>
                </td>
            </tr>
            <tr>
                <td>电话:</td>
                <td>
                    <jsp:getProperty name="userBean" property="phone"/>
                </td>
            </tr>
        </table>
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
        text-align: center;
    }

    h1 {
        background-color: #8586e3;
    }
</style>
```

### 4.2 模型（JavaBean）

用来存储用户注册的信息。此模块的 id 为 `userBean`,生命周期是 `request`。该 bean 由 servlet 控制器负责创建和更新。

```java
package save.data;

public class Register {
  String logname = "", phone = "", address = "", realname = "", backNews = "请输入信息";

  public void setLogname(String logname) {
    this.logname = logname;
  }

  public String getLogname() {
    return logname;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getPhone() {
    return phone;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getAddress() {
    return address;
  }

  public void setRealname(String realname) {
    this.realname = realname;
  }

  public String getRealname() {
    return realname;
  }

  public void setBackNews(String backNews) {
    this.backNews = backNews;
  }

  public String getBackNews() {
    return backNews;
  }
}

```

### 4.3 控制器（servlet）

servlet 控制器是 HandleRegister 类的实例，名字是 registerServlet。负责创建 id 是 userBean 的 requestbean。将用户信息写入 user 表。并将注册反馈信息储存到 userBean 中。然后转发到 inputRegisterMess.jsp 页面。另外，registerServlet 使用 Encrypt 类的 static 方法，将用户的密码加密后储存到数据库中。

>备注，这个项目使用 `javax.servlet.annotation.WebServlet` 这个包的方法`@WebServlet("/registerServlet")` 来注册 servlet 服务而不是使用 xml 文件的方法。

## 5. 会员登陆

Jsp 页面是 login.jsp,servlet名是 loginServlet,JavaBean 是 loginBean

### 5.1 JSP

职责是展示登陆反馈信息：`是否已经登陆`，`登陆是否成功`。

> 这边需要注意的点是，scope 作业域是 `session` 而不是 request
.
```jsp
<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="loginBean" class="save.data.Login" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网主页</title>


<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <form action="loginServlet" method="post">
            <table>
                <tr>
                    <td>登陆名称：
                        <label>
                            <input type="text" name="logname">
                        </label>
                    </td>

                </tr>
                <tr>
                    <td>输入密码：
                        <label>
                            <input type="password" name="password">
                        </label>
                    </td>
                </tr>
            </table>
            <input type="submit" value="提交">
        </form>
        <div>
            <p>登陆反馈：</p>
            <jsp:getProperty name="loginBean" property="backNews"/>
            <p>登陆名：
                <jsp:getProperty name="loginBean" property="logname"/>
            </p>
        </div>
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
```

### 5.2 JavaBean

```java
package save.data;

public class Login {
  String logname = "", backNews = "未登陆";

  public void setLogname(String logname) {
    this.logname = logname;
  }

  public String getLogname() {
    return logname;
  }

  public void setBackNews(String backNews) {
    this.backNews = backNews;
  }

  public String getBackNews() {
    return backNews;
  }
}

```

### 5.3 Servlet

职责是负责连接数据库，查询 user 表，验证用户名。

分为两种情况：

1. 已经注册过（正常情况，存在账号）。那么将用户设置成 已经登陆的状态。并将用户的名称放置到 sessionBean 中。并转发到 login.jsp 页面查询登陆反馈信息。
2. 没注册（新用户）。提示登陆失败。按理是要转发到 inputRegisterMess.jsp去注册。


## 6. 浏览手机

用户选择手分类机后,该模块可以用分页的方式显示 mobileform 表中的记录。

### 6.1 视图（jsp）

三个 JSP 页面，分别为：

- lookMobile.jsp
- byPageShow.jsp
- showDetail.jsp

对应功能为：

- 选择需要查看的分类的手机，例如选择查看 "安卓手机"；
- 展示查询出来的同一类目的手机列表，有分页功能；
- 其中一个手机的详情页

备注：查看分类的 servlet 是 `queryServlet`, 存放数据的 bean 是 `dataBean` ，是一个 sessionBean。


### 6.2 模型（bean）

本模块的 bean ID 是 `dataBaen` (Record_Bean 类的实例)，生命周期是 session ，用于储存数据库中的记录。servlet 控制器 `queryServlet` 用来把数据库查询的记录存在 `dataBean`。

### 6.3 控制器（servlet）

本模块有两个控制器 
- `queryServlet`(QueryAllRecord 类的实例)；
- `putGoodsServlet`(PutGoodsToCar 类的实例)，

queryServlet 把数据库查询到的结果存在 bean 中后，重定向到 `byPageShow.jsp` 页面。
当用户在 `byPageShow.jsp`或者 `showDetail.jsp`页面，商品的后面都跟随着一个 “添加至购物车”的超链接。当点击后， `putGoodsServlet` 控制器将该产品放入用户的购物车，**当然此时会向数据库表 `shoppingFrom` 中插入数据**。

## 7. 查看购物车

登录的用户可以通过该模型视图部分 `lookShoppingCart.jsp` 查看购物车中的商品，并选择是否删除某个商品或者更新商品的数量。该模块有 `updateServlet`、`deleteServlet` 和 `buyServlet` 三个控制器。其中 `buyServlet` 负责将用户信息存放到数据库的 `orderform` 表中，即生成订单。

### 7.1 视图

`lookShoppingCart.jsp` 负责显示购物车的商品，修改购物车商品和生成订单的功能

### 7.2 模型（bean）

比较简单，使用 loginBean 验证是否登录即可

### 7.3 控制器（servlet）

三个控制器

1. deleteServlet
2. updateServlet
3. buyServlet

当用户点击购物车时，不仅可以看到购物车中的物品，还可以点击删除、更新按钮。分别触发 `deleteServlet `和 `updateServlet`。点击“生成订单”按钮触发 `buyServlet` 负责将购物车的商品信息存在 `orderform` 数据表中。同时删除购物车中的商品。

## 8. 查询手机

本模块用到了 `dataBean` 和 视图 `byPageShow.jsp`。在视图部分 `searchMobile.jsp` 输入查询条件给 servlet 控制器 `searchByConditionServlet`(SearchByCondition类的实例)，`searchByConditionServlet` 控制器负责查询数据库，并将查询结果存在数据模型 dataBaen 中，然后将用户重定向到 `byPageShow.jsp` 页面查看 dataBean 中的数据。

### 8.1 视图（JSP）

视图分为两个JSP 页面 `searchMobile.jsp `和 `byPageShow.jsp` 构成。用户在 `searchMobile.jsp` 页面输入查询信息。提交给 `searchByConditionServlet` 控制器，该控制器将查询的结果存放在 dataBean 中。`byPageShow.jsp` 页面负责显示 dataBean 中的数据。

### 8.2 模型（Bean）

id 为 dataBean 的 session Bean

### 8.3 控制器（servlet）

`searchByConditionServlet` 把数据库 `mobileForm` 表中的数据查询到的记录存在 `dataBean`中，然后重定向 `byPageShow.jsp` 页面


## 9. 查询订单

视图部分由 JSP 页面 lookOrderForm.jsp 构成，负责显示用户的订单信息。

使用了 loginBean

这里没有控制器，在 <% %> 里写数据库逻辑

## 10. 退出登录

该模块只有一个名为 exitServlet 的 servlet 控制器。用户单击导航条上的“退出登录”以触发。指责是负责销毁用户的 session 对象。

至此，简单的项目完成



















