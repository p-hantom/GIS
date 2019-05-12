
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
      border-top-color: #1a0505;
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


    /* popup week8 */
    .ol-popup1 {
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

    .ol-popup1:after,
    .ol-popup1:before {
      top: 100%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .ol-popup1:after {
      border-top-color: white;
      border-width: 10px;
      left: 48px;
      margin-left: -10px;
    }

    .ol-popup1:before {
      border-top-color: #1a0505;
      border-width: 11px;
      left: 48px;
      margin-left: -11px;
      
    }

    .ol-popup-closer1 {
      text-decoration: none;
      position: absolute;
      top: 2px;
      right: 8px;
    }

    .ol-popup-closer1:after {
      content: "close";
    }

    /*  */

    /* eagle eye */
    .ol-custom-overviewmap,
        .ol-custom-overviewmap.ol-uncollapsible {
            bottom: auto;
            left: auto;
            right: 0;
            /*右侧显示*/
            top: 0;
            /*顶部显示*/
        }
        /* 鹰眼控件展开时控件外框的样式 */

        .ol-custom-overviewmap:not(.ol-collapsed) {
            border: 1px solid black;
        }
        /* 鹰眼控件中地图容器的样式 */

        .ol-custom-overviewmap .ol-overviewmap-map {
            border: none;
            width: 300px;
        }
        /* 在鹰眼控件中显示当前窗口中主图区域的边框 */

        .ol-custom-overviewmap .ol-overviewmap-box {
            border: 2px solid red;
        }
        /* 在鹰眼控件张开时其控件按钮图标的样式 */

        .ol-custom-overviewmap:not(.ol-collapsed) button {
            bottom: auto;
            left: auto;
            right: 1px;
            top: 1px;
        }

        #scalebar
        {
            float:left;
            margin-bottom:10px;
            z-index:2000;
        }

    </style>


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
      <p>输入城市名：</p>
      <input type="text" size="80" id="filterByName" value=""/> 
      <a id="updateFilterByNameButton" href="#" onClick="updateFilterByName()" title="Apply filter">Search</a>
      <a id="resetFilterByNameButton" href="#" onClick="resetFilterByName()" title="Reset filter">Reset</a>
    </div>

    <div>
      <p>enter a longitude:</p>
      <input type="text" size="80" id="longitude" value=""/> 
      <p>enter a latitude:</p>
      <input type="text" size="80" id="latitude" value=""/> 
      <a id="updateCoordButton" href="#" onClick="updateCoord()" title="Apply filter">Search</a>
      <a id="resetCoordButton" href="#" onClick="resetCoord()" title="Reset filter">Reset</a>
    </div>

    <!-- *********** -->
    

    <div id="map">
      <div class="ol-toggle-options ol-unselectable"><a title="Toggle options toolbar" onClick="toggleControlPanel()" href="#toggle">...</a></div>
      <div id="command_panel">
        <div>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" value="画点" onclick="drawFeature('Point');">
          <input type="button" value="画线" onclick="drawFeature('LineString');">
          <input type="button" value="画矩形" onclick="drawFeature('Polygon');">
          <input type="button" value="选择物体" onclick="pointSelect1();">
        </div>
      </div>
    </div>

    <div id="popup1" class="ol-popup1">
        <a href="#" id="popup-closer1" class="ol-popup-closer1"></a>
        <div id="popup-content1" class="ol-popup-content1"></div>
        <hr>
        <div id="popup-content-bottom1">
          <input type="button" value="save" onclick="saveFeature();">
        </div>
     
    </div>

    <div id="wrapper" >
        <div id="location"></div>
        <div id="scale">
            <!-- <div id="popup1">
                <a href="#" id="popup-closer1"></a>
                <div id="popup-content1" ></div>
                <hr>
                <div id="popup-content-bottom1">
                  <input type="button" value="save" onclick="saveFeature();">
                </div>
              </div> -->
        <!-- <div id="popup1" class="ol-popup1">
          <a href="#" id="popup-closer1" class="ol-popup-closer1"></a>
          <div id="popup-content1" class="ol-popup-content1"></div>
          <hr>
          <div id="popup-content-bottom1">
            <input type="button" value="save" onclick="saveFeature();">
          </div>
       
      </div> -->
    </div>


    <div id="nodelist">
        <em>Click on the map to get feature info</em>
    </div>

    <script type="text/javascript" src="js/loadPage-week8.js"></script>
    <script type="text/javascript" src="js/map_popup.js"></script>
    <script type="text/javascript" src="js/drawMapFeature-week8.js"></script>


    <script type="text/javascript" src="js/searchCoord-week8.js" ></script>

    <script type="text/javascript" src="js/searchName-week8.js"></script>
    <script type="text/javascript" src="js/eagleEye-week8.js"></script>
    <script type="text/javascript" src="js/guiji-week8.js"></script>

  </body>
</html>
