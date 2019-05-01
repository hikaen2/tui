// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(function () {

    $('#myTable').DataTable();

    $("select#kifu").change(function () {
        const url = 'partial/' + $(this).data('filename') + '/' + this.value;
        $.get(url, function (data) {
            $('#board').html(data);
        });
    });
});
