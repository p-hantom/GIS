function getFeature(){
    var url="get_data.jsp";
    $post(url, function(json){
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
    // alert("aadd")
    map.removeInteraction(draw);
    addInteraction(type);
    // alert("aa")
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

function drawStart(){
    // if(pointSelect){
    //     map.removeInteraction(pointSelect);
    // }
    
    console.log("start drawing");
}

function drawEnd(){
    console.log("end drawing");
    map.removeInteraction(draw);
}

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
        // if(selected==0){
        //     return;
        // }
        let features = e.selected;
        let feature = features[0];
        console.log("feature: " + feature);
        if(feature != undefined){
            console.log("get feature: " + feature);
            console.log("getWKT=" + getWKT(feature));
            let coordinate = e.mapBrowserEvent.coordinate;
            let hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate,'EPSG:3857','EPSG:4326'));
            let html = "<div>请输入名字：<input type='text' id='drawMapFeature_name'><p>坐标是：<p>获得的WKT: </p></p></div>"
            console.log("coordinate = "+coordinate);
            //popup
            // let tmp=MapPopup()
            // tmp.init()
            //tmp.popup(map,coordinate,html);
            //MapPopup()//.init()
            //MapPopup().popup()
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