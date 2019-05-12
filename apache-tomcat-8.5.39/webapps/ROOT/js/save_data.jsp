<%@page contentType="text/html; charset=UTF-8" language="java"
    import="java.text.*,org.json.JSONObject, java.util.ArrayList, java.io.PrintWriter"
    import="java.util.HashMap, java.util.List, java.sql.*, java.util.Map, java.io.IOExceptioin" %>
    
    String lon=request.getParameter("lon");
    String lat=request.getParameter("lat");
    String type=request.getParameter("type");
    String wkt=request.getParameter("wkt");
    String featureName=request.getParameter("drawMapFeature_name");

    String nowTime=(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new java.util.Date());

    List jsonList=new ArrayList();
    try{
        Class.forName("com.mysql.jdbc.Driver");
    }catch(ClassNotFoundException e){
        e.printStackTrace();
    }
    System.out.println("成功加载驱动！");

    try{
        Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?user=root&password=root&useUnicode=true&characterEncoding=UTF-8");
        Statement statement=conn.createStatement();
        System.out.println("db connected！");

        String sql="insert into gis_feature(feature_id,feature_name,feature_type,longitude,latitude,geometry,user_id,used_tag,creator_id,create_time)";
        sql=sql+" values(' aaaaa','"+featureName+"','"+type+"',"+lon++","+lat+",'"+wkt+"','0000001',1,'0000001','"+nowTime+"')";
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