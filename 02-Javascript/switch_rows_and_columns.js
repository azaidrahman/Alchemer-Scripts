$(document).ready(function () {
  if (window.matchMedia("(min-width: 1024px)").matches) {
    $(function () {
      var table = $(".sg-table");
      table.find("thead tr").detach().prependTo(table.find("tbody"));
      var t = table.find("tbody").eq(0);
      var r = t.find("tr");
      var cols = r.length;
      var rows = r.eq(0).find("td,th").length;
      var cell,
        next,
        tem,
        i = 0;
      var tb = $("<tbody></tbody>");

      while (i < rows) {
        cell = 0;
        tem = $("<tr></tr>");
        while (cell < cols) {
          next = r.eq(cell++).find("td,th").eq(0);
          tem.append(next);
        }
        tb.append(tem);
        ++i;
      }
      table.find("tbody").remove();
      $(tb).appendTo(table);
      $(table)
        .find("tbody tr:eq(0)")
        .detach()
        .appendTo(table.find("thead"))
        .children()
        .each(function () {
          $(this).replaceWith('<th scope="col">' + $(this).html() + "</th>");
        });
      $(table)
        .find("tbody tr th:first-child")
        .each(function () {
          $(this).replaceWith('<td scope="row">' + $(this).html() + "</td>");
        });
      table.show();
    });

    $("td").click(function () {
      $selector = $(this).parent("tr").children().index($(this)) + 1;

      //$(".sg-table tr td:nth-child("+$selector+")").fadeTo(300,0.4); //optional fading of column after ticking script for usability
    });

    $(".sg-type-table-radio input:radio").unbind();
  }
});
