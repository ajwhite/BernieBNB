App.Visits = {};

App.Visits.init = function() {
  this.sDate = $('#visit_start_date');
  this.eDate = $('#visit_end_date');

  this.initDatepicker();

  $('.new_visit, .edit_visit').submit(function(event) {
    if(App.Visits.sDate.val() && App.Visits.eDate.val() === '') {
      App.Visits.eDate.val(App.Visits.sDate.val());
    }
  });
};

App.Visits.initDatepicker = function() {
  var start = this.sDate;
  var end = this.eDate;

  var dp = $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    minDate: 1,
    setDate: '02/20/16',
    // showWeek: true,
    weekHeader: '',
    beforeShowDay: function(date) {
      var elem = $(this).data('datepicker').settings;
      var sDate = elem.parseDate(start.val());
      var eDate = elem.parseDate(end.val());
      var highlight = sDate && ((date.getTime() == sDate.getTime()) || (eDate && date >= sDate && date <= eDate));
      return [true, highlight ? 'highlight' : ''];
    },
    parseDate: function(value) {
      var format = this.dateFormat || $.datepicker._defaults.dateFormat;
      return $.datepicker.parseDate(format, value, this);
    },
    onSelect: function(dateText, elem) {
      var startDate = elem.settings.parseDate(start.val());
      var endDate = elem.settings.parseDate(end.val());
      var date = elem.settings.parseDate(dateText);

      if(!startDate || endDate) {
        start.val(dateText);
        end.val('');
      }
      else if(date < startDate) {
        end.val(start.val());
        start.val(dateText);
      }
      else if(date.getTime() == startDate.getTime()) {
        start.val('');
        end.val('');
      }
      else {
        end.val(dateText);
      }
    }
  });

  if(start) {
    dp.datepicker('setDate', start.val());
  }
};
