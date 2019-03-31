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

        document.getElementById("popup").style.display="none";

        //get djs points to calculate distance from
        var djsPointRequest = new ol.format.WFS().writeGetFeature({
          srsName: 'EPSG:4326',
          featureNS: 'http://localhost:8080',    //命名空间
          featurePrefix: 'scmap',               //工作区域
          featureTypes: ['djs'],       //图层名
          outputFormat: 'application/json',
          filter:
            ol.format.filter.like('Name', '*')
        });

        var djsPointList = [];

        fetch('http://localhost:8080/geoserver/wfs', {
          method: 'POST',
          body: new XMLSerializer().serializeToString(djsPointRequest)
        })
          .then(function (response) {
            return response.json()
          })
          .then(function (json){
            for (let item of json.features){
              let px = item.properties.POINT_X;
              let py = item.properties.POINT_Y;
              djsPointList.push({
                point: [px, py],
                name: item.properties.Name,
              })
            }
          });

        //console.log(djsPointList)