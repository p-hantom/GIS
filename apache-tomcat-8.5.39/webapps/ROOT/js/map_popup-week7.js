var container=document.getElementById('popup1');
    var content=document.getElementById('popup-content1');
    var closer=document.getElementById('popup-closer1');
    var popup=undefined;
    document.getElementById('popup1').style.display = "none";    

var popupMsg1=function(map,coordinate,html){
    if(container){
        content.innerHTML=html;
        console.log("popupMsg:  "+coordinate);
        popup.setPosition(coordinate);
        map.addOverlay(popup);
        console.log("popup:  "+popup)
    }
    
};

var removePopup=function(){
    if(pointSelect){
        map.removeInteraction(pointSelect);
        console.log('map.removeInteraction(pointSelect)')
    }
    popup.setPosition(undefined);
    map.removeOverlay(popup);
};

var init1=function(map,coordinate,html){

    popup=new ol.Overlay({
        element: container,
        autoPan: true,
        positioning: 'bottom-center',
        stopEvent: true,
        autoPanAnimation: {duration: 250}
    });
    popupMsg1(map,coordinate,html)  //功能：addOverlay

    console.log('init1')
    if(document.getElementById('popup1')){
        //console.log(document.getElementById('popup1'))
        document.getElementById('popup1').style.display = "block";
        container = document.getElementById('popup1');
    }
    
    selected=0;
    container=document.getElementById('popup1');
    content=document.getElementById('popup-content1');
    console.log('content:   '+content)
    closer=document.getElementById('popup-closer1');
    if(closer){
        closer.onclick=function(){
            removePopup();
        };
    }

};