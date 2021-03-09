<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册成功页面</title>
</head>
<body>
<%
    Context ctx = null;
    DataSource ds = null;
    Statement stmt = null;
    ResultSet rs = null;
    Connection con = null;
    String name = request.getParameter("name").trim();//去除首尾空格
    String password = request.getParameter("password").trim();
    String refill = request.getParameter("refill").trim();
    String email = request.getParameter("email").trim();
    String phoneNumber = request.getParameter("phoneNumber").trim();
    try {
        //        ctx = new InitialContext();
        //        ds = (DataSource)ctx.lookup("java:comp/env/derby");
//        con = ds.getConnection();
        String url = "jdbc:derby:Databases/UserPlatformDB;create=true";
        con = DriverManager.getConnection(url, "", "");

        stmt = con.createStatement();
//        stmt.execute("CREATE TABLE users(\n" +
//                "id INT NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),\n" +
//                "name VARCHAR(16) NOT NULL,\n" + "password VARCHAR(64) NOT NULL,\n" + "email VARCHAR(64) NOT NULL,\n" +
//                "phoneNumber VARCHAR(32) NOT NULL)");
        if (name != null) {
            rs = stmt.executeQuery("select * from USERS where name='" + name + "'");

            if (rs.next()) {
                out.print("用户已经存在  " + "请<a href=\"registered.jsp\">注册</a>");
            } else {
                if (password.equals(refill)) {
                    stmt.executeUpdate("insert into users(name,password,email,phoneNumber) values('" + name + "','" +
                            password + "','" + email + "','" + phoneNumber + "')");
%>
注册成功<br>
三秒钟后自动转到登录页面<br>
如果没有跳转，请点击<a href="login.jsp">这里</a>
<span style="font-size:24px;"><meta http-equiv="refresh" content="3;URL=login.jsp"> </span>
<%
                } else {
                    out.print("密码输入不一致!!!<br>" + "重新<a href=\"registered.jsp\">注册</a>");
                }
            }
        } else {
            out.print("姓名不能为空");
        }
    } catch (Exception e) {
        out.print(e);
    } finally {
        if (rs != null) {
            rs.close();
        }
        if (stmt != null) {
            stmt.close();
        }
        if (con != null) {
            con.close();
        }
    }
%>

</body>
</html>