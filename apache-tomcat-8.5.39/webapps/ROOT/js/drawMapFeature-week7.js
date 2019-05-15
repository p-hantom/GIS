var measureTooltipElement = document.getElementById("measure");
function createMeasureTooltip() {
    
    if (measureTooltipElement) {
        measureTooltipElement.parentNode.removeChild(measureTooltipElement);
    }
    measureTooltipElement = document.createElement('div');
    measureTooltipElement.className = 'tooltip tooltip-measure';
    measureTooltip = new ol.Overlay({
        element: measureTooltipElement,
        offset: [0, -15],
        positioning: 'bottom-center'
    });
    map.addOverlay(measureTooltip);

    console.log("tooltip")
}

createMeasureTooltip(); //创建测量工具提示框
var listener;

function getFeature(){
    var url="get_data.jsp";
    $.post(url, function(json){
        console.log("返回的数据是："+JSON.stringify(json));
        displayFeatures(json);
        resultSet=json;
    })
}

function getFeatureName(e){
    let pixel=map.getEventPixel(e.originalEvent);
    let feature=map.forEachFeatureAtPixel(pixel, function(feature,layer){
        return feature;
    });
    if(feature){
        return feature.get('name');
    }else{
        return "";
    }
}

function drawFeature(type){
    map.removeInteraction(draw);
    addInteraction(type);
}

function addInteraction(value){
    if(value != 'None'){
        draw  = new ol.interaction.Draw({
            source: source,
            type: (value)
        });
        draw.on('drawstart',drawStart);
        draw.on('drawend',drawEnd);
        map.addInteraction(draw);
    }
}




var pointSelect=undefined;

function drawStart(evt){
    console.log("start drawing");
    showCurrentMeasure(evt);
}

function drawEnd(){
    console.log("end drawing");
    measureTooltipElement.className = 'tooltip tooltip-static'; //设置测量提示框的样式
    measureTooltip.setOffset([0, -7]);
    // unset sketch
    sketch = null; //置空当前绘制的要素对象
    // unset tooltip so that a new one can be created
    measureTooltipElement = null; //置空测量工具提示框对象
    createMeasureTooltip(); //重新创建一个测试工具提示框显示结果


    map.removeInteraction(draw);
}

var formatLength = function(line) {
    var length;
    if (1) { //若使用测地学方法测量
        var coordinates = line.getCoordinates(); //解析线的坐标
        length = 0;
        var sourceProj = map.getView().getProjection(); //地图数据源投影坐标系
        //通过遍历坐标计算两点之前距离，进而得到整条线的长度
        for (var i = 0, ii = coordinates.length - 1; i < ii; ++i) {
            var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
            var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
            length += wgs84Sphere.haversineDistance(c1, c2);
        }
    } else {
        length = Math.round(line.getLength() * 100) / 100; //直接得到线的长度
    }
    var output;
    if (length > 100) {
        output = (Math.round(length / 1000 * 100) / 100) + ' ' + 'km'; //换算成KM单位
    } else {
        output = (Math.round(length * 100) / 100) + ' ' + 'm'; //m为单位
    }
    return output; //返回线的长度
};
/**
 * 测量面积输出
 */
var formatArea = function(polygon) {
    var area;
    if (1) { //若使用测地学方法测量
        var sourceProj = map.getView().getProjection(); //地图数据源投影坐标系
        var geom = /** @type {ol.geom.Polygon} */ (polygon.clone().transform(sourceProj, 'EPSG:4326')); //将多边形要素坐标系投影为EPSG:4326
        var coordinates = geom.getLinearRing(0).getCoordinates(); //解析多边形的坐标值
        area = Math.abs(wgs84Sphere.geodesicArea(coordinates)); //获取面积
    } else {
        area = polygon.getArea(); //直接获取多边形的面积
    }
    var output;
    if (area > 10000) {
        output = (Math.round(area / 1000000 * 100) / 100) + ' ' + 'km<sup>2</sup>'; //换算成KM单位
    } else {
        output = (Math.round(area * 100) / 100) + ' ' + 'm<sup>2</sup>'; //m为单位
    }
    return output; //返回多边形的面积
};

var wgs84Sphere = new ol.Sphere(6378137)

var tooltipCoord=undefined;
function showCurrentMeasure(evt){
    var sketch = evt.feature;
    listener = sketch.getGeometry().on('change',function(evt){
        var geom = evt.target;
        var output;
        if(geom instanceof ol.geom.Polygon){
            output = formatArea(geom);
            tooltipCoord = geom.getInteriorPoint().getCoordinates();
        }
        else if(geom instanceof ol.geom.LineString){
            output = formatLength(geom);
            tooltipCoord = geom.getLastCoordinate();
        }
        console.log(tooltipCoord);
        measureTooltipElement.innerHTML=output;
        // measureTooltipElement.setPosition(tooltipCoord) //--------
        measureTooltip.setPosition(tooltipCoord);
    })
}
//------------------------------------------------------------------
var selected=0;

function pointSelect1(){
    selected=1;
    pointSelect = new ol.interaction.Select();
    addSelection(pointSelect);
}

function addSelection(select){
    map.addInteraction(select);
    console.log("map.addInteraction(select) " );
    select.on("select", function(e){
        let features = e.selected;
        let feature = features[0];
        console.log("feature: " + feature);
        if(feature != undefined){
            console.log("get feature: " + feature);
            console.log("getWKT=" + getWKT(feature));
            let coordinate = e.mapBrowserEvent.coordinate;
            let hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate,'EPSG:3857','EPSG:4326'));
            let html = "<div>请输入名字：<input type='text' id='drawMapFeature_name'><p>坐标是：["+coordinate[0]+","+coordinate[1]+"]<p>获得的WKT: "+getWKT(feature)+"</p></p></div>"
            console.log("coordinate = "+coordinate);
            init1(map,coordinate,html);

            featureWKT=getWKT(feature);
            featureType="Polygon";
            featureLon=coordinate[0];
            featureLat=coordinate[1];
        }
    })
}

function getWKT(feature){
    let strwkt = new ol.format.WKT().writeFeature(feature, {
        dataProjection: 'EPSG:4326',
        featureProjection: 'EPSG:4326',
    })
    return strwkt;
}

function saveFeature(){
    let featureName=$("#drawMapFeature_name").val();
    // let url="save_data2.jsp"
     let url="save_data.jsp?type="+featureType+"&drawMapFeature_name="+featureName+
             "&wkt="+featureWKT+"&lon="+featureLon+"&lat="+featureLat;
    console.log(url);
    $.post(url, function(json){
        console.log("返回的数据: "+JSON.stringify(json));
        resultSet=json;
    })
}

function displayFeatures(json){
    let list=json.aaData;
    for(let i=0;i<list.length;i++){
        let j=list[i];
        displayFeature(j);
    }
}

function displayFeature(json){
    let type=json.feature_type;
    let title=json.feature_name;
    let lon=json.longitude;
    let lat=json.latitude;
    let geometry=json.geometry;
    
    let wktformat=new ol.format.WKT();
    let feature=wktformat.readFeature(geometry);
    feature.getGeometry().transform('EPSG:4326','EPSG:4326');
    feature.set("name",title);
    myLayer.getSource().addFeature(feature);
}