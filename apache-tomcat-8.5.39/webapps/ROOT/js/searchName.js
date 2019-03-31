var xFeatureStyle = new ol.style.Style({
    image: new ol.style.Icon({
      opacity: 0.95,
      size: [52, 52],
      src: "./img/map3.png"
    }),
  });

function updateFilterByName() {

    var filterByName = document.getElementById('filterByName').value;
    if(filterByName === ''){
      // return;
      filterByName="+"
    }

    // generate a GetFeature request
    var featureRequest = new ol.format.WFS().writeGetFeature({
      srsName: 'EPSG:4326',
      featureNS: 'http://localhost:8080',    //命名空间
      featurePrefix: 'scmap',               //工作区域
      featureTypes: ['djs'],       //图层名
      outputFormat: 'application/json',
      filter:
        ol.format.filter.like('Name', '*' + filterByName + '*')
    });

    // then post the request and add the received features to a layer
    var featuresList = [];

    fetch('http://localhost:8080/geoserver/wfs', {
      method: 'POST',
      body: new XMLSerializer().serializeToString(featureRequest)
    })
      .then(function (response) {
        return response.json()
      })
      .then(function (json) {
        console.log(json)
        var features = new ol.format.GeoJSON().readFeatures(json);

        var vectorSource1 = new ol.source.Vector({});

        for (var item of json.features) {
          var px = item.properties.POINT_X;
          var py = item.properties.POINT_Y;
          var point = new ol.geom.Point([px, py], "XY")
          var xFeature = new ol.Feature({
            geometry: point,
            name: item.properties.Name,
          });
          console.log(xFeature.name)
          featuresList.push(xFeature)
          xFeature.setStyle(xFeatureStyle)
          vectorSource1.addFeature(xFeature);
        }

        document.getElementById("popup").style.display="block";

        //popup
        var container = document.getElementById("popup");
        var content = document.getElementById("popup-content");
        var popupCloser = document.getElementById("popup-closer");
        var overlay = new ol.Overlay({
          //设置弹出框的容器
          element: container,
          //是否自动平移，即假如标记在屏幕边缘，弹出时自动平移地图使弹出框完全可见
          autoPan: true
        });

        var vectorLayer1 = new ol.layer.Vector({
          source: vectorSource1,
        });
        map.addLayer(vectorLayer1)
        //map.addOverlay(overlay)

         popupCloser.onclick = function () {
            overlay.setPosition(undefined);
            popupCloser.blur();
            return false;
          };
        
        console.log("before click")
        map.on('click', function (e) {
          map.addOverlay(overlay);
          console.log("after click")
          //在点击时获取像素区域
          var pixel = map.getEventPixel(e.originalEvent);
          map.forEachFeatureAtPixel(pixel, function (feature) {
            for (var itm of featuresList) {
              //coodinate存放了点击时的坐标信息
              var coodinate = e.coordinate;
              //设置弹出框内容，可以HTML自定义


              var content = document.getElementById("popup-content");

              //设置overlay的显示位置
              if (feature === itm) {
                content.innerHTML = "<p>"+itm.get('name')+"("+
                itm.getGeometry().getCoordinates()+")</p>";
                break;
              }
            }
            
            overlay.setPosition(coodinate);
            //显示overlay
          });
        });

   

      });

}



  function resetFilterByName(){
    document.getElementById('filterByName').value=''
    window.location.reload(true);
    //updateFilterByName();
  }

  // map.on('click', function (e) {
  //     //在点击时获取像素区域
  //     var pixel = map.getEventPixel(e.originalEvent);
  //     map.forEachFeatureAtPixel(pixel, function (feature) {
  //       //coodinate存放了点击时的坐标信息
  //       var coodinate = e.coordinate;
  //       //设置弹出框内容，可以HTML自定义

  //       var content = document.getElementById("popup-content");
  //       content.innerHTML = "<p>This is the library of Sichuan University on Jiangan campus.</p>" 

        
  //       // //设置overlay的显示位置
  //       // if (feature == libraryFeature) {
  //       //   content.innerHTML = "<p>This is the library of Sichuan University on Jiangan campus.</p>" +
  //       //     "<a target='_blank' href='https://baike.baidu.com/item/%E5%9B%9B%E5%B7%9D%E5%A4%A7%E5%AD%A6%E5%9B%BE%E4%B9%A6%E9%A6%86/5267732'>"
  //       //     + "<img src='library_photo.jpg' width='300'/></a>";
  //       // }
  //       // if (feature == gateFeature) {
  //       //   content.innerHTML = "<p>This is the south gate of the Jiangan campus of Sichuan University.</p>" +
  //       //     "<a target='_blank' href='https://baike.baidu.com/item/%E5%9B%9B%E5%B7%9D%E5%A4%A7%E5%AD%A6%E6%B1%9F%E5%AE%89%E6%A0%A1%E5%8C%BA'>"
  //       //     + "<img src='southgate_photo.jpg' width='300'/></a>";
  //       // }
  //       // if (feature == buildingFeature) {
  //       //   content.innerHTML = "<p>This is the teaching building on the Wangjiang campus of Sichuan University.</p>" +
  //       //     "<a target='_blank' href='https://baike.baidu.com/item/%E5%9B%9B%E5%B7%9D%E5%A4%A7%E5%AD%A6%E6%9C%9B%E6%B1%9F%E6%A0%A1%E5%8C%BA/5022226?fr=aladdin'>"
  //       //     + "<img src='building_photo.jpg' width='300'/></a>";
  //       // }
  //       overlay.setPosition(coodinate);
  //       //显示overlay
  //       map.addOverlay(overlay);
  //     });
  //   });

    // popupCloser.onclick = function () {
    //   overlay.setPosition(undefined);
    //   popupCloser.blur();
    //   return false;
    // };