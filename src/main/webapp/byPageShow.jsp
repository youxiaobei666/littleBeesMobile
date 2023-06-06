<%@ page contentType="text/html;" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="dataBean" class="save.data.Record_Bean" scope="session"/>
<link rel="icon" href="images/icon.ico">
<title>小蜜蜂手机销售网</title>

<div class="page">
    <%@ include file="Layout.jsp" %>
    <div class="changeArea">
        <%--以后更换一下内容就行，其他部分通用--%>
        <jsp:setProperty name="dataBean" property="pageSize" param="pageSize"/>
        <jsp:setProperty name="dataBean" property="currentPage" param="currentPage"/>
        <table id=i>
            <% String[][] table = dataBean.getTableRecord();
                if (table == null) {
                    out.print("没有记录");
                    return;
                }
            %>
            <tr>
                <th>手机标识号</th>
                <th>手机名称</th>
                <th>手机制造商</th>
                <th>手机价格</th>
                <th>查看细节</th>
                <th>添加到购物车</th>
            </tr>
            <% int totalRecord = table.length;
                int pageSize = dataBean.getPageSize();  //每页显示的记录数。
                int totalPages;
                if (totalRecord % pageSize == 0)
                    totalPages = totalRecord / pageSize;//总页数。
                else
                    totalPages = totalRecord / pageSize + 1;
                dataBean.setPageSize(pageSize);
                dataBean.setTotalPages(totalPages);
                if (totalPages >= 1) {
                    if (dataBean.getCurrentPage() < 1)
                        dataBean.setCurrentPage(dataBean.getTotalPages());
                    if (dataBean.getCurrentPage() > dataBean.getTotalPages())
                        dataBean.setCurrentPage(1);
                    int index = (dataBean.getCurrentPage() - 1) * pageSize;
                    int start = index;  //table的currentPage页起始位置。
                    for (int i = index; i < pageSize + index; i++) {
                        if (i == totalRecord)
                            break;
                        out.print("<tr>");
                        for (int j = 0; j < table[0].length; j++) {
                            out.print("<td>" + table[i][j] + "</td>");
                        }
                        String detail =
                                "<a href ='showDetail.jsp?mobileID=" + table[i][0] + "'>手机详情</a>";
                        out.print("<td>" + detail + "</td>");
                        String shopping =
                                "<a href ='putGoodsServlet?mobileID=" + table[i][0] + "'>添加到购物车</a>";
                        out.print("<td>" + shopping + "</td>");
                        out.print("</tr>");
                    }
                }
            %>
        </table>
        <p id=i>
            <jsp:getProperty name="dataBean" property="currentPage"/>
            /
            <jsp:getProperty name="dataBean" property="totalPages"/>
            <br>
        </p>
        <table id=i>
            <tr>
                <td>
                    <form action="" method=post>
                        <input type=hidden name="currentPage" value="<%=dataBean.getCurrentPage()-1 %>"/>
                        <input type=submit id=i value="上一页"/>
                    </form>
                </td>
                <td>
                    <form action="" method=post>
                        <input type=hidden name="currentPage" value="<%=dataBean.getCurrentPage()+1 %>"/>
                        <input type=submit id=i value="下一页">
                    </form>
                </td>

                <td>
                    <form action="" id=i method=post>
                        跳转到<input type=text id=i name="currentPage" size=2>页。<input type=submit id=i value="确定">
                    </form>
                </td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td>
                    <form action="" id=i method=post>
                        每页显示<input type=text id=i name="pageSize" value=<%=dataBean.getPageSize()%> size=2>/
                        <jsp:getProperty name="dataBean" property="totalRecords"/>
                        件产品<input type=submit id=i value="确定">
                    </form>
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
        transform: translateX(-50%);

        background-color: #8586e3;
    }

    h1 {
        background-color: #8586e3;
    }
</style>

