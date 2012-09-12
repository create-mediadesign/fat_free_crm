(function() {
  var ajaxChosen, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = this;

  ajaxChosen = (function(_super) {

    __extends(ajaxChosen, _super);

    ajaxChosen.name = 'ajaxChosen';

    ajaxChosen.prototype.activate_field = function() {
      if (this.options.show_on_activate && !this.active_field) {
        this.results_show();
      }
      return ajaxChosen.__super__.activate_field.apply(this, arguments);
    };

    function ajaxChosen(select, options, callback) {
      var chosen;
      this.options = options;
      ajaxChosen.__super__.constructor.call(this, select, options);
      chosen = $(this);
      select.next('.chzn-container').down('.chzn-search > input').observe('keyup', function() {
        var search_field, val;
        val = $(this).value.strip();
        if (window.ajaxChosenDelayTimer) {
          clearTimeout(window.ajaxChosenDelayTimer);
          window.ajaxChosenDelayTimer = null;
        }
        search_field = $(this);
        return window.ajaxChosenDelayTimer = setTimeout(function() {
          var query_key, success;
          if (val === search_field.readAttribute('data-prevVal')) {
            return false;
          }
          search_field.writeAttribute('data-prevVal', val);
          query_key = options.query_key || "term";
          (options.parameters || (options.parameters = {}))[query_key] = val;
          success = options.success;
          options.onSuccess = function(data) {
            var items;
            if (!(data != null)) {
              return;
            }
            select.childElements().each(function(el) {
              if (!el.selected) {
                return el.remove();
              }
            });
            items = callback ? callback(data.responseJSON) : data.responseJSON;
            $H(items).each(function(pair) {
              if (select.value !== pair.key) {
                return select.insert({
                  bottom: new Element("option", {
                    value: pair.key
                  }).update(pair.value)
                });
              }
            });
            val = search_field.value;
            select.fire("liszt:updated");
            search_field.value = val;
            chosen.winnow_results();
            if (success != null) {
              return success();
            }
          };
          return new Ajax.Request(options.url, options);
        }, 300);
      });
    }

    return ajaxChosen;

  })(Chosen);

  root.ajaxChosen = ajaxChosen;

}).call(this);