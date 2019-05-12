

// var MapPopup=function(){
//     var container=document.getElementById('popup1');
//     var content=document.getElementById('popup-content1');
//     var closer=document.getElementById('popup-closer1');
//     alert("var")
//     var popup=undefined;
//     var init=function(){
//         alert("init")
//         container=document.getElementById('popup1');
//         content=document.getElementById('popup-content1');
//         console.log(content)
//         closer=document.getElementById('popup-closer1');
       
//         popup=new ol.Overlay({
//             element: container,
//             autoPan: true,
//             positioning: 'bottom-center',
//             stopEvent: true,
//             autoPanAnimation: {duration: 250}
//         });
//         // alert("init")
//     };
//     alert("closer.onclick")
//     closer=document.getElementById('popup-closer1');
//     alert(closer)
//     closer.onclick=function(){
//         removePopup();
//     };
//     var removePopup=function(){
//         popup.setPosition(undefined);
//         map.removeOverlay(popup);
//     };
//     var popupMsg=function(map,coordinate,html){
//         content.innerHTML=html;
//         console.log("popupMsg:"+coordinate);
//         popup.setPosition(coordinate);
//         map.addOverlay(popup);
//         console.log(popup)
//     };
//     return {
//         init: function(){
//             init();
//         },
//         onMouseClick: function(evt){
//             onMouseClick(evt);
//         },
//         removePopup: function(){
//             removePopup();
//         },
//         popup: function(map,coordinate,html){
//             popupMsg(map,coordinate,html)
//         }
//     };
// }

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
    
    console.log('init1111')
    // map.removeInteraction(pointSelect);
    // var container=document.getElementById('popup1');
    // var content=document.getElementById('popup-content1');
    // var closer=document.getElementById('popup-closer1');
    // alert(document.getElementById('wrapper'))
    // var popup=undefined;
    
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
    
    // popup=new ol.Overlay({
    //     element: container,
    //     autoPan: true,
    //     positioning: 'bottom-center',
    //     stopEvent: true,
    //     autoPanAnimation: {duration: 250}
    // });
    // popupMsg1(map,coordinate,html)
    // alert("init")
};