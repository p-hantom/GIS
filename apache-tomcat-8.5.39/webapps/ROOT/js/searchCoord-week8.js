var coordSearchFeatureStyle = new ol.style.Style({
    image: new ol.style.Icon({
      opacity: 1,
      size: [52, 52],
      src: "./img/map2.png"
  })
});

function updateCoord(){
    let longitude = document.getElementById('longitude').value;
    let latitude = document.getElementById('latitude').value;

    console.log(longitude+" "+latitude)

    if(longitude === '' || latitude === ''){
       return;
    }

    var searchPoint = new ol.geom.Point([longitude, latitude], "XY")
    var coordSearchFeature = new ol.Feature({
        geometry: searchPoint,
    });
    coordSearchFeature.setStyle(coordSearchFeatureStyle)

    console.log(searchPoint)

    var vectorSource = new ol.source.Vector({});
    vectorSource.addFeature(coordSearchFeature)
    var vectorLayer = new ol.layer.Vector({
        source: vectorSource,
    });
    map.addLayer(vectorLayer)

    //popup
    var container2 = document.getElementById("popup");
    var content2 = document.getElementById("popup-content");
    var popupCloser2 = document.getElementById("popup-closer");
    var overlay2 = new ol.Overlay({
      //设置弹出框的容器
      element: container2,
      //是否自动平移，即假如标记在屏幕边缘，弹出时自动平移地图使弹出框完全可见
      autoPan: true
    });

    popupCloser2.onclick = function () {
        overlay2.setPosition(undefined);
        popupCloser2.blur();
        return false;
      };
      

      map.on('click', function (e) {

        map.addOverlay(overlay2);
        //在点击时获取像素区域
        var pixel = map.getEventPixel(e.originalEvent);
        map.forEachFeatureAtPixel(pixel, function (feature) {
            //coodinate存放了点击时的坐标信息
            var coodinate = e.coordinate;
            //设置弹出框内容，可以HTML自定义
            console.log("ok")

            let content = document.getElementById("popup-content");

            //设置overlay的显示位置
            if (feature === coordSearchFeature) {
                console.log("feature === coordSearchFeature")
              let minPoint=getClosestPoint(longitude,latitude)
              console.log(minPoint)
              content.innerHTML = "<p>("+
              coordSearchFeature.getGeometry().getCoordinates()+")</p>"+
              "<p>the closest point is: "+minPoint.name+"</p><p>distance: "+
              minPoint.dist+"</p>";
              
              if(document.getElementById("popup"))
                 document.getElementById("popup").style.display="block";
            }
          
          overlay2.setPosition(coodinate);
          //显示overlay
        });
      });

}

function resetCoord(){
    document.getElementById('longitude').value=''
    document.getElementById('latitude').value=''
    window.location.reload(true);
}

function getClosestPoint(x, y){
    let min=100000000;
    let minPoint;
    for(let item of djsPointList){
        let wgs84Sphere = new ol.Sphere(6378137); 
        let dist=wgs84Sphere.haversineDistance([x,y],item.point);
        if(dist<min){
            min=dist;
            minPoint=item;
            minPoint.dist=dist;
        } 
    }  
    return minPoint;
}