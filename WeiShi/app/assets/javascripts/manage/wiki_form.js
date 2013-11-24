$( document ).ready(function() {

  // show the preview content while first run.
  preview_content();

  // show the relevant categories list if the check box was checked
  $('input[name="wiki[school_ids][]"]').each(function(){
    hanlde_the_school_check_box_checked(this);
  });

  // set up the check box click listener
  $('input[name="wiki[school_ids][]"]').click(function(){
    hanlde_the_school_check_box_checked(this);
  });

  $('#btn_preview').click(function(){
    preview_content();
    return false;
  });

  $('#btn_submit').click(function(){
    $('form').submit();
    return false;
  });

  // preview the content on the pages.
  function preview_content(){
    $("#preiview_title").text($("#wiki_title").val());
    $("#preview_time").text($("#wiki_author").val() + " " + get_date());
    content = CKEDITOR.instances.wiki_content.getData();
    $('#preview_content').html(content);
    $(document).scrollTop(200);
  }

  function get_date(){
    d = new Date();
    curr_date = d.getDate();
    curr_month = d.getMonth() + 1;
    curr_year = d.getFullYear();
    return curr_year + "-" + curr_month + "-" + curr_date;
  }

  function hanlde_the_school_check_box_checked(check_box_object){
      append_object = $("#wiki_categoires_" + check_box_object.value);
      if(check_box_object.checked == true){
        append_categories_select($(check_box_object).parent(), append_object);
      }else{
        append_object.css('display','none');
      }
  }

  /**
   * add the categories list after the check box object;
   * @param  {[type]} object_to_append       the check box object;
   * @param  {[type]} categories_list_object the categories list object;
   * @return {[type]}                        none;
   */
  function append_categories_select(object_to_append, categories_list_object){
      categories_list_object.css('display','block');
      append_object_html = document.getElementById(categories_list_object.attr("id")).outerHTML;
      object_to_append.after(append_object_html);
      categories_list_object.remove();
  }

});