<%@page contentType="text/html; charset=UTF-8" language="java"
    import="java.text.*,org.json.JSONObject, java.util.ArrayList, java.io.PrintWriter"
    import="java.util.HashMap, java.util.List, java.sql.*, java.util.Map, java.io.IOException" %>
<%   
    String keyValue=request.getParameter("key_value");

    List jsonList=new ArrayList();
    try{
        Class.forName("com.mysql.jdbc.Driver");
    }catch(ClassNotFoundException e){
        e.printStackTrace();
    }
    System.out.println("getData-------------------成功加载驱动！");

    try{
        Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?user=root&password=1111&useUnicode=true&characterEncoding=UTF-8");
        Statement statement=conn.createStatement();
        System.out.println("getData---------------db connected！");

        String sql="select * from gis_feature";
        ResultSet rs=statement.executeQuery(sql);
        int count=0;
        while(rs.next()) {
            count++;
            Map map=new HashMap();
            map.put("index",count);
            map.put("feature_id",rs.getString("feature_id"));
            map.put("feature_type",rs.getString("feature_type"));
            map.put("feature_name",rs.getString("feature_name"));
            map.put("longitude",rs.getString("longitude"));
            map.put("latitude",rs.getString("latitude"));
            map.put("geometry",rs.getString("geometry"));
            jsonList.add(map);
        }
        statement.close();
        conn.close();
        //sql=sql+" values(' aaaaa','"+featureName+"','"+type+"',"+lon++","+lat+",'"+wkt+"','0000001',1,'0000001','"+nowTime+"')";
    }catch(SQLException e){
        e.printStackTrace();
    }

    JSONObject json=new JSONObject();
    json.put("aaData",jsonList);
    json.put("result_msg","ok");
    json.put("result_code",0);
    System.out.println("json: "+json.toString());
    response.setContentType("application/json; charset=UTF-8");
    try{
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
    }catch(IOException e){
        e.printStackTrace();
    }

%>