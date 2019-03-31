var coordSearchFeatureStyle = new ol.style.Style({
    image: new ol.style.Icon({
      opacity: 1,
      size: [52, 52],
      src: "./img/map2.png"
  })
});

function updateCoord(){
    var longitude = document.getElementById('longitude').value;
    var latitude = document.getElementById('latitude').value;

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

    

}

function resetCoord(){
    document.getElementById('longitude').value=''
    document.getElementById('latitude').value=''
    window.location.reload(true);
  }