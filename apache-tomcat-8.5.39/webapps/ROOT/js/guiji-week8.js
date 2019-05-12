//显示从江安图书馆到望江基础教学楼的轨迹
var vectorSource = new ol.source.Vector({});

var library=[103.997778, 30.559],jichulou=[104.078333, 30.634];
var p1=[104.003674,30.565043],p2=[104.026545,30.581210],p3=[104.023316,30.584303],
    p4=[104.041912,30.599176],p5=[104.080923,30.597883],p6=[104.084287,30.624376];

var lineFeature = new ol.Feature({
    geometry: new ol.geom.LineString(
      [library, p1,p2,p3,p4,p5,p6,jichulou])
  });
  lineFeature.setStyle(new ol.style.Style({
    stroke: new ol.style.Stroke({
      width: 3,
      color: [0, 200, 0, 1]
    })
  }));
  var lineSource = new ol.source.Vector({
    features: [lineFeature]
  });
  vectorSource.addFeature(lineFeature);

  var libraryFeature = new ol.Feature({  //图书馆图标
    geometry: new ol.geom.Point(library, "XY"),
    name: "library",
  });
  var libraryStyle = new ol.style.Style({
    image: new ol.style.Icon({
      opacity: 1,
      width: 45,
      src: "../img/library.png",
    }),
    text: new ol.style.Text({
        textAlign: "Start",
        textBaseline: "Middle",
        font: 'Normal 12px Arial',
        text: '四川大学江安图书馆',
        offsetX: -45,
        offsetY: 40,
        rotation: 0
      })
  });
  libraryFeature.setStyle(libraryStyle);
  vectorSource.addFeature(libraryFeature);

  var jichulouFeature = new ol.Feature({  //图书馆图标
    geometry: new ol.geom.Point(jichulou, "XY"),
    name: "jichulou",
  });
  var jichulouStyle = new ol.style.Style({
    image: new ol.style.Icon({
      opacity: 1,
      width: 45,
      src: "../img/jichulou.png"
    }),
    text: new ol.style.Text({
        textAlign: "Start",
        textBaseline: "Middle",
        font: 'Normal 12px Arial',
        text: '四川大学望江基础教学楼',
        offsetX: -45,
        offsetY: 40,
        rotation: 0
      })
  });
  jichulouFeature.setStyle(jichulouStyle);
  vectorSource.addFeature(jichulouFeature);

  var vectorLayer = new ol.layer.Vector({
    source: vectorSource,
    maxResolution: 0.00070,
    
  });



  map.addLayer(vectorLayer);