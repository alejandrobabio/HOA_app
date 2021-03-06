// Generated by CoffeeScript 1.6.3
(function() {
  var Hangout,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Hangout = (function() {
    function Hangout(gapi) {
      var _this = this;
      this.gapi = gapi;
      this.notify = __bind(this.notify, this);
      this.changeStatus = __bind(this.changeStatus, this);
      this.status = 'started';
      this.gapi.hangout.onApiReady.add(function() {
        return _this.gapi.hangout.onair.onBroadcastingChanged.add(_this.changeStatus);
      });
      setInterval(this.send_interval, 10000);
    }

    Hangout.prototype.changeStatus = function(e) {
      var prev_status;
      prev_status = this.status;
      if (e.isBroadcasting) {
        if (this.status === 'started') {
          this.status = 'broadcasting';
        }
      } else {
        if (this.status === 'broadcasting') {
          this.status = 'finished';
        }
      }
      if (prev_status !== this.status) {
        return this.notify();
      }
    };

    Hangout.prototype.notify = function() {
      return $('#main').append("<p>change status: " + this.status + "</p>");
    };

    Hangout.prototype.send_interval = function() {
      console.log(this.gapi.hangout.onair);
      console.log(this.gapi.hangout.onair.isBroadcasting());
      return $('#main').append("<p>10 sec, Broadcasting: " + (this.gapi.hangout.onair.isBroadcasting()) + "</p>");
    };

    return Hangout;

  })();

  $(function() {
    return gadgets.util.registerOnLoadHandler(new Hangout(gapi));
  });

}).call(this);
