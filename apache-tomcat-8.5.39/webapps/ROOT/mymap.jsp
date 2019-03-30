
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="http://localhost:8080/geoserver/openlayers3/ol.css" type="text/css">
    <style>
        .ol-zoom {
          top: 52px;
        }
        .ol-toggle-options {
          z-index: 1000;
          background: rgba(255,255,255,0.4);
          border-radius: 4px;
          padding: 2px;
          position: absolute;
          left: 8px;
          top: 8px;
        }
        #updateFilterButton, #resetFilterButton {
          height: 22px;
          width: 22px;
          text-align: center;
          text-decoration: none !important;
          line-height: 22px;
          margin: 1px;
          font-family: 'Lucida Grande',Verdana,Geneva,Lucida,Arial,Helvetica,sans-serif;
          font-weight: bold !important;
          background: rgba(0,60,136,0.5);
          color: white !important;
          padding: 2px;
        }
        .ol-toggle-options a {
          background: rgba(0,60,136,0.5);
          color: white;
          display: block;
          font-family: 'Lucida Grande',Verdana,Geneva,Lucida,Arial,Helvetica,sans-serif;
          font-size: 19px;
          font-weight: bold;
          height: 22px;
          line-height: 11px;
          margin: 1px;
          padding: 0;
          text-align: center;
          text-decoration: none;
          width: 22px;
          border-radius: 2px;
        }
        .ol-toggle-options a:hover {
          color: #fff;
          text-decoration: none;
          background: rgba(0,60,136,0.7);
        }
        body {
            font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
            font-size: small;
        }
        iframe {
            width: 100%;
            height: 250px;
            border: none;
        }
        /* Toolbar styles */
        #toolbar {
            position: relative;
            padding-bottom: 0.5em;
        }
        #toolbar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        #toolbar ul li {
            float: left;
            padding-right: 1em;
            padding-bottom: 0.5em;
        }
        #toolbar ul li a {
            font-weight: bold;
            font-size: smaller;
            vertical-align: middle;
            color: black;
            text-decoration: none;
        }
        #toolbar ul li a:hover {
            text-decoration: underline;
        }
        #toolbar ul li * {
            vertical-align: middle;
        }
        #map {
            clear: both;
            position: relative;
            width: 768px;
            height: 567px;
            border: 1px solid black;
        }
        #wrapper {
            width: 768px;
        }
        #location {
            float: right;
        }
        /* Styles used by the default GetFeatureInfo output, added to make IE happy */
        table.featureInfo, table.featureInfo td, table.featureInfo th {
            border: 1px solid #ddd;
            border-collapse: collapse;
            margin: 0;
            padding: 0;
            font-size: 90%;
            padding: .2em .1em;
        }
        table.featureInfo th {
            padding: .2em .2em;
            font-weight: bold;
            background: #eee;
        }
        table.featureInfo td {
            background: #fff;
        }
        table.featureInfo tr.odd td {
            background: #eee;
        }
        table.featureInfo caption {
            text-align: left;
            font-size: 100%;
            font-weight: bold;
            padding: .2em .2em;
        }
        .ol-popup {
      position: absolute;
      background-color: white;
      -webkit-filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
      filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
      padding: 15px;
      border-radius: 10px;
      border: 1px solid #cccccc;
      bottom: 12px;
      left: -50px;
      min-width: 280px;
    }

    .ol-popup:after,
    .ol-popup:before {
      top: 100%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .ol-popup:after {
      border-top-color: white;
      border-width: 10px;
      left: 48px;
      margin-left: -10px;
    }

    .ol-popup:before {
      border-top-color: #cccccc;
      border-width: 11px;
      left: 48px;
      margin-left: -11px;
    }

    .ol-popup-closer {
      text-decoration: none;
      position: absolute;
      top: 2px;
      right: 8px;
    }

    .ol-popup-closer:after {
      content: "close";
    }
    </style>
    <!-- <script src="http://localhost:8080/geoserver/openlayers3/ol.js" type="text/javascript"></script> -->
    <script src="http://localhost:8080/ol.js" type="text/javascript"></script>

    <!-- <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script> -->
    <title>OpenLayers map preview</title>
  </head>
  <body>
    <div id="toolbar" style="display: none;">
      <ul>
        <li>
          <a>WMS version:</a>
          <select id="wmsVersionSelector" onchange="setWMSVersion(value)">
            <option value="1.1.1">1.1.1</option>
            <option value="1.3.0">1.3.0</option>
          </select>
        </li>
        <li>
          <a>Tiling:</a>
          <select id="tilingModeSelector" onchange="setTileMode(value)">
            <option value="untiled">Single tile</option>
            <option value="tiled">Tiled</option>
          </select>
        </li>
        <li>
          <a>Antialias:</a>
          <select id="antialiasSelector" onchange="setAntialiasMode(value)">
            <option value="full">Full</option>
            <option value="text">Text only</option>
            <option value="none">Disabled</option>
          </select>
        </li>
        <li>
          <a>Format:</a>
          <select id="imageFormatSelector" onchange="setImageFormat(value)">
            <option value="image/png">PNG 24bit</option>
            <option value="image/png8">PNG 8bit</option>
            <option value="image/gif">GIF</option>
            <option id="jpeg" value="image/jpeg">JPEG</option>
            <option id="jpeg-png" value="image/vnd.jpeg-png">JPEG-PNG</option>
          </select>
        </li>
        <li>
          <a>Styles:</a>
          <select id="imageFormatSelector" onchange="setStyle(value)">
            <option value="">Default</option>
          </select>
        </li>
        <li>
          <a>Width/Height:</a>
          <select id="widthSelector" onchange="setWidth(value)">
             <!--
             These values come from a statistics of the viewable area given a certain screen area
             (but have been adapted a litte, simplified numbers, added some resolutions for wide screen)
             You can find them here: http://www.evolt.org/article/Real_World_Browser_Size_Stats_Part_II/20/2297/
             --><option value="auto">Auto</option>
                <option value="600">600</option>
                <option value="750">750</option>
                <option value="950">950</option>
                <option value="1000">1000</option>
                <option value="1200">1200</option>
                <option value="1400">1400</option>
                <option value="1600">1600</option>
                <option value="1900">1900</option>
            </select>
            <select id="heigthSelector" onchange="setHeight(value)">
                <option value="auto">Auto</option>
                <option value="300">300</option>
                <option value="400">400</option>
                <option value="500">500</option>
                <option value="600">600</option>
                <option value="700">700</option>
                <option value="800">800</option>
                <option value="900">900</option>
                <option value="1000">1000</option>
            </select>
          </li>
          <li>
              <a>Filter:</a>
              <select id="filterType">
                  <option value="cql">CQL</option>
                  <option value="ogc">OGC</option>
                  <option value="fid">FeatureID</option>
                  <option value="name">Name</option>
                  <option value="name">Pop</option>
              </select>
              <input type="text" size="80" id="filter"/>
              <a id="updateFilterButton" href="#" onClick="updateFilter()" title="Apply filter">Apply</a>
              <a id="resetFilterButton" href="#" onClick="resetFilter()" title="Reset filter">Reset</a>
          </li>
        </ul>
      </div>

      <div id="popup" class="ol-popup">
        <a href="#" id="popup-closer" class="ol-popup-closer"></a>
        <div id="popup-content"></div>
      </div>
      <!-- *********** -->
    <div>
      <p>enter:</p>
      <input type="text" size="80" id="filterByName" value="成"/> 
      <a id="updateFilterByNameButton" href="#" onClick="updateFilterByName()" title="Apply filter">Search</a>
      <a id="resetFilterByNameButton" href="#" onClick="resetFilterByName()" title="Reset filter">Reset</a>
    </div>

    <!-- *********** -->
    

    <div id="map">
      <div class="ol-toggle-options ol-unselectable"><a title="Toggle options toolbar" onClick="toggleControlPanel()" href="#toggle">...</a></div>
    </div>

    <!-- <div id="popup" class="ol-popup">
      <a href="#" id="popup-closer" class="ol-popup-closer"></a>
      <div id="popup-content"></div>
    </div> -->

    <div id="wrapper">
        <div id="location"></div>
        <div id="scale">
    </div>
    <div id="nodelist">
        <em>Click on the map to get feature info</em>
    </div>
    <script type="text/javascript">
      var pureCoverage = false;
      // if this is just a coverage or a group of them, disable a few items,
      // and default to jpeg format
      var format = 'image/png';
      var bounds = [97.352221, 26.049173,
                    108.542372, 34.314673];
      if (pureCoverage) {
        document.getElementById('antialiasSelector').disabled = true;
        document.getElementById('jpeg').selected = true;
        format = "image/jpeg";
      }

      var supportsFiltering = true;
      if (!supportsFiltering) {
        document.getElementById('filterType').disabled = true;
        document.getElementById('filter').disabled = true;
        document.getElementById('updateFilterButton').disabled = true;
        document.getElementById('resetFilterButton').disabled = true;
      }

      var mousePositionControl = new ol.control.MousePosition({
        className: 'custom-mouse-position',
        target: document.getElementById('location'),
        coordinateFormat: ol.coordinate.createStringXY(5),
        undefinedHTML: '&nbsp;'
      });
      var untiled = new ol.layer.Image({
        source: new ol.source.ImageWMS({
          ratio: 1,
          url: 'http://localhost:8080/geoserver/scmap/wms',
          params: {'FORMAT': format,
                   'VERSION': '1.1.1',  
                "STYLES": '',
                "LAYERS": 'scmap:scmap',
                "exceptions": 'application/vnd.ogc.se_inimage',
          }
        })
      });
      var tiled = new ol.layer.Tile({
        visible: false,
        source: new ol.source.TileWMS({
          url: 'http://localhost:8080/geoserver/scmap/wms',
          params: {'FORMAT': format, 
                   'VERSION': '1.1.1',
                   tiled: true,
                "STYLES": '',
                "LAYERS": 'scmap:scmap',
                "exceptions": 'application/vnd.ogc.se_inimage',
             tilesOrigin: 97.352221 + "," + 26.049173
          }
        })
      });
      var projection = new ol.proj.Projection({
          code: 'EPSG:4326',
          units: 'degrees',
          axisOrientation: 'neu',
          global: true
      });
      var map = new ol.Map({
        controls: ol.control.defaults({
          attribution: false
        }).extend([mousePositionControl]),
        target: 'map',
        layers: [
          untiled,
          tiled,
          //vector
        ],
        //overlays: [],  //popup overlay
        view: new ol.View({
           projection: projection
        })
      });
      map.getView().on('change:resolution', function(evt) {
        var resolution = evt.target.get('resolution');
        var units = map.getView().getProjection().getUnits();
        var dpi = 25.4 / 0.28;
        var mpu = ol.proj.METERS_PER_UNIT[units];
        var scale = resolution * mpu * 39.37 * dpi;
        if (scale >= 9500 && scale <= 950000) {
          scale = Math.round(scale / 1000) + "K";
        } else if (scale >= 950000) {
          scale = Math.round(scale / 1000000) + "M";
        } else {
          scale = Math.round(scale);
        }
        document.getElementById('scale').innerHTML = "Scale = 1 : " + scale;
      });
      map.getView().fit(bounds, map.getSize());
      map.on('singleclick', function(evt) {
        document.getElementById('nodelist').innerHTML = "Loading... please wait...";
        var view = map.getView();
        var viewResolution = view.getResolution();
        var source = untiled.get('visible') ? untiled.getSource() : tiled.getSource();
        var url = source.getGetFeatureInfoUrl(
          evt.coordinate, viewResolution, view.getProjection(),
          {'INFO_FORMAT': 'text/html', 'FEATURE_COUNT': 50});
        if (url) {
          document.getElementById('nodelist').innerHTML = '<iframe seamless src="' + url + '"></iframe>';
        }
      });


// ********************************************

  //     var vectorSource = new ol.source.Vector();
  //               var vector = new ol.layer.Vector({
  //                   source: vectorSource,
  //                   style: new ol.style.Style({
  //                       stroke: new ol.style.Stroke({
  //                           color: 'rgba(0, 0, 255, 1.0)',
  //                           width: 2
  //                       })
  //                   })
  //               });
  //               map.addLayer(vector);

  //               // generate a GetFeature request
  //               var featureRequest = new ol.format.WFS().writeGetFeature({
  //                   srsName: 'EPSG:4326',
  //                   featureNS: 'http://localhost:8080',    //命名空间
  //                   featurePrefix: 'scmap',               //工作区域
  //                   featureTypes: ['djs'],       //图层名
  //                   outputFormat: 'application/json',
  //                   filter:
  //                       ol.format.filter.equalTo('Name', '雅安市')
  //                       //ol.format.filter.equalTo('FeatureID', '11')    //todo 条件查询过滤
  // //                   filter: ol.format.filter.and(
  // //                        //ol.format.filter.intersects('the_geom', polygon, 'EPSG:4326'),
  // //                        ol.format.filter.equalTo('Name', '成都市')
  // // )
  //               });

               

  //               // then post the request and add the received features to a layer

  //               fetch('http://localhost:8080/geoserver/wfs', {
  //                   method: 'POST',
  //                   body: new XMLSerializer().serializeToString(featureRequest)
  //               })
  //               .then(function(response) {
  //                   return response.json()
  //               })
  //               .then(function(json) {
  //                   var features = new ol.format.GeoJSON().readFeatures(json);
  //                   vectorSource.addFeatures(features);
  //                   map.getView().fit(vectorSource.getExtent());
  //               });

// ********************************************

//       var vectorSource = new ol.source.Vector();
//                 var vector = new ol.layer.Vector({
//                     source: vectorSource,
//                     style: new ol.style.Style({
//                         stroke: new ol.style.Stroke({
//                             color: 'rgba(0, 0, 255, 1.0)',
//                             width: 2
//                         })
//                     })
//                 });
//                 map.addLayer(vector);

// var featureRequest = new ol.format.WFS().writeGetFeature({
//         srsName: 'EPSG:3857',
//         featureNS: 'http://localhost:8080/geoserver',
//         featurePrefix: 'scmap',
//         featureTypes: ['djs'],
//         outputFormat: 'application/json',
//         filter: andFilter(
//           likeFilter('Name', '成都市'),
//           equalToFilter('Name', '成都市')
//         )
//       });

//       // then post the request and add the received features to a layer
//       fetch('http://localhost:8080/mymap.jsp', {
//         method: 'POST',
//         body: new XMLSerializer().serializeToString(featureRequest)
//       }).then(function(response) {
//         return response.json();
//       }).then(function(json) {
//         var features = new GeoJSON().readFeatures(json);
//         vectorSource.addFeatures(features);
//         map.getView().fit(vectorSource.getExtent());
//       });


//***********************************

// function getWfsData(filter) {
//         //获取wms生成的资源url， fdLayer.getSource().getGetFeatureInfoUrl
//         var featureRequest = new ol.format.WFS().writeGetFeature({
//             srsName: 'EPSG:4326',//坐标系统
//             featureNS: 'scmap',//命名空间 URI
//             featurePrefix: 'scmap',//工作区名称
//             featureTypes: ['scmap:djs'],//查询图层，可以同一个工作区下多个图层，逗号隔开
//             outputFormat: 'application/json',
//             filter: filter
//         });
//         fetch(geourl + 'localhost:8080/mymap.jsp', {//geoserver wfs地址如localhost:8080/geoserver/wfs
//             method: 'POST',
//             body: new XMLSerializer().serializeToString(featureRequest)
//         }).then(function (response) {
//             return response.json();
//         }).then(function (json) {
//             //查询结果
//             console.log(json);
//             if (json.features && json.features.length > 0) {
//                 var gj = new ol.format.GeoJSON();
//                 var features=gj.readFeatures(json);
//             }
//         })
//    }

//    getWfsData()

   //************************




      // sets the chosen WMS version
      function setWMSVersion(wmsVersion) {
        map.getLayers().forEach(function(lyr) {
          lyr.getSource().updateParams({'VERSION': wmsVersion});
        });
        if(wmsVersion == "1.3.0") {
            origin = bounds[1] + ',' + bounds[0];
        } else {
            origin = bounds[0] + ',' + bounds[1];
        }
        tiled.getSource().updateParams({'tilesOrigin': origin});
      }

      // Tiling mode, can be 'tiled' or 'untiled'
      function setTileMode(tilingMode) {
        if (tilingMode == 'tiled') {
          untiled.set('visible', false);
          tiled.set('visible', true);
        } else {
          tiled.set('visible', false);
          untiled.set('visible', true);
        }
      }

      function setAntialiasMode(mode) {
        map.getLayers().forEach(function(lyr) {
          lyr.getSource().updateParams({'FORMAT_OPTIONS': 'antialias:' + mode});
        });
      }

      // changes the current tile format
      function setImageFormat(mime) {
        map.getLayers().forEach(function(lyr) {
          lyr.getSource().updateParams({'FORMAT': mime});
        });
      }

      function setStyle(style){
        map.getLayers().forEach(function(lyr) {
          lyr.getSource().updateParams({'STYLES': style});
        });
      }

      function setWidth(size){
        var mapDiv = document.getElementById('map');
        var wrapper = document.getElementById('wrapper');

        if (size == "auto") {
          // reset back to the default value
          mapDiv.style.width = null;
          wrapper.style.width = null;
        }
        else {
          mapDiv.style.width = size + "px";
          wrapper.style.width = size + "px";
        }
        // notify OL that we changed the size of the map div
        map.updateSize();
      }

      function setHeight(size){
        var mapDiv = document.getElementById('map');
        if (size == "auto") {
          // reset back to the default value
          mapDiv.style.height = null;
        }
        else {
          mapDiv.style.height = size + "px";
        }
        // notify OL that we changed the size of the map div
        map.updateSize();
      }

      function updateFilter(){
        if (!supportsFiltering) {
          return;
        }
        var filterType = document.getElementById('filterType').value;
        var filter = document.getElementById('filter').value;
        // by default, reset all filters
        var filterParams = {
          'FILTER': null,
          'CQL_FILTER': null,
          'FEATUREID': null,
          'NAME': null,
          'P':null,
        };
        if (filter.replace(/^\s\s*/, '').replace(/\s\s*$/, '') != "") {
          if (filterType == "cql") {
            filterParams["CQL_FILTER"] = filter;
          }
          if (filterType == "ogc") {
            filterParams["FILTER"] = filter;
          }
          if (filterType == "fid")
            filterParams["FEATUREID"] = filter;
          if (filterType == "name")
            filterParams["NAME"] = filter;
          if (filterType == "pop")
            filterParams["populatioin"] = filter;
          }
          
          // merge the new filter definitions
          map.getLayers().forEach(function(lyr) {
            lyr.getSource().updateParams(filterParams);
          });
        }

        function resetFilter() {
          if (!supportsFiltering) {
            return;
          }
          document.getElementById('filter').value = "";
          updateFilter();
        }

        // shows/hide the control panel
        function toggleControlPanel(){
          var toolbar = document.getElementById("toolbar");
          if (toolbar.style.display == "none") {
            toolbar.style.display = "block";
          }
          else {
            toolbar.style.display = "none";
          }
          map.updateSize()
        }

    </script>

<script type="text/javascript">

  function updateFilterByName() {

      var filterByName = document.getElementById('filterByName').value;
      if(filterByName === ''){
        // return;
        filterByName="+"
      }
       
      var xFeatureStyle = new ol.style.Style({
        image: new ol.style.Icon({
          opacity: 0.95,
          size: [52, 52],
          src: "map3.png"
        }),
      });

      // generate a GetFeature request
      var featureRequest = new ol.format.WFS().writeGetFeature({
        srsName: 'EPSG:4326',
        featureNS: 'http://localhost:8080',    //命名空间
        featurePrefix: 'scmap',               //工作区域
        featureTypes: ['djs'],       //图层名
        outputFormat: 'application/json',
        filter:
          ol.format.filter.like('Name', '*' + filterByName + '*')

        // ol.format.filter.and(
        //   ol.format.filter.like('Name', '*市'),
        //   ol.format.filter.equalTo('Name', '成都市')
        //     )
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

          map.on('click', function (e) {
            map.addOverlay(overlay);
            //在点击时获取像素区域
            var pixel = map.getEventPixel(e.originalEvent);
            map.forEachFeatureAtPixel(pixel, function (feature) {
              for (var itm of featuresList) {
                //coodinate存放了点击时的坐标信息
                var coodinate = e.coordinate;
                //设置弹出框内容，可以HTML自定义


                var content = document.getElementById("popup-content");

                //设置overlay的显示位置
                if (feature == itm) {
                  content.innerHTML = "<p>"+itm.get('name')+"("+
                  itm.getGeometry().getCoordinates()+")</p>";
                }
              }
              
              overlay.setPosition(coodinate);
              //显示overlay
              // map.addOverlay(overlay);
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


</script>

  </body>
</html>
