$(document).ready(function () {
  if (window.matchMedia("(min-width: 1024px)").matches) {
    // Table transformation script
    //(function () {
    //  var table = $(".sg-table");
    //  table.find("thead tr").detach().prependTo(table.find("tbody"));
    //  var t = table.find("tbody").eq(0);
    //  var r = t.find("tr");
    //  var cols = r.length;
    //  var rows = r.eq(0).find("td,th").length;
    //  var cell, next, tem, i = 0;
    //  var tb = $("<tbody></tbody>");
    //  while (i < rows) {
    //    cell = 0;
    //    tem = $("<tr></tr>");
    //    while (cell < cols) {
    //      next = r.eq(cell++).find("td,th").eq(0);
    //      tem.append(next);
    //    }
    //    tb.append(tem);
    //    ++i;
    //  }
    //  table.find("tbody").remove();
    //  $(tb).appendTo(table);
    //  $(table)
    //    .find("tbody tr:eq(0)")
    //    .detach()
    //    .appendTo(table.find("thead"))
    //    .children()
    //    .each(function () {
    //      $(this).replaceWith('<th scope="col">' + $(this).html() + "</th>");
    //    });
    //  $(table)
    //    .find("tbody tr th:first-child")
    //    .each(function () {
    //      $(this).replaceWith('<td scope="row" style="text-align: left">' + $(this).html() + "</td>");
    //    });
    //  table.show();
    //})();
    //
    //$("td").click(function () {
    //  var $selector = $(this).parent("tr").children().index($(this)) + 1;
    //  // $(".sg-table tr td:nth-child("+$selector+")").fadeTo(300,0.4); //optional fading of column after ticking script for usability
    //});
    //
    //$(".sg-type-table-radio input:radio").unbind();

     function createStickyHeader() {
      const table = $('.sg-table');
      const header = table.find('.sg-header-row-first');
      if (!header.length) return;

      const tableTop = table.offset().top;
      let isSticky = false;

      // Capture original widths from the first row (header + first body row)
      const originalWidths = table.find('tr:first-child').find('th, td').map(function() {
        return $(this).outerWidth();
      }).get();

      function updateStickyHeader() {
        const scrollTop = $(window).scrollTop();
        
        if (scrollTop > tableTop && !isSticky) {
          header.css({
            position: 'fixed',
            top: '0',
            left: table.offset().left + 'px',
            width: table.outerWidth() + 'px',
            'background-color': 'white',
            'z-index': 1000
          });
          
          // Apply original widths to maintain layout
          header.find('th').each(function(index) {
            $(this).outerWidth(originalWidths[index]);
          });

          // Apply widths to the first row of the table body to maintain alignment
          table.find('tbody tr:first-child td').each(function(index) {
            $(this).outerWidth(originalWidths[index + header.find('th').length]);
          });

          isSticky = true;
        } else if (scrollTop <= tableTop && isSticky) {
          header.css({
            position: '',
            top: '',
            left: '',
            width: '',
            'background-color': '',
            'z-index': ''
          });
          
          // Reset to original state
          header.find('th').css('width', '');
          table.find('tbody tr:first-child td').css('width', '');

          isSticky = false;
        }
      }

      $(window).on('scroll resize', updateStickyHeader);
      updateStickyHeader(); // Initial call
    }

    // Run the sticky header function after any table transformation
    createStickyHeader();
  }
});
