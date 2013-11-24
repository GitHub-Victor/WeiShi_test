  var color=new Array('#08c','#f0ad4e','#ac2925','#d58512','#463265','#999999','#5cb85c','#285e8e','#101010');
  var style=new Array('<p style="margin:0 0 10px 0;height:30px;"><span id="auther" style="background-color:#08c; color:#fff; float:left; padding:3px 25px; font-size:12px;"></span><span id="submitTime" style="color:#666;float:right; padding: 6px 5px;font-size: 12px;"></span></p><h3 id="title"></h3>','<h3 id="title"></h3><span id="auther"></span><span id="submitTime" style="padding-left:10px;"></span>','<h3 id="title" style="color:#000;padding-left:10px; padding-right:10px;border-right:7px #08c solid;"></h3><span id="auther" style="color:#999; padding:0 10px;"></span><span id="submitTime" style="color:#999;"></span>');
window.onload=function(){
    var header=document.getElementById('header');
    var colorSel=Math.floor((Math.random()*10)%(color.length));
    var styleSel=Math.floor((Math.random()*10)%(style.length));
    header.innerHTML="";
    header.innerHTML=style[styleSel];
    var title=document.getElementById('title');
    //var className=document.getElementById('className');
    var submitTime=document.getElementById('submitTime');
    var auther=document.getElementById('auther');
    switch(styleSel){
      case 0:
        header.style.backgroundColor='#fff';
        header.style.color='#000';
        header.style.padding='0 10px 15px';
        header.style.borderTop='3px '+color[colorSel]+' solid';
        header.style.borderBottom='1px #aaa solid';
        auther.style.backgroundColor=color[colorSel];
        break;
      case 1:
        header.style.backgroundColor=color[colorSel];
        break;
      case 2:
        header.style.backgroundColor='#fff';
        header.style.padding='25px 0 15px 0';
        title.style.borderRight='7px '+color[colorSel]+' solid';
        break;
      default:
        header.innerHTML="";
        header.innerHTML=style[1];
        header.style.backgroundColor=color[colorSel];
        break;
    }
    title.innerHTML=headerImf.title;
    //className.innerText=headerImf.className;
    submitTime.innerHTML=headerImf.time;
    auther.innerHTML=headerImf.auther;
    document.getElementById('commentBox').style.display='none';
    document.getElementById('sayBtn').onclick=function(){
      if(document.getElementById('commentBox').style.display=='none')
      {
        document.getElementById('commentBox').style.display='block';
        window.scrollTo(0,window.document.body.scrollHeight);
        document.getElementById('sayBtn').setAttribute('class','active');
        document.getElementById('sayBtn').style.color="#fff";
      }
      else
      {
        document.getElementById('sayBtn').setAttribute('class','');
        document.getElementById('sayBtn').style.color="#333";
        document.getElementById('commentBox').style.display='none';
      }
      return false;
    }
}