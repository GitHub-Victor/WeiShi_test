//= require 'jquery'
//= require active_admin/base
//= require 'china_city/jquery.china_city'

function move_to_list(source_list,target_list){
      $("#"+ source_list +" option:selected").each(function (i){
          $("#"+target_list).append("<option value=\""+ this.value +"\">"+this.text+"</option>");  
      }).remove();  
}

function select_all_options(target_list){
    $("#"+ target_list +" option").each(function (i){ 
      this.selected = true;
    });
    return true;
}

function filteroption(root) {  //初始化列表，参数为列表id
    var tempul;
    tempul = $("#" + root).clone(true);
    tempul.children().each(function() {
        var htmword = $(this).html();
        var supperword = "";
        $(this).attr("mka", (htmword).toLowerCase());
        $(this).attr("mkc", (supperword).toLowerCase());
    });
    window[root] = tempul;
}

//筛选符合的列表项
function resetOption(keys, root) {
    keys = keys.toLowerCase();
    $("#" + root).children().remove();
    var duplul = $(window[root]);
    if (keys.length <= 0) {
        duplul.children().each(function() {
        $("#" + root).append($(this).clone(true).removeAttr("mka").removeAttr("mkc"));  
        });
        return;
    }
    duplul.children('[mka*="' + keys + '"],[mkc*="' + keys + '"]').each(function() {
    $("#" + root).append($(this).clone(true).removeAttr("mka").removeAttr("mkc"));
    });
}