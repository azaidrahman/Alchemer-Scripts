$(document).ready(function () {
  //if (window.matchMedia("(min-width: 1024px)").matches) {
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
      let rafId = null;

      // Create a placeholder to prevent content jump
      const placeholder = $('<div>').height(header.outerHeight()).hide().insertBefore(table);

      // Capture original widths from the first row (header + first body row)
      const originalWidths = table.find('tr:first-child').find('th, td').map(function() {
        return $(this).outerWidth();
      }).get();

      function applyOriginalWidths() {
        header.find('th').each(function(index) {
          $(this).outerWidth(originalWidths[index]);
        });
        table.find('tbody tr:first-child td').each(function(index) {
          $(this).outerWidth(originalWidths[index + header.find('th').length]);
        });
      }

      function updateStickyHeader() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > tableTop && !isSticky) {
          header.css({
            position: 'fixed',
            top: '0',
            left: table.offset().left + 'px',
            width: table.outerWidth() + 'px',
            'background-color': 'white',
            'z-index': 1000,
            transform: 'translateZ(0)'
          });
          placeholder.show();
          applyOriginalWidths();
          isSticky = true;
        } else if (scrollTop <= tableTop && isSticky) {
          header.css({
            position: '',
            top: '',
            left: '',
            width: '',
            'background-color': '',
            'z-index': '',
            transform: ''
          });
          placeholder.hide();
          header.find('th').css('width', '');
          table.find('tbody tr:first-child td').css('width', '');
          isSticky = false;
        }
        
        rafId = null;
      }

      function onScroll() {
        if (!rafId) {
          rafId = window.requestAnimationFrame(updateStickyHeader);
        }
      }

      window.addEventListener('scroll', onScroll, { passive: true });
      
      // Optimize resize handler
      let resizeTimeout;
      $(window).on('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
          // Recalculate original widths and update sticky header
          originalWidths.length = 0;
          table.find('tr:first-child').find('th, td').each(function() {
            originalWidths.push($(this).outerWidth());
          });
          if (isSticky) {
            applyOriginalWidths();
          }
          updateStickyHeader();
        }, 250);
      });

      updateStickyHeader(); // Initial call
    }

    // Run the sticky header function after any table transformation
    createStickyHeader();
  //}
});
