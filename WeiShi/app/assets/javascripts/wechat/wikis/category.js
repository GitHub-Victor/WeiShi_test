if(document.getElementById('title').clientHeight>58||document.getElementById('headerBox').clientHeight>100){
  var fontSize=45;
  var logoHeight=document.getElementById('right-logo').clientHeight;
  while(document.getElementById('title').clientHeight>58||document.getElementById('headerBox').clientHeight>100){
    document.getElementById('title').style.fontSize=(--fontSize)+'px';
  }
  document.getElementById('title').parentNode.style.marginTop=((logoHeight-document.getElementById('title').parentNode.clientHeight)/2)+'px';
}
function go(url){location.href= url;}
var color=new Array('#1687af');
//document.getElementById('footer').style.backgroundColor=color[Math.floor((Math.random()*10)%(color.length))];
document.getElementById('mtop').style.backgroundColor=color[Math.floor((Math.random()*10)%(color.length))];
//if(document.getElementById('title').clientHeight>58||document.getElementById('headerBox').clientHeight>100){setTimeout(init,200);}
/*
setTimeout(function(){document.getElementById('ptitle').style.height='0px';document.getElementsByClassName('pic')[0].style.transition='all 0.5s';document.getElementById('ptitle').style.transition='all 0.5s';document.getElementsByClassName('pic')[0].style.height='200px';setTimeout(function(){document.getElementById('ptitle').style.height='25px';document.getElementById('ptitle').style.opacity=0.8;},500);},1000);*/
//})();
if(document.getElementById('title').clientHeight>50||document.getElementById('headerBox').clientHeight>100)
if(navigator.appVersion.indexOf('HUAWEI')!=-1)
  location.reload();