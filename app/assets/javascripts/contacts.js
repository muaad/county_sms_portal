$('#toggle_contacts').change(function(e) {
  if (this.checked) {
    $('.contacts_table').checkboxes('check');
    e.preventDefault();
  }
  else {
    $('.contacts_table').checkboxes('uncheck');
    e.preventDefault();
  }
});

$('#delete-contacts').click(function(){
  if ($(".contacts_table input:checked").length < 1)
  {
    alert("You have not selected any contacts to be deleted.");
    return false;
  }
  else
  {
    contacts_array = []
    $(".contacts_table input:checked").each(function(){
      contacts_array.push($(this).attr('value'))
    });
    $('#delete_contacts').val(contacts_array);
    // contact_num = ("#contacts_table input:checked").length;
    $('#delete_modal #lbl-msg').html('You are about to delete '+String(contacts_array.length)+' contacts');
    $('#delete_modal')
    .modal('setting', {
      onApprove: function(){
        $(this).find('form').submit();
      }
    })
    .modal('show');
  }
});

$('#add_to_group').click(function(){
  if ($(".contacts_table input:checked").length < 1)
  {
    alert("You have not selected any contacts.");
    return false;
  }
  else
  {
    contacts_array = []
    $(".contacts_table input:checked").each(function(){
      contacts_array.push($(this).attr('value'))
    });
    $('#contacts').val(contacts_array);
    // contact_num = ("#contacts_table input:checked").length;
    $('#class_modal #lbl-msg').html('You are about to add '+String(contacts_array.length)
      +' contacts to another class. Select from the dropdown below:');
    $('#class_modal')
    .modal('setting', {
      onApprove: function(){
        $(this).find('form').submit();
      }
    })
    .modal('show');
  }
});